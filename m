Return-Path: <linux-kernel-owner+w=401wt.eu-S1758425AbZBXQYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758425AbZBXQYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 11:24:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755008AbZBXQYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 11:24:41 -0500
Received: from outbound-mail-43.bluehost.com ([69.89.18.12]:40142 "HELO
	outbound-mail-43.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754843AbZBXQYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 11:24:40 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=i62QWQt+OpmRXhKw2//7e3ABJiSRLZzBjJNw2NrA/qP+32lmM6JxvBTYg1VzEXXKQELcxi3u7AqQPgCO5PS6pfBCUcRMFJNmSDr/1WnljG/JIMySuiwVG7jWOLyCTfWC;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: luis6674@yahoo.com
Subject: Re: [Bug #12337] ~100 extra wakeups reported by powertop
Date: Tue, 24 Feb 2009 08:24:31 -0800
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; x86_64; ; )
Cc: Eric Anholt <eric@anholt.net>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <819821.83409.qm@web53303.mail.re2.yahoo.com>
In-Reply-To: <819821.83409.qm@web53303.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902240824.32155.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 24, 2009 5:50:34 am Alberto Gonzalez wrote:
> --- On Tue, 2/24/09, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > > I really wish I could do more, but learning to compile
> >
> > a custom kernel for
> >
> > > my hardware and do a git bisect is something I just
> >
> > can't afford now. If
> >
> > > relevant people try to reproduce it but can't, and
> >
> > say only possible
> >
> > > solution would be for me to bisect it I guess I could
> >
> > try to give it a go
> >
> > > when I get some spare time.
> >
> > Fair enough. Reporting a problem is always very
> > appreciated.
> >
> > Pinging Eric and Jesse ;)
>
> Thank you Nick.
>
> Since Arch Linux is not popular among kernel developers I just tested
> Fedora 10 Live-CD (KDE) and I can reproduce the exact same problem, even if
> Fedora 10 has kernel 2.6.27 and for me the problem appeared in .28 (but I
> guess Fedora adds many patches, so probably the "guilty" commit was
> backported to 2.6.27.5-117-FC10-i686).
>
> Steps:
> - Boot into Fedora 10 Live CD (obviously, into the default graphical mode)
> - Install Powertop (yum install powertop) and run it
> - I get about 60 wakeups per second from i915@pci.... leaving the system
> idle - Switch to console and back to X. The wakeups are gone.

Ah ok, it sounds like you're getting vblank interrupts at startup time, but 
once you VT switch the kernel figures out that you don't need them, so it 
disables them.  I think this is a bug in the 2D driver; it has an ioctl it 
uses when doing modesetting which doubles as a "disabling the irq is ok" 
signal, but we call it at a time when the corresponding pipe is off, so the 
kernel ignores the call.

Can you file a bug for this at bugs.freedesktop.org?  Is it easy for you to 
rebuild & test xf86-video-intel driver patches?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
