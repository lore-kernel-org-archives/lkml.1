Return-Path: <linux-kernel-owner+w=401wt.eu-S1161098AbXBAChF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161098AbXBAChF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 21:37:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161018AbXBAChF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 21:37:05 -0500
Received: from smtp.osdl.org ([65.172.181.24]:38234 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161098AbXBAChB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 21:37:01 -0500
Date: Wed, 31 Jan 2007 18:36:35 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?ISO-8859-1?Q?S=2E=C3a=C4lar_Onur?= <caglar@pardus.org.tr>
cc: lkml <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: Linux 2.6.20-rc7
In-Reply-To: <200702010416.59469.caglar@pardus.org.tr>
Message-ID: <Pine.LNX.4.64.0701311828540.3632@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0701302019530.11095@woody.linux-foundation.org>
 <200702010416.59469.caglar@pardus.org.tr>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463790079-410112694-1170297395=:3632"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463790079-410112694-1170297395=:3632
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT



On Thu, 1 Feb 2007, S.ÃaÄlar Onur wrote:
> 
> For me, both 2.6.20-rc6 and 2.6.20-rc7 fails while booting with initramfs 
> (initramfs that uses busybox) with "request_module: runaway loop modprobe 
> binfmt-0000" error. 

That _usually_ just means that /sbin/modprobe is corrupt, or compiled with 
a binfmt that itself needs a module to load.

Are you 100% certain that you didn't just happen to put an /sbin/modprobe 
into your initramfs that happens to be a.out, with a.out being modular? Or 
something similarly silly?

Actually, with that "binfmt-0000", I guess the most likely thing is a 
corrupt /sbin/modprobe that isn't a valid binfmt format at all (but the 
kernel won't know the difference between a missing binfmt thing and an 
invalid one). It has bytes 2/3 being zero, which is neither ELF nor 
a.out, methinks.

BUT! If that's not it, doing a "git bisect" to figure out exactly what 
triggered it would be a wonderful idea..

		Linus
---1463790079-410112694-1170297395=:3632--
