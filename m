Return-Path: <linux-kernel-owner+w=401wt.eu-S1760220AbXHFTJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760220AbXHFTJJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 15:09:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760898AbXHFTIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 15:08:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57458 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758902AbXHFTIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 15:08:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: suspend-devel@lists.sourceforge.net
Subject: Re: [Suspend-devel] Linux 2.6.23-rc2
Date: Mon, 6 Aug 2007 21:17:49 +0200
User-Agent: KMail/1.9.5
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
References: <Pine.LNX.4.64.0708052005550.3772@boston.corp.fedex.com> <200708061326.25888.rjw@sisk.pl> <46B74F08.1050909@zytor.com>
In-Reply-To: <46B74F08.1050909@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708062117.50023.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 6 August 2007 18:40, H. Peter Anvin wrote:
> Rafael J. Wysocki wrote:
> > On Monday, 6 August 2007 02:36, Jeff Chua wrote:
> >> On 8/6/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >>
> >>> What does 's2ram -i' say about your machine?
> >> This machine can be identified by:
> >>     sys_vendor   = "LENOVO"
> >>     sys_product  = "1702E7A"
> >>     sys_version  = "ThinkPad X60s"
> >>     bios_version = "7BETD0WW (2.11 )"
> > 
> > This means it's not in the whitelist, AFAICS.
> > 
> > Similar machines are known to work with "--acpi_sleep=3" or with
> > "--acpi_sleep=1 --vbe_mode".
> > 
> 
> I'm not all that familiar with s2ram.

It's just a wrapper around the kernel's suspend code that allows you to restore
the state of the graphics by running some additional code in real mode from
the user space.

> Any feel for why the behaviour would have changed from the old setup code at
> all?

With "--vbe_mode" s2ram saves the VBE mode setting before the suspend and sets
it to the same value after the resume.  Thus, it seems that the VBE mode
setting was previously preserved across the suspend/resume cycle and now it is
not.

Running s2ram with "--acpi_sleep 1" is equivalent to echoing 1 to
/proc/sys/kernel/acpi_video_flags before the suspend.

> Since the setup code isn't entered on resume from STR (unlike resume from
> STD), as far as I know, there can only be "some little bit of state" hanging
> around. 

The real mode code executed during resume is in
arch/x86_64/kernel/acpi/wakeup.S or in arch/i386/kernel/acpi/wakeup.S ,
depending on the architecture.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
