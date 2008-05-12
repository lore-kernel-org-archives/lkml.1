Return-Path: <linux-kernel-owner+w=401wt.eu-S1759655AbYELGws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759655AbYELGws (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 02:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755332AbYELGwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 02:52:36 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:59800 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755553AbYELGwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 02:52:35 -0400
Date: Mon, 12 May 2008 08:52:33 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Sam Ravnborg <sam@ravnborg.org>, Mikael Pettersson <mikpe@it.uu.se>,
       tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: 2.6.26-rc1 on x86: ld: warning: dot moved backwards before
	`.text'
Message-ID: <20080512065233.GA24012@elf.ucw.cz>
References: <18470.787.498329.144701@harpo.it.uu.se> <48273A32.5020104@zytor.com> <20080511182905.GD6942@cvg> <200805112322.53473.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805112322.53473.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2008-05-11 23:22:52, Rafael J. Wysocki wrote:
> On Sunday, 11 of May 2008, Cyrill Gorcunov wrote:
> > [H. Peter Anvin - Sun, May 11, 2008 at 11:25:54AM -0700]
> > > Cyrill Gorcunov wrote:
> > >> Hi Peter,
> > >> actually I only doubt about exactly position of this headers - I mean
> > >> meguess it better should be _before_ "_end" not after. Since the others
> > >> script uses (acpi/wakeup_rm.S):
> > >> 	wakeup_code_start:
> > >> 	.incbin	"arch/x86/kernel/acpi/realmode/wakeup.bin"
> > >> 	wakeup_code_end:
> > >> and kernel uses these wakeup_code_* marks to save/restore memory I think
> > >> it should be like
> > >> 	. = HEADER_OFFSET;
> > >> 	.header : {
> > >> 		...
> > >> 	}
> > >> 	. = ALIGN(16);
> > >> 	_end = .;
> > >> 	/DISCARD/ ...
> > >
> > > Yes, I believe that's correct.
> > >
> > > 	-hpa
> > >
> > 
> > Thanks for review, Peter, I'll cook a patch and wait for
> > Pavel's opinion ;-)
> 
> I've tested the appended one.  If that's what you mean, we'll ask Ingo to take
> it.

ACK... and thanks!
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
