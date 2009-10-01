Return-Path: <linux-kernel-owner+w=401wt.eu-S1753431AbZJAWEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbZJAWEX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 18:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753398AbZJAWEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 18:04:23 -0400
Received: from www.sr71.net ([198.145.64.142]:34798 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386AbZJAWEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 18:04:22 -0400
Subject: Re: [PATCH] LED driver for Intel NAS SS4200 series (v3)
From: Dave Hansen <dave@sr71.net>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, rpurdie@rpsys.net,
       linux-kernel@vger.kernel.org, rgirod@confocus.com,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <1254162493.28232.235.camel@Joe-Laptop.home>
References: <1253118732-11944-1-git-send-email-dave@sr71.net>
	 <20090924171929.8ce89786.akpm@linux-foundation.org>
	 <1254160310.17303.20180.camel@nimitz>
	 <1254162493.28232.235.camel@Joe-Laptop.home>
Content-Type: text/plain
Date: Thu, 01 Oct 2009 15:04:25 -0700
Message-Id: <1254434665.29932.14.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-28 at 11:28 -0700, Joe Perches wrote:
> On Mon, 2009-09-28 at 10:51 -0700, Dave Hansen wrote:
> > On Thu, 2009-09-24 at 17:19 -0700, Andrew Morton wrote:
> 
> Trivial logging comments:
> 
> One of the printks is not prefaced and the printks
> and dev_printks are not consistently using either
> periods or no periods.
> 
> Some possible substitutions:
> 
> s/dev_printk(KERN_INFO/dev_info(/
> s/dev_printk(KERN_DEBUG/dev_dbg(/
> s/printk(KERN_INFO/pr_info(/
> 
> I think it would be better to use:
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> and remove the "%s: " ... KBUILD_MODNAME

Those all sound like good suggestions and should clean things up.

> >+	printk(KERN_INFO KBUILD_MODNAME ": '%s' found\n", id->ident);
> 
> Perhaps
> 	pr_info("Found a '%s'\n", id->ident);
> 
> > +	printk(KERN_DEBUG "setting blue off and amber on\n");
> 
> pr_debug?
> 
> > +		printk(KERN_INFO "%s: skipping hardware autodetection\n",
> > +				KBUILD_MODNAME);
> > +		printk(KERN_INFO "\tif this works, please send the output ");
> > +		printk(KERN_INFO "of 'dmidecode' to dave@sr71.net\n");
> 
> I think this will look odd when printed.
> There's a tab on the second line, not on third.
> Perhaps:
> 		pr_info("Skipping hardware detection.\n");
> 		pr_info("Please send 'dmidecode' output to dave@sr71.net\n");
> 
> > +		printk(KERN_INFO "%s: no LED devices found\n",
> > +				KBUILD_MODNAME);
> > +	printk(KERN_INFO "registering %s PCI driver\n", KBUILD_MODNAME);
> > +	printk(KERN_INFO "Unregistering %s driver\n", KBUILD_MODNAME);
> 
> 	pr_info("No LED devices found\n");
> 	pr_info("Registering PCI driver\n");
> 	pr_info("Unregistering PCI driver\n");

Doing that really cleans things up nicely.  Thanks for the suggestions!

-- Dave

