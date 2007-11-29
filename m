Return-Path: <linux-kernel-owner+w=401wt.eu-S1762973AbXK2Rge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762973AbXK2Rge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 12:36:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762254AbXK2RgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 12:36:16 -0500
Received: from [81.2.110.250] ([81.2.110.250]:41189 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762100AbXK2RgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 12:36:15 -0500
Date: Thu, 29 Nov 2007 17:27:40 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, Greg KH <greg@kroah.com>,
       Jon Masters <jonathan@jonmasters.org>, Valdis.Kletnieks@vt.edu,
       Christoph Hellwig <hch@infradead.org>, Al Viro <viro@ftp.linux.org.uk>,
       Casey Schaufler <casey@schaufler-ca.com>,
       "Tvrtko A. Ursulin" <tvrtko.ursulin@sophos.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Out of tree module using LSM
Message-ID: <20071129172740.2515fa75@the-village.bc.nu>
In-Reply-To: <20071129165731.GA30719@infradead.org>
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
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Can we please stop this useless discussion?  Trying to check the content
> of files to see whether they might be malicious is inherently braindead,
> and no amounts of plugins in random places will fix this.

Actually it is quite effective especially for files whose content is
expected not to be executable material - there are some very distinct
mathematical signatures.

For the purposes of figuring out what is needed you can consider a random
simple user case such as a system which protects you against the works of
Eric S Raymond. Replace the mathematical analysis and heuristics with a
user space tool which spots the various ESR papers and design it for that
if it makes you happier.

SELinux seems to be able to do most of the lifting around the problem as
it can relabel a file into eric_t and constrain further access to it.

The big problem to me is that this essentially boils down to revoke() on
ordinary files, which as we know is _hard_.

The simple case is
	open
	write cathedral and bazaar in some order
	close
	<trap close -> process -> label eric_t>

	open (eric_t) - SELinux "no"


Anyone smart will then write it out of order and keep the file open, or
make sure someone else has it open. At that point close ceases to be a
point you can check the labelling. Open doesn't seem too helpful either
as the target may have the file open before it is modified into an ESR
work.

Even if you can spot the surrepticious assembly of an ESR work on your
computer you then have to implement revocation in order to take the file
away from those with it open.

Alan
