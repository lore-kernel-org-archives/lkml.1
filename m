Return-Path: <linux-kernel-owner+w=401wt.eu-S1759644AbXFMRuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759644AbXFMRuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 13:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758787AbXFMRuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 13:50:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52241 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758702AbXFMRuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 13:50:08 -0400
Date: Wed, 13 Jun 2007 10:51:47 -0700
From: Greg KH <gregkh@suse.de>
To: holzheu <holzheu@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, randy.dunlap@oracle.com, akpm@osdl.org,
       mtk-manpages@gmx.net, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Subject: Re: [RFC/PATCH] Documentation of kernel messages
Message-ID: <20070613175147.GB14355@suse.de>
References: <1181747217.29512.9.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181747217.29512.9.camel@localhost.localdomain>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2007 at 05:06:57PM +0200, holzheu wrote:
> Current prototype implementation:
> ================================= 
> 
> The structure of a kernel message is: <component>.<msg number>: <msg>
> 
> * component: Name of the kernel or driver component e.g. "pci", "ide", 
>   etc.
> * msg number: Within the component unique number of a kernel message.
> * msg: printk message
> 
> New macros KMSG_ERR(), KMSG_WARN(), etc. are defined, which have to be
> used in printk. These macros have as parameter the message number and
> are using a per c-file defined macro KMSG_COMPONENT.
> 
> Example: Define message 2 in component "kmsgtest":
> 
> #define KMSG_COMPONENT "kmsgtest"
> 
> void f(void)
> {
>         printk(KMSG_ERR(1) "device %x not online\n", devno);
> }

Ick, why are you ignoring what we have already with dev_printk() and
friends?  We are just finally getting developers to use that, I think it
will be almost impossible to get people to change to something else,
especially one that isn't even as "correct" as what dev_printk() offers
you today, will be quite hard.

So, why not use what we already have and work off of it?

thanks,

greg k-h
