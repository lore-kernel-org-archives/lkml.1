Return-Path: <linux-kernel-owner+w=401wt.eu-S1756797AbYAJVBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797AbYAJVBQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 16:01:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbYAJVBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 16:01:01 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44401 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751833AbYAJVBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 16:01:00 -0500
Date: Thu, 10 Jan 2008 20:58:26 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Kosina <jikos@jikos.cz>
Cc: Matthew Wilcox <matthew@wil.cx>, Nikanth Karthikesan <knikanth@suse.de>,
       grant@torque.net, tim@cyberelk.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Change paride driver to use unlocked_ioctl instead of
 ioctl
Message-ID: <20080110205826.7c41b247@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.64.0801101601000.25041@twin.jikos.cz>
References: <4785B7BC.5040106@suse.de>
	<4785C7D8.2020808@suse.de>
	<20080109123311.GP16309@parisc-linux.org>
	<Pine.LNX.4.64.0801091425100.25041@twin.jikos.cz>
	<20080109165641.668838af@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.64.0801101601000.25041@twin.jikos.cz>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jan 2008 16:01:44 +0100 (CET)
Jiri Kosina <jikos@jikos.cz> wrote:

> On Wed, 9 Jan 2008, Alan Cox wrote:
> 
> > > > >  	default:
> > > > >  		printk("%s: Unimplemented ioctl 0x%x\n", tape->name, cmd);
> > > > > +		unlock_kernel();
> > > > >  		return -EINVAL;
> > > > Surely a bug ... shouldn't this return -ENOTTY?
> > Agreed - ENOTTY. 
> 
> Just out of curiosity, where does POSIX happen to specify ENOTTY as the 
> correct one for unimplemented ioctl?

I don't know if POSIX does, but Unix has always used ENOTTY for "I don't
know what this ioctl is" and -EINVAL "for I know what this ioctl is but
the values passed are stupid"
