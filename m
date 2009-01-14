Return-Path: <linux-kernel-owner+w=401wt.eu-S1753635AbZANSUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635AbZANSUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 13:20:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbZANSUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 13:20:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:40247 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754790AbZANSUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 13:20:14 -0500
Date: Wed, 14 Jan 2009 10:17:05 -0800
From: Greg KH <gregkh@suse.de>
To: Jesper Nilsson <Jesper.Nilsson@axis.com>
Cc: David Miller <davem@davemloft.net>,
       "roucaries.bastien@gmail.com" <roucaries.bastien@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tj@kernel.org" <tj@kernel.org>,
       "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "hinko.kocevar@cetrtapot.si" <hinko.kocevar@cetrtapot.si>
Subject: Re: lib/klist.c: bit 0 in pointer can't be used as flag
Message-ID: <20090114181705.GC16505@suse.de>
References: <20090114101908.GF19262@axis.com> <20090114.022140.169499153.davem@davemloft.net> <20090114103624.GH19262@axis.com> <20090114.024528.80563421.davem@davemloft.net> <20090114151221.GK19262@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114151221.GK19262@axis.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 04:12:21PM +0100, Jesper Nilsson wrote:
> On Wed, Jan 14, 2009 at 11:45:28AM +0100, David Miller wrote:
> > From: Jesper Nilsson <Jesper.Nilsson@axis.com>
> > Date: Wed, 14 Jan 2009 11:36:24 +0100
> > 
> > > On Wed, Jan 14, 2009 at 11:21:40AM +0100, David Miller wrote:
> > > > From: Jesper Nilsson <Jesper.Nilsson@axis.com>
> > > > Date: Wed, 14 Jan 2009 11:19:08 +0100
> > > > > The following patch works for CRIS, and is less intrusive than
> > > > > my earlier patch. If this the way to go I can resubmit a proper patch.
> > > > 
> > > > Out of curiosity, is there a way to get gcc to output code such
> > > > that data objects are aligned more naturally?  Some option or
> > > > similar?
> > > 
> > > There's flags for alignment of objects, but no flags for changing
> > > structure layout or size, which is probably what we run into here.
> > 
> > Really?
> 
> Yes, after some more research, I found that the bug is indeed triggered by
> the struct klist being aligned to odd bytes inside other structs.
> 
> Since CRIS uses packed structs, having a char * inside the kobjects
> shifts the alignment for all data after any struct that contains
> a kobject (and indeed inside the kobject itself)
> 
> In this case it was the class pointer of the struct device
> that had a klist in the private pointer (struct class_private),
> after a struct kset (which contains a kobject).

So, in order to make things smaller, your "use an external flag" patch
would probably be better than forcing the alignment on a 4 byte boundry,
right?

thanks,

greg k-h
