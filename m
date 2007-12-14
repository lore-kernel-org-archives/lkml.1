Return-Path: <linux-kernel-owner+w=401wt.eu-S935170AbXLNAQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935170AbXLNAQj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 19:16:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932240AbXLNAQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 19:16:29 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765792AbXLNAQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 19:16:28 -0500
Date: Thu, 13 Dec 2007 19:16:05 -0500
From: Dave Jones <davej@redhat.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Print taint info in more places.
Message-ID: <20071214001605.GC22304@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Adrian Bunk <bunk@kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20071213224927.GA18639@redhat.com> <20071214000350.GK21616@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071214000350.GK21616@stusta.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2007 at 01:03:50AM +0100, Adrian Bunk wrote:

 > >  #ifndef HAVE_ARCH_BUG
 > >  #define BUG() do { \
 > > -	printk("BUG: failure at %s:%d/%s()!\n", __FILE__, __LINE__, __FUNCTION__); \
 > > +	printk(KERN_ERR "BUG: failure at %s:%d/%s()! (%s)\n",
 > > +		__FILE__, __LINE__, __FUNCTION__, print_tainted()); \
 > >  	panic("BUG!"); \
 > >  } while (0)
 > >  #endif
 > >...
 > 
 > Note that this only changes a handful of architectures and most likely 
 > not the ones you are interested in.

Good catch.  I'm sure we had coverage on at least x86 before, so
it seems over the many rediffs this patch has had, some chunks got lost.
I'll resurrect that.

thanks,

	Dave

-- 
http://www.codemonkey.org.uk
