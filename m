Return-Path: <linux-kernel-owner+w=401wt.eu-S1752444AbXLXFAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444AbXLXFAx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 00:00:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750809AbXLXFAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 00:00:43 -0500
Received: from ns2.suse.de ([195.135.220.15]:56849 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778AbXLXFAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 00:00:42 -0500
Date: Sun, 23 Dec 2007 20:49:12 -0800
From: Greg KH <gregkh@suse.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: balbir@linux.vnet.ibm.com, linuxppc-dev@ozlabs.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Build breakage on powerpc with 2.6.24-rc6-mm1
Message-ID: <20071224044912.GA10690@suse.de>
References: <20071223224158.GA7975@linux.vnet.ibm.com> <20071224134353.c00fc231.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071224134353.c00fc231.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 24, 2007 at 01:43:53PM +1100, Stephen Rothwell wrote:
> Hi Balbir,
> 
> Thanks for the report.
> 
> On Mon, 24 Dec 2007 04:11:58 +0530 Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> >
> > I see the following error with the iseries_veth driver in 2.6.24-rc6-mm1
> > 
> > drivers/net/iseries_veth.c: In function ‘veth_init_connection’:
> > drivers/net/iseries_veth.c:818: warning: unused variable ‘rc’
> > drivers/net/iseries_veth.c: In function ‘veth_probe_one’:
> > drivers/net/iseries_veth.c:1086: error: ‘veth_port_ktypeq’ undeclared
> > (first use in this function)
> > drivers/net/iseries_veth.c:1086: error: (Each undeclared identifier is
> > reported only once
> > drivers/net/iseries_veth.c:1086: error: for each function it appears
> > in.)
> > make[2]: *** [drivers/net/iseries_veth.o] Error 1
> > make[1]: *** [drivers/net] Error 2
> > make: *** [drivers] Error 2

Thanks for the report, sorry for the typos, I'll fix up my patch.

> Yeah, that would be
> gregkh-driver-kobject-convert-drivers-net-iseries_vethc-to-use-kobject_init-add_ng.
> 
> Hi Greg, do you even build with your patches applied?

For the power architecture, no, I do not.  I used to, but my cross-build
box died and I haven't taken the time to set it all up again.  For i386
and x86-64 I do build everything, and as that's 99% of the users, it's
usually fine :)

I did start to try to get a s390 cross-build working, but ran out of
time a week or so ago...

> > Here's a patch, compile tested to fix the compilation problem
> 
> Hopefully Greg will fix his original patch before it reaches Linus.

I will do that.

thanks,

greg k-h
