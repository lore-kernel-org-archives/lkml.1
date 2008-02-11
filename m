Return-Path: <linux-kernel-owner+w=401wt.eu-S1754140AbYBKUkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbYBKUkU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 15:40:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbYBKUkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 15:40:08 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:54009 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbYBKUkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 15:40:06 -0500
Date: Mon, 11 Feb 2008 12:35:08 -0800
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Badari Pulavarty <pbadari@us.ibm.com>, linux-kernel@vger.kernel.org,
       haveblue@us.ibm.com, linux-mm@kvack.org
Subject: Re: [-mm PATCH] register_memory/unregister_memory clean ups
Message-ID: <20080211203508.GA6159@kroah.com>
References: <1202750598.25604.3.camel@dyn9047017100.beaverton.ibm.com> <20080211114818.74c9dcc7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080211114818.74c9dcc7.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 11:48:18AM -0800, Andrew Morton wrote:
> On Mon, 11 Feb 2008 09:23:18 -0800
> Badari Pulavarty <pbadari@us.ibm.com> wrote:
> 
> > Hi Andrew,
> > 
> > While testing hotplug memory remove against -mm, I noticed
> > that unregister_memory() is not cleaning up /sysfs entries
> > correctly. It also de-references structures after destroying
> > them (luckily in the code which never gets used). So, I cleaned
> > up the code and fixed the extra reference issue.
> > 
> > Could you please include it in -mm ?
> > 
> > Thanks,
> > Badari
> > 
> > register_memory()/unregister_memory() never gets called with
> > "root". unregister_memory() is accessing kobject_name of
> > the object just freed up. Since no one uses the code,
> > lets take the code out. And also, make register_memory() static.  
> > 
> > Another bug fix - before calling unregister_memory()
> > remove_memory_block() gets a ref on kobject. unregister_memory()
> > need to drop that ref before calling sysdev_unregister().
> > 
> 
> I'd say this:
> 
> > Subject: [-mm PATCH] register_memory/unregister_memory clean ups
> 
> is rather tame.  These are more than cleanups!  These sound like
> machine-crashing bugs.  Do they crash machines?  How come nobody noticed
> it?
> 
> All very strange...

No one has ever run the 'remove memory' codepath before, that's why they
were never seen before :)

thanks,

greg k-h
