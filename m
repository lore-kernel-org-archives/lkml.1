Return-Path: <linux-kernel-owner+w=401wt.eu-S1761492AbZJIVgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761492AbZJIVgi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 17:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761478AbZJIVgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 17:36:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35098 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760971AbZJIVgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 17:36:37 -0400
Date: Fri, 9 Oct 2009 14:29:47 -0700
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Bruce Beare <bbeare1@gmail.com>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Cleanups for: line length, printk KERN_ argument,
 stack frame size > 2048 (added a kmalloc/kfree), style/formatting errors,
 incorrect include files
Message-ID: <20091009212947.GA10187@suse.de>
References: <1255122698-12390-1-git-send-email-bbeare1@gmail.com>
 <20091009211610.GA5005@suse.de>
 <20091009142742.b12b80b1.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091009142742.b12b80b1.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 09, 2009 at 02:27:42PM -0700, Randy Dunlap wrote:
> On Fri, 9 Oct 2009 14:16:10 -0700 Greg KH wrote:
> 
> > 
> > Try changing one thing at a time per patch please.
> > 
> > There's some bugs in here:
> > 
> > > -		struct config_t dig_in_config[32];
> > > -		struct config_t dig_out_config[32];
> > > -		struct config_t chan_in_config[32];
> > > -		struct config_t chan_out_config[32];
> > >  		int i;
> > > +		config_data = kmalloc(sizeof(struct config_data_t), GFP_KERNEL);
> > 
> > Shouldn't that be:
> > 		config_data = kmalloc(sizeof(struct config_data_t)*32, GFP_KERNEL);
> 
> The new struct already includes the [32]s.

Ah, missed that.

But your other comment about checking the kmalloc is valid.  We should
not add new calls to kmalloc that doesn't check, let's not _add_ new
errors to the code :)

Bruce, care to split this up into individual patches, each doing only
one thing, and check for the return value of this call?

thanks,

greg k-h
