Return-Path: <linux-kernel-owner+w=401wt.eu-S1755378AbYDMSzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbYDMSzA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 14:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754684AbYDMSys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 14:54:48 -0400
Received: from rv-out-0708.google.com ([209.85.198.240]:54179 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754656AbYDMSyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 14:54:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hi4sUQ4O7vuZt/0u/BS60wmeCkAm93C1JioETI0zo8kLPZacl2swvGSE1nUE6z9vxIZvprh/UUgPfnx9YwzNlJO4LjRtorosnm1MLPNtg6e3Uz7ZEZ+V2fjFDX5RZtOrZttO+MWANVGN0mkqJfQPtDzOvSEkrfK2B0O8xBi+bNA=
Message-ID: <86802c440804131154t747cfc97u7316191282688bf8@mail.gmail.com>
Date: Sun, 13 Apr 2008 11:54:46 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: x86 git tree broken (bisected)
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Pavel Machek" <pavel@ucw.cz>,
       "Thomas Gleixner" <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>,
       "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <200804132047.10221.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804102159.14563.rjw@sisk.pl> <200804131812.55684.rjw@sisk.pl>
	 <86802c440804131107s7c132bc6j10ba713e50589353@mail.gmail.com>
	 <200804132047.10221.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2008 at 11:47 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> On Sunday, 13 of April 2008, Yinghai Lu wrote:
>  > On Sun, Apr 13, 2008 at 9:12 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>  > >
>  > > On Sunday, 13 of April 2008, Yinghai Lu wrote:
>  > >  > On Fri, Apr 11, 2008 at 1:51 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>  > >  > >
>  > >  > > On Friday, 11 of April 2008, Yinghai Lu wrote:
>  > >  > >  > On Fri, Apr 11, 2008 at 12:26 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>  > >  > >  > > On Friday, 11 of April 2008, Rafael J. Wysocki wrote:
>  > >  > >  > >  > On Thursday, 10 of April 2008, Ingo Molnar wrote:
>  > >  > >  > >  > >
>  > >  > >  > >  > > * Ingo Molnar <mingo@elte.hu> wrote:
>  > >  > >  > >  > >
>  > >  > >  > >  > > > > > > First, the X server doesn't want to start (it says it couldn't
>  > >  > >  > >  > > > > > > mmap the framebuffer).
>  > >  > >  > >  > > > > >
>  > >  > >  > >  > > > > > could you send your .config?
>  > >  > >  > >  > > > >
>  > >  > >  > >  > > > > Attached.
>  > >  > >  > >  > > >
>  > >  > >  > >  > > > could you disable this option:
>  > >  > >  > >  > > >
>  > >  > >  > >  > > >  CONFIG_NONPROMISC_DEVMEM=y
>  > >  > >  > >  > > >
>  > >  > >  > >  > > > does it help with the X problem?
>  > >  > >  > >  >
>  > >  > >  > >  > That didn't help.
>  > >  > >  > >  >
>  > >  > >  > >  > > btw., Xorg works fine here on a comparable AMD system - but i use a
>  > >  > >  > >  > > rather new distro (Fedora 8) which has Xorg 7.2.
>  > >  > >  > >  >
>  > >  > >  > >  > My system is an OpenSUSE 10.3 and it has Xorg 7.2 as well.
>  > >  > >  > >  >
>  > >  > >  > >  > I think the problem is somehow related to the Radeon.
>  > >  > >  > >
>  > >  > >  > >  The bisection turned up commit ea1441bdf53692c3dc1fd2658addcf1205629661
>  > >  > >  > >  "x86: use bus conf in NB conf fun1 to get bus range on, on 64-bit"  as the one
>  > >  > >  > >  causing problems.
>  > >  > >  > >
>  > >  > >  > >  Unfortunately, I can't revert cleanly it, because there are two more commits
>  > >  > >  > >  depending on it in a highly nontrivial fashion, so I have reverted all three
>  > >  > >  > >  commits
>  > >  > >  > >
>  > >  > >  > >  a365998cd2cecfb827469dbd57c29602c106cb83
>  > >  > >  > >  44f7f90fbe7a3a99aab082f765346514b7b5c705
>  > >  > >  > >  ea1441bdf53692c3dc1fd2658addcf1205629661
>  > >  > >  > >
>  > >  > >  > >  and X starts again.  Also, suspend to RAM works from under X.
>  > >  > >  >
>  > >  > >  > please keep the three patches and applied the two attached debug patches.
>  > >  > >  >
>  > >  > >  > i wonder if there is some io allocation overlapping with your system.
>  > >  > >
>  > >  > >  Attached is a boot dmesg output from the current x86 git tree with your two
>  > >  > >  patches applied.
>  > >  > >
>  > >  > can you try to apply the patch i sent to you about agp bridge order
>  > >  > reading for buggy silicon?
>  > >  >
>  > >  > Please boot kernel with "debug"...
>  > >  >
>  > >  > I want to verify if you can get
>  > >  >
>  > >  > "
>  > >  > Aperture conflicts with PCI mapping.
>  > >  > "
>  > >  >
>  > >  > in your boot log...
>  > >
>  > >  It's not present in there:
>  > >
>  > >  rafael@albercik:~> grep Aperture failing-with-patch-dmesg.log
>  > >  Aperture too small (32 MB)
>  > >  Aperture from AGP @ de000000 size 4096 MB (APSIZE 0)
>  > >  Aperture too small (0 MB)
>  > >  agpgart: Aperture pointing to RAM
>  > >  agpgart: Aperture from AGP @ de000000 size 4096 MB
>  > >  agpgart: Aperture too small (0 MB)
>  > >
>  >
>  > did you apply the patch like the attached that i sent you in another mail?
>
>  This dmesg is from a kernel without the patch.
>
>  The dmesg with the patch applied was sent in a separate message:
>  http://lkml.org/lkml/2008/4/13/122
>
or you can re pull from x86.git#latest.

YH
