Return-Path: <linux-kernel-owner+w=401wt.eu-S1757551AbZHHBDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551AbZHHBDk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 21:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754366AbZHHBDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 21:03:40 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:47048 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001AbZHHBDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 21:03:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jpBnL2z4PRYaGq0LUUSB5Kn+4fTziqKPoph58ILIRuDR3F9QGRK449KC9+7Tbh/N+5
         fzB6MQAl8Q7BUViQcMRVMQeYHEnBc8TDWJI5fMNq8tZtCEDUZMJorJhwai4oSWWnjL9W
         xSRC/+cjyC8XxmSs5sig0CIm0ydwQYlJYe22M=
Date: Sat, 8 Aug 2009 03:03:36 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Andi Kleen <andi@firstfloor.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 3/5] tty: handle VT specific compat ioctls in vt driver
Message-ID: <20090808010336.GN4999@nowhere>
References: <1249564170-18627-1-git-send-email-arnd@arndb.de> <200908070904.11260.arnd@arndb.de> <20090807080428.GB4955@nowhere> <200908071402.11217.arnd@arndb.de> <20090808003451.GK4999@nowhere> <20090808004156.GA23747@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090808004156.GA23747@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 05:41:56PM -0700, Greg KH wrote:
> On Sat, Aug 08, 2009 at 02:34:53AM +0200, Frederic Weisbecker wrote:
> > On Fri, Aug 07, 2009 at 02:02:11PM +0200, Arnd Bergmann wrote:
> > > On Friday 07 August 2009, Frederic Weisbecker wrote:
> > > > Ok. This looks like a nice series. A bkl pushdown that only goes down
> > > > in one site among several others enlightens the understanding of what it
> > > > is protecting (beside the nice fact it also burned three bkl callsites :-)
> > > 
> > > Thanks!
> > > 
> > > Well, most importantly patch 5/5 fixes a long-standing bug where we held
> > > the BKL in lots of places that were already proven not to need it, or
> > > alternatively held it twice (nested) in the ioctls that may still need it.
> > > 
> > > I did patch 3/5 this way because I read that you were working on BKL
> > > removal for TTY and wanted to do my share by removing the dependency
> > > on the code that I care about (fs/compat_ioctl.h).
> > > 
> > > 	Arnd <><
> > 
> > Thanks!
> > 
> > I guess these patches could fit in the tty tree, unless someone has
> > objections?
> 
> I've taken this patch, I didn't see any others sent to me :(
> 
> thanks,
> 
> greg k-h


Hmm, several subsystems are involved in this patchset.
But another one is concerned by the tty tree:

[PATCH 2/5] s390: move keyboard compat ioctls into tty3270 driver

But this whole patchset seems broken if it gets disseminated in several
trees.
May be the whole patchset can go in yours?

