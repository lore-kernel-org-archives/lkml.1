Return-Path: <linux-kernel-owner+w=401wt.eu-S1760329AbYAJPug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760329AbYAJPug (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 10:50:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758152AbYAJPuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 10:50:08 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:49123 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756740AbYAJPuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 10:50:05 -0500
Date: Thu, 10 Jan 2008 08:50:03 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Jiri Kosina <jikos@jikos.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       grant@torque.net, tim@cyberelk.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Change paride driver to use unlocked_ioctl instead of ioctl
Message-ID: <20080110155003.GD18741@parisc-linux.org>
References: <4785B7BC.5040106@suse.de> <4785C7D8.2020808@suse.de> <20080109123311.GP16309@parisc-linux.org> <Pine.LNX.4.64.0801091425100.25041@twin.jikos.cz> <20080109165641.668838af@lxorguk.ukuu.org.uk> <1199979101.4474.89.camel@nikanth-laptop.blr.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199979101.4474.89.camel@nikanth-laptop.blr.novell.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 09:01:41PM +0530, Nikanth Karthikesan wrote:
> On Thu, 2008-01-10 at 16:01 +0100, Jiri Kosina wrote:
> > On Wed, 9 Jan 2008, Alan Cox wrote:
> > 
> > > > > >  	default:
> > > > > >  		printk("%s: Unimplemented ioctl 0x%x\n", tape->name, cmd);
> > > > > > +		unlock_kernel();
> > > > > >  		return -EINVAL;
> > > > > Surely a bug ... shouldn't this return -ENOTTY?
> > > Agreed - ENOTTY. 
> > 
> > Just out of curiosity, where does POSIX happen to specify ENOTTY as the 
> > correct one for unimplemented ioctl?
> > 
> 
> The printk is also wrong, It should have been, Invalid ioctl for the
> device

It shouldn't print anything.  That printk lets unprivileged users DoS
the syslog.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
