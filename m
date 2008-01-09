Return-Path: <linux-kernel-owner+w=401wt.eu-S1755661AbYAIVP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661AbYAIVP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 16:15:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbYAIVPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 16:15:16 -0500
Received: from mx1.suse.de ([195.135.220.2]:54988 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752625AbYAIVPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 16:15:15 -0500
Date: Wed, 9 Jan 2008 11:39:06 -0800
From: Greg KH <gregkh@suse.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Sudhir Kumar <skumar@linux.vnet.ibm.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Build Fails on 2.6.24-rc6-mm1[drivers/net/iseries_veth.ko]
	linking error
Message-ID: <20080109193906.GA14416@suse.de>
References: <20080109101404.GC1321@in.ibm.com> <20080109191456.GB6880@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080109191456.GB6880@uranus.ravnborg.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 08:14:56PM +0100, Sam Ravnborg wrote:
> On Wed, Jan 09, 2008 at 03:44:04PM +0530, Sudhir Kumar wrote:
> > Hi Andrew,
> > Build fails on my Power Machine with following error message.
> > 
> > 
> >  HOSTLD  arch/powerpc/boot/dtc
> >  WRAP    arch/powerpc/boot/zImage.pseries
> >  WRAP    arch/powerpc/boot/zImage.pmac
> > strip -s -R .comment vmlinux -o arch/powerpc/boot/zImage.iseries
> >  Building modules, stage 2.
> >  MODPOST 264 modules
> > ERROR: ".driver_add_kobj" [drivers/net/iseries_veth.ko] undefined!
> > make[1]: *** [__modpost] Error 1
> > make: *** [modules] Error 2
> 
> driver_add_kobj has a single user - iseries_veth. It is even documented
> in the comment in the file.
> And you build iseries_veth as a module but driver_add_kobj is not exported
> which is why you get this modpost error.
> 
> Workaround: make the driver built-in
> Fix: export driver_add_kobj or replace usage in iseries_veth.

I'll properly export this symbol, that's the right fix.

Sorry about this,

greg k-h
