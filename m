Return-Path: <linux-kernel-owner+w=401wt.eu-S1767650AbXDFN6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767650AbXDFN6y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 09:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767657AbXDFN6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 09:58:54 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:43816 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1767650AbXDFN6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 09:58:52 -0400
Date: Wed, 4 Apr 2007 10:01:40 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Cc: Paul LeoNerd Evans <leonerd@leonerd.org.uk>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] vt: Expose system-wide UTF-8 default setting via sysfs
Message-ID: <20070404080140.GC8256@elf.ucw.cz>
References: <4611ACCD.5000305@gmail.com> <20070403162051.GB5266@ucw.cz> <20070403163553.GO26707@cel.leo> <1175665163.4519.7.camel@daplas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1175665163.4519.7.camel@daplas>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > HPA is right... this should be fixed in userland. Reset should reset a
> > > console, and if you want utf-8, do \ec\ewhatever to get it.
> > 
> > As I've already said elsewhere, does anything say that "reset" means
> > that UTF-8 is turned off, or merely reset back to some known state? I
> > personally would consider that UTF-8 being on is the default, and if
> > something wants it off it should ask specifically..
> > 
> > Consider any other terminal emulator, such as those running on X11; when
> > they're reset, they know to keep UTF-8 mode turned on, because it said
> > so in their config, or in the locale. Kernel doesn't really have nice
> > access to the LANG environment variable, but we can give it something
> > similar; namely, via a module parameter.
> 
> I agree with Paul.  Reset or RIS is (R)eset to (I)nitial (S)tate,
> represented as ESC 06/03. "Initial state" is defined in ECMA-48 as the
> state of the device after it was made operational. It doesn't
> necessarily mean that the "initial state" is the safest configuration.
> So, if this "initial state" includes enabling UTF-8, then the device has
> to go into UTF-8 upon invoking RIS.

You could do that... during development series. But this is
userspace-visible API change, and those are not allowed during stable.

...and having /sysctl configuring inital state for reset is just plain
ugly.


									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
