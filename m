Return-Path: <linux-kernel-owner+w=401wt.eu-S934615AbXK2W66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934615AbXK2W66 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 17:58:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932857AbXK2W6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 17:58:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33278 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933553AbXK2W6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 17:58:47 -0500
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>,
       Jan Engelhardt <jengelh@computergmbh.de>, Greg KH <greg@kroah.com>,
       Jon Masters <jonathan@jonmasters.org>, Valdis.Kletnieks@vt.edu,
       Al Viro <viro@ftp.linux.org.uk>,
       Casey Schaufler <casey@schaufler-ca.com>,
       "Tvrtko A. Ursulin" <tvrtko.ursulin@sophos.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Out of tree module using LSM
From: Andi Kleen <andi@firstfloor.org>
References: <416908.77038.qm@web36613.mail.mud.yahoo.com>
	<20071128164613.GA21815@infradead.org>
	<25290.1196273705@turing-police.cc.vt.edu>
	<20071128183040.GW8181@ftp.linux.org.uk>
	<20071129003840.GA22530@kroah.com>
	<Pine.LNX.4.64.0711290152470.22052@fbirervta.pbzchgretzou.qr>
	<20071129010753.GA19106@kroah.com>
	<1196354172.6473.52.camel@perihelion>
	<20071129164746.GB9664@kroah.com>
	<Pine.LNX.4.64.0711291752550.13075@fbirervta.pbzchgretzou.qr>
	<20071129165731.GA30719@infradead.org>
	<20071129172740.2515fa75@the-village.bc.nu>
Date: Thu, 29 Nov 2007 23:58:44 +0100
In-Reply-To: <20071129172740.2515fa75@the-village.bc.nu> (Alan Cox's message of "Thu\, 29 Nov 2007 17\:27\:40 +0000")
Message-ID: <p73ir3ky7yz.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
>
> The simple case is
> 	open
> 	write cathedral and bazaar in some order
> 	close
> 	<trap close -> process -> label eric_t>
>
> 	open (eric_t) - SELinux "no"
>
>
> Anyone smart will then write it out of order and keep the file open, or

That would assume Eric already has a program running on your system
optimized to inject his works in a obfuscated way. And if he has a
program running he can do nearly everything already.  You already
lost the game.

The normal case Tvrtko et.al. are trying to handle would be more the
work getting downloaded from somewhere or read from a usb stick using
normal programs like web browsers or file managers who don't do any
out of order writing tricks and other obfuscation.

Important exception might be things like BitTorrent who write 
out of order or parallel downloaders to cheat TCP congestion control.
Or simply tar+gzip with automatic depacking in desktops.
There are probably more and it's probably tricky but it is not a 
"need to handle arbitary nastiness by a determined attacker" situation.

Anyways I'm not saying that pattern matching is a useful security
measure (just the interaction with compression and encryption makes it
very dubious), but if you're talking hypothetically you should at
least look closely at the hypothetical use cases @)

-Andi
