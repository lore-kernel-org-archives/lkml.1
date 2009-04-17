Return-Path: <linux-kernel-owner+w=401wt.eu-S1759080AbZDQCAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759080AbZDQCAm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 22:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755929AbZDQCAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 22:00:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:60171 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754458AbZDQCAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 22:00:16 -0400
Message-ID: <49E7E231.7080301@kernel.org>
Date: Thu, 16 Apr 2009 18:58:09 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: suresh.b.siddha@intel.com
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/8] irq: only update affinity in chip set_affinity()
 -v3
References: <49E68C41.4020801@kernel.org>  <49E68CD8.7060009@kernel.org> <1239924338.27006.8458.camel@localhost.localdomain>
In-Reply-To: <1239924338.27006.8458.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:
> On Wed, 2009-04-15 at 18:41 -0700, Yinghai Lu wrote:
>> Impact: keep affinity consistent
>>
>> irq_set_affinity() and move_masked_irq() try to assign affinity
>> before calling chip set_affinity(). some archs are assigning again in set_affinity
>> again.
>>
>> something like:
>> cpumask_cpy(desc->affinity, mask);
>> desc->chip->set_affinity(mask);
>>
>> in the failing path, affinity should not be touched.
>>
>> also set_extra_move_desc() ( called by set_affinity)  will rely on the old
>> affinity to decide if need to move irq_desc to different node when logical
>> flat apic mode is used.
>>
>> So try remove those assignment, and make some missed arch to assign affinity
>> in their set_affinity.
>>
> 
> I don't see any arch specific changes in this patchset regarding this.
> Did I miss or currently there are no arch's that needs to get fixed?
> 
will update the comments.

YH
