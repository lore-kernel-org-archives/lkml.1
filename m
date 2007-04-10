Return-Path: <linux-kernel-owner+w=401wt.eu-S1030410AbXDJGYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030410AbXDJGYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 02:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030413AbXDJGYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 02:24:42 -0400
Received: from rex.snapgear.com ([203.143.235.140]:41533 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030410AbXDJGYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 02:24:41 -0400
X-Greylist: delayed 1234 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Apr 2007 02:24:41 EDT
Message-ID: <461B28CE.7070704@snapgear.com>
Date: Tue, 10 Apr 2007 16:03:58 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: uclinux-dev@uclinux.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: m68knommu and vmlinux.lds.h RODATA
References: <20070409205347.GA32267@Krystal>
In-Reply-To: <20070409205347.GA32267@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mathieu,

Mathieu Desnoyers wrote:
> Is there any particular reason why m68knommu does not use the RODATA
> linker script macro defined in asm-generic/vmlinux.lds.h ? It makes it
> rather inconvenient to add new RO sections to the kernel.

This is going back some way, but this was the original commit message:

# --------------------------------------------
# 03/02/18	gerg@snapgear.com	1.984
# [PATCH] use local RODATA setup for m68knommu linker script
#
# This patch removes the use of the common RODATA define in the m68knommu
# architecture. It cannot be used the same way for the m68knommu target.
# For starters just inserting it here is syntactically wrong. All the read
# only parts are grouped into a single "text" segment, and this is the root
# cause of the problem. So for the m68knommu arch it makes sense to not
# use the generic RODATA setup, but to list them locally.

The problem looks to be the same today.

The current vmlinux.lds.S for m68knommu directs sections out to ROM
or RAM depending on whether we are building to be run from some type
of read only memory (ROM, FLASH, etc) or RAM. The RODATA macro as it
stands doesn't allow that.

Regards
Greg



------------------------------------------------------------------------
Greg Ungerer  --  Chief Software Dude       EMAIL:     gerg@snapgear.com
Secure Computing Corporation                PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
