Return-Path: <linux-kernel-owner+w=401wt.eu-S1757444AbZFVRWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444AbZFVRWY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 13:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757319AbZFVRWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 13:22:07 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56613 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757218AbZFVRWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 13:22:06 -0400
Date: Mon, 22 Jun 2009 19:22:02 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Kosina <jkosina@suse.cz>
Cc: David Miller <davem@davemloft.net>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, swetland@google.com, arve@android.com,
       linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, san@android.com,
       rlove@google.com, Greg KH <greg@kroah.com>
Subject: Re: defkeymap making machine useless (was Re: HTC Dream aka.
	t-mobile g1 support)
Message-ID: <20090622172201.GA21153@elf.ucw.cz>
References: <d6200be20906171436y5280ed8do561d2d53d73ca78@mail.gmail.com> <20090618101309.GC28892@elf.ucw.cz> <a55d774e0906181233p35b60cd2ga401bd1304267643@mail.gmail.com> <20090618.123845.232783995.davem@davemloft.net> <20090618230704.GB8529@elf.ucw.cz> <alpine.LNX.2.00.0906221131380.7457@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.0906221131380.7457@wotan.suse.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-06-22 11:33:31, Jiri Kosina wrote:
> On Fri, 19 Jun 2009, Pavel Machek wrote:
> 
> > > > Yeah, I wasn't sure how to handle this.  We try to keep the 
> > > > msm/dream stuff in a state that doesn't break other parts of the 
> > > > tree, but there doesn't seem to be support for different keymaps for 
> > > > different devices.
> > > How it's supposed to work is that you have a specific keyboard driver 
> > > and that emits PC keyboard codes into the core kernel using a 
> > > translation table in your driver.
> > Of course, Dream does  that.  But that's not _nearly_ enough. Dream
> > lacks keys such as: esc, arrows, symbols (/;'[]\-=). That means that
> > for +, you can't press shift-=, you need to press altgr-P.
> 
> I don't seem to have enough context, but wouldn't writing a separate serio 
> driver, which would do all the needed translations be enough here?

Umm.

Yes, we could parse the keyboard combinations in the keyboard driver,
and then emulate the PC keyboard. It would be incredibly ugly. Such as:

If user presses Alt+I, (labeled "-" on keyboard), emulate "Shift+="
press, then let the defkeymap.map translate it back to "-".

I... guess it will be nicer if the keyboard driver specifies which
keymap to use?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
