Return-Path: <linux-kernel-owner+w=401wt.eu-S1759485AbYAJPdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759485AbYAJPdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 10:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755764AbYAJPdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 10:33:06 -0500
Received: from ns2.suse.de ([195.135.220.15]:45479 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755592AbYAJPdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 10:33:04 -0500
Subject: Re: [PATCH] Change paride driver to use unlocked_ioctl instead of
	ioctl
From: Nikanth Karthikesan <knikanth@suse.de>
To: Jiri Kosina <jikos@jikos.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Matthew Wilcox <matthew@wil.cx>,
       grant@torque.net, tim@cyberelk.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
In-Reply-To: <478681FE.BANGALORE.BLR.100.174746A.1.ECB1.1@1:7.BANGALORE.BLR.100.0.1.0.1@16>
References: <4785B7BC.5040106@suse.de> <4785C7D8.2020808@suse.de>
	 <20080109123311.GP16309@parisc-linux.org>
	 <Pine.LNX.4.64.0801091425100.25041@twin.jikos.cz>
	 <20080109165641.668838af@lxorguk.ukuu.org.uk>
	 <478681FE.BANGALORE.BLR.100.174746A.1.ECB1.1@1:7.BANGALORE.BLR.100.0.1.0.1@16>
Content-Type: text/plain
Date: Thu, 10 Jan 2008 21:01:41 +0530
Message-Id: <1199979101.4474.89.camel@nikanth-laptop.blr.novell.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-01-10 at 16:01 +0100, Jiri Kosina wrote:
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
> 

The printk is also wrong, It should have been, Invalid ioctl for the
device

