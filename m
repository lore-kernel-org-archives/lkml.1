Return-Path: <linux-kernel-owner+w=401wt.eu-S1759360AbZBXSCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759360AbZBXSCS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 13:02:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755984AbZBXSCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 13:02:04 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:44368 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752175AbZBXSCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 13:02:02 -0500
Date: Tue, 24 Feb 2009 19:01:59 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Paul Mackerras <paulus@samba.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@ucw.cz>,
       Mel Gorman <mel@csn.ul.ie>, linux-kernel <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, linux-ext4@vger.kernel.org
Subject: Re: Crash (ext3 ) during 2.6.29-rc6 boot
In-Reply-To: <18850.31567.212454.514549@cargo.ozlabs.ibm.com>
Message-ID: <alpine.LRH.2.00.0902241857170.544@vixen.sonytel.be>
References: <49A2705D.9030008@in.ibm.com> <20090223021320.11019d64.akpm@linux-foundation.org> <18850.31567.212454.514549@cargo.ozlabs.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Feb 2009, Paul Mackerras wrote:
> Andrew Morton writes:
> > It looks like we died in ext3_xattr_block_get():
> > 
> > 		memcpy(buffer, bh->b_data + le16_to_cpu(entry->e_value_offs),
> > 		       size);
> > 
> > Perhaps entry->e_value_offs is no good.  I wonder if the filesystem is
> > corrupted and this snuck through the defenses.
> > 
> > I also wonder if there is enough info in that trace for a ppc person to
> > be able to determine whether the faulting address is in the source or
> > destination of the memcpy() (please)?
> 
> It appears to have faulted on a load, implicating the source.  The
> address being referenced (0xc00000003f380000) doesn't look
> outlandish.  I wonder if this kernel has CONFIG_DEBUG_PAGEALLOC turned
> on, and what page size is selected?

I'm seeing a similar thing on PS3, but not in ext3. During early userspace
setup (udevd), it crashes accessing a 0xc00* address in:

| NIP setup+0x20/0x130
| LR copy_user_page+0x18/0x6c
| Call trace:
| do_wp_page+0x5b4/0x89c
| do_page_fault+0x3a8/0x58c
| handle_page_fault+0x20/0x5c

I have CONFIG_DEBUG_PAGEALLOC=y. If I disable it, the system boots fine.

If needed, I can probably bisect this tomorrow. It definitely didn't happen in
2.6.29-rc5.

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
