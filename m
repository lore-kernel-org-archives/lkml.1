Return-Path: <linux-kernel-owner+w=401wt.eu-S1756173AbXLHKun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173AbXLHKun (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 05:50:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752394AbXLHKuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 05:50:35 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3289 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751632AbXLHKue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 05:50:34 -0500
Date: Sat, 8 Dec 2007 10:50:19 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Christoph Hellwig <hch@infradead.org>,
       Jan Engelhardt <jengelh@computergmbh.de>, Greg KH <greg@kroah.com>,
       Jon Masters <jonathan@jonmasters.org>, Valdis.Kletnieks@vt.edu,
       Al Viro <viro@ftp.linux.org.uk>,
       Casey Schaufler <casey@schaufler-ca.com>,
       "Tvrtko A. Ursulin" <tvrtko.ursulin@sophos.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Out of tree module using LSM
Message-ID: <20071208105018.GA4381@ucw.cz>
References: <20071128183040.GW8181@ftp.linux.org.uk> <20071129003840.GA22530@kroah.com> <Pine.LNX.4.64.0711290152470.22052@fbirervta.pbzchgretzou.qr> <20071129010753.GA19106@kroah.com> <1196354172.6473.52.camel@perihelion> <20071129164746.GB9664@kroah.com> <Pine.LNX.4.64.0711291752550.13075@fbirervta.pbzchgretzou.qr> <20071129165731.GA30719@infradead.org> <20071129172740.2515fa75@the-village.bc.nu> <p73ir3ky7yz.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73ir3ky7yz.fsf@bingen.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2007-11-29 23:58:44, Andi Kleen wrote:
> Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
> >
> > The simple case is
> > 	open
> > 	write cathedral and bazaar in some order
> > 	close
> > 	<trap close -> process -> label eric_t>
> >
> > 	open (eric_t) - SELinux "no"
> >
> >
> > Anyone smart will then write it out of order and keep the file open, or
> 
> That would assume Eric already has a program running on your system
> optimized to inject his works in a obfuscated way. And if he has a
> program running he can do nearly everything already.  You already
> lost the game.
> 
> The normal case Tvrtko et.al. are trying to handle would be more the
> work getting downloaded from somewhere or read from a usb stick using
> normal programs like web browsers or file managers who don't do any
> out of order writing tricks and other obfuscation.

Fortunately normal programs tend to be dynamically linked, so
LD_PRELOAD is fine to handle them. And we know we can't handle nasty
programs. Seems like LD_PRELOAD is the way to go.

							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
