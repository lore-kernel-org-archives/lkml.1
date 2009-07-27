Return-Path: <linux-kernel-owner+w=401wt.eu-S1752997AbZG0QVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997AbZG0QVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 12:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbZG0QVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 12:21:52 -0400
Received: from ox1.aei.mpg.de ([194.94.224.6]:53577 "EHLO ox1.aei.mpg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811AbZG0QVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 12:21:51 -0400
Date: Mon, 27 Jul 2009 18:20:44 +0200
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Ferenc Wagner <wferi@niif.hu>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bisected] [Bug #13821] Replugging USB serial converter uses
	new device node
Message-ID: <20090727162044.GA9657@Pilar.aei.mpg.de>
References: <Pine.LNX.4.44L0.0907271131100.5217-100000@iolanthe.rowland.org> <87zlaqcec1.fsf@tac.ki.iif.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zlaqcec1.fsf@tac.ki.iif.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 27.Jul'09 at 17:53:18 +0200, Ferenc Wagner wrote:
> Alan Stern <stern@rowland.harvard.edu> writes:
> >
> > Are you certain this really is a regression?  Under 2.6.30 and 2.6.27
> > the same thing happened if I unplugged a USB serial device while it was
> > in use.
> 
> My original report is about unplugging the USB servial device *after*
> using it.

Yes, I did this:

     1) plug the surfstick
     2) connect to the internert (with draknetcenter)
     3) disconnect (and wait a bit)
     4) unplug the surfstick (and wait a bit)

Then when I plug it again, the devices created are /dev/ttyUSB{1,2} instead
of /dev/ttyUSB{0,1}.

That breaks 'draknetcenter', because if I try to connect again it
says that /dev/ttyUSB0 can not be found.

And during the bisection, for the commits which were marked "good", there
was no problem to reconnect and 'draknetcenter' was happy (although perhaps
it should not be so dependent on /dev/tttyUSB0 only, but that is another
story).
