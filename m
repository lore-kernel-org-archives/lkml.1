Return-Path: <linux-kernel-owner+w=401wt.eu-S935829AbZAPRxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935829AbZAPRxV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 12:53:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761012AbZAPRxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 12:53:03 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:52009 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758124AbZAPRxA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 12:53:00 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [PATCH v6 0/5] Add preadv & pwritev system calls.
Date: Fri, 16 Jan 2009 18:52:04 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linux-api@vger.kernel.org, aarcange@redhat.com,
       Ulrich Drepper <drepper@redhat.com>
References: <1232124344-25892-1-git-send-email-kraxel@redhat.com>
In-Reply-To: <1232124344-25892-1-git-send-email-kraxel@redhat.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901161852.04953.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/m+Ghs98ZN2y9a12nuAAvZqIdHOdxYNisjiaY
 kG3SszhOBKyqeK/7BgYh9sbdPn2aldrBaPiPZgDo9rycb8E5dR
 rV0i4MHsdVeqSoJZSbQIQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 January 2009, Gerd Hoffmann wrote:
> Next round of the preadv & pwritev patch series.  Had no review comments
> to fix.  That means it is ready to be merged, right?

In general, getting no feedback does not mean something's ready ;-)

Your patches look pretty polished though, and IIRC the only
real objection was to whether or not the syscalls should be
there in the first place. Did you get any feedback from Ulrich
Drepper as to whether he plans to add support to glibc?

> Changes:
>  - compat_sys_{read,write}v bugfix patch dropped (merged).
>  - rebase to latest git, adapt to CVE-2009-0029 changes.
> 
> How to proceed now?  Is there a syscall maintainer where I could queue
> up the patches?  If not, anyone (akpm?) willng to pick this up?  Should
> I try to send to Linus directly?
> 
> What is the usual way to handle the arch-specific syscall windup?  I'd
> prefer to leave that to the arch maintainers as they know best what
> needs to be done, is that ok?  Right now only x86 (/me) and mips (patch
> from Ralf Baechle) is covered ...

I'd say get it into linux-next as a git tree, then let the arch maintainers
send you the missing patches to hook up the syscalls so that it can go
in as one chunk.

Have you done the glibc patch already? You probably also need to provide
an alternative user space implementation based on a pread/pwrite loop for
older kernels.

	Arnd <><
