Return-Path: <linux-kernel-owner+w=401wt.eu-S1761685AbXGWOoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761685AbXGWOoi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 10:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755024AbXGWOoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 10:44:30 -0400
Received: from ns1.suse.de ([195.135.220.2]:36278 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753942AbXGWOo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 10:44:29 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jakub Jelinek <jakub@redhat.com>
Subject: Re: vdso.so mislinked by buggy linker was Re: Linus 2.6.23-rc1
Date: Mon, 23 Jul 2007 16:44:25 +0200
User-Agent: KMail/1.9.6
Cc: Andre Noll <maan@systemlinux.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <200707230156.20276.ak@suse.de> <20070723124517.GS2063@devserv.devel.redhat.com>
In-Reply-To: <20070723124517.GS2063@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707231644.25539.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Looking at vdso.lds.S, if you change just VDSO_TEXT_OFFSET to 0xc00 and
> don't tweak the linker script, then you jump backwards with the dot, you
> should even get a linker warning about it:
> 
>   . = VDSO_PRELINK + VDSO_TEXT_OFFSET;
> 
>   .text           : { *(.text) }                :text
>   .text.ptr       : { *(.text.ptr) }            :text
>   . = VDSO_PRELINK + 0x900;
> 
> Guess that 0x900 should have been VDSO_TEXT_OFFSET + 0x400 or something
> similar.  Also note that it is highly desirable to fit the whole vdso into
> one page, so increasing VDSO_TEXT_OFFSET etc. offsets too much is just
> wasting memory.  From the above dump, VDSO_TEXT_OFFSET 0x500 is too low,
> but 0x600 should work, 

The reporter reported only 0xc00 worked, which is mysterious.

Also how do we get rid of the 1MB padding on those binutils? 

-Andi
