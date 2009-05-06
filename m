Return-Path: <linux-kernel-owner+w=401wt.eu-S1756549AbZEFHIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549AbZEFHIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 03:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbZEFHIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 03:08:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:35277 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752376AbZEFHIC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 03:08:02 -0400
Message-ID: <4A0136F4.4010504@kernel.org>
Date: Wed, 06 May 2009 00:06:28 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: printk %0*X is broken.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

it seems someone broke 

printk(   "%0*X\n", width, x);

looks like 0 is dumped.

YH

[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0   00000000 mask FF0 00000000 write-back
[    0.000000]   1 base 10  00000000 mask FFF 80000000 write-back
[    0.000000]   2 base 0   80000000 mask FFF 80000000 uncachable
[    0.000000]   3 base 0   7F800000 mask FFF FF800000 uncachable


code:
        for (i = 0; i < num_var_ranges; ++i) {
                if (mtrr_state.var_ranges[i].mask_lo & (1 << 11))
                        printk(KERN_DEBUG "  %u base %0*X%05X000 mask %0*X%05X000 %s\n",
                               i,
                               high_width,
                               mtrr_state.var_ranges[i].base_hi,
                               mtrr_state.var_ranges[i].base_lo >> 12,
                               high_width,
                               mtrr_state.var_ranges[i].mask_hi,
                               mtrr_state.var_ranges[i].mask_lo >> 12,
                               mtrr_attrib_to_str(mtrr_state.var_ranges[i].base_lo & 0xff));
                else
                        printk(KERN_DEBUG "  %u disabled\n", i);
        }


