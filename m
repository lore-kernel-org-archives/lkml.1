Return-Path: <linux-kernel-owner+w=401wt.eu-S932511AbYGQXkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932511AbYGQXkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 19:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757399AbYGQXki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 19:40:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:48035 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085AbYGQXkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 19:40:37 -0400
Date: Thu, 17 Jul 2008 16:35:24 -0700
From: Greg KH <greg@kroah.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>,
       Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, joe@perches.com, nick@nick-andrew.net,
       randy.dunlap@oracle.com
Subject: Re: [PATCH 1/7] dynamic debug v2 - infrastructure
Message-ID: <20080717233524.GA28711@kroah.com>
References: <20080715213108.GB23331@redhat.com> <20080717070103.GA21961@kroah.com> <20080717212040.GB13252@redhat.com> <20080717223222.GA28016@kroah.com> <20080717225611.GA27481@isilmar.linta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080717225611.GA27481@isilmar.linta.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 12:56:11AM +0200, Dominik Brodowski wrote:
> Hi,
> 
> On Thu, Jul 17, 2008 at 03:32:22PM -0700, Greg KH wrote:
> > > that is correct. any callers of dev_dbg() don't have to do anything. its really
> > > only the more complex debugging, where there are flags or levels that need to
> > > make adjustments to work with the new infrastructure.
> > 
> > For this reason alone, I see no reason why your patch should not be
> > merged today.  You don't need the other subsystems at this point in time
> > in my opinion, it's benifit is huge already.
> 
> not to object to this statement, but:
> 
> what about the user-visible interface? currently, it's based around one big
> debugfs file. What about doing
> 
> 	<debugfs>/dynamic_printk/<module_name>/{enabled[,level][,flag][,modules]}

By virtue of this being in debugfs, we can change the user interface
around as time goes on if we want to with no ill side affects. :)

> instead, or even
> 
> 	<sysfs>/module/<module_name>/debug/{enabled[,level][,flag]}

I like this as that is what a number of current modules do (usb-serial
drivers), but you have to be careful about the module parameter
namespace to not get collisions here with existing "debug" files.

So for now, I recommend staying in debugfs, it makes more sense.

thanks,

greg k-h
