Return-Path: <linux-kernel-owner+w=401wt.eu-S1754349AbYAIQ7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349AbYAIQ7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 11:59:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750859AbYAIQ7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 11:59:03 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44165 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750836AbYAIQ7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 11:59:00 -0500
Date: Wed, 9 Jan 2008 16:56:41 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Kosina <jikos@jikos.cz>
Cc: Matthew Wilcox <matthew@wil.cx>, Nikanth Karthikesan <knikanth@suse.de>,
       grant@torque.net, tim@cyberelk.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Change paride driver to use unlocked_ioctl instead of
 ioctl
Message-ID: <20080109165641.668838af@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.64.0801091425100.25041@twin.jikos.cz>
References: <4785B7BC.5040106@suse.de>
	<4785C7D8.2020808@suse.de>
	<20080109123311.GP16309@parisc-linux.org>
	<Pine.LNX.4.64.0801091425100.25041@twin.jikos.cz>
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

On Wed, 9 Jan 2008 14:26:26 +0100 (CET)
Jiri Kosina <jikos@jikos.cz> wrote:

> On Wed, 9 Jan 2008, Matthew Wilcox wrote:
> 
> > >  	default:
> > >  		printk("%s: Unimplemented ioctl 0x%x\n", tape->name, cmd);
> > > +		unlock_kernel();
> > >  		return -EINVAL;
> > Surely a bug ... shouldn't this return -ENOTTY?

Agreed - ENOTTY. The printk is wrong as well, but this is just getting
shown up by the other changes.

Does anyone even use parallel IDE devices any more ?
