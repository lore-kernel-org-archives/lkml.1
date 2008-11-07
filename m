Return-Path: <linux-kernel-owner+w=401wt.eu-S1752183AbYKGFla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbYKGFla (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 00:41:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750879AbYKGFlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 00:41:20 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:35234 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbYKGFlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 00:41:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=V21juzIBxhGDl5mU5vb409VwNGzDg+3CclkIB6Hth76HtpVgL3KGxhNabfTScAUpth
         2+q879Gw8lR6qqgupOYCZkd4RCWJmrOQgcVIESKqM0oc40dT8fwFt02OSxj3I2v7D5eO
         EOlWA9wyHBeRyFjNqKdZCFB/F4je9Jgrs3xP0=
Date: Fri, 7 Nov 2008 08:44:37 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: next-20081106: undefined reference to `__per_cpu_start'
Message-ID: <20081107054437.GA21421@x200.localdomain>
References: <20081106173645.e7e79071.sfr@canb.auug.org.au> <20081106183939.GA26925@x200.localdomain> <Pine.LNX.4.64.0811061310350.6009@quilx.com> <20081107162114.2a41c623.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081107162114.2a41c623.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2008 at 04:21:14PM +1100, Stephen Rothwell wrote:
> Hi Christoph,
> 
> On Thu, 6 Nov 2008 13:15:07 -0600 (CST) Christoph Lameter <cl@linux-foundation.org> wrote:
> >
> > On Thu, 6 Nov 2008, Alexey Dobriyan wrote:
> > 
> > > On blackfin-BF526-EZBRD and other blackfins:
> > >
> > >   LD      .tmp_vmlinux1
> > > mm/built-in.o: In function `cpu_alloc_init':
> > > (.init.text+0x1486): undefined reference to `__per_cpu_start'
> > > mm/built-in.o: In function `cpu_alloc_init':
> > > (.init.text+0x148c): undefined reference to `__per_cpu_start'
> > > mm/built-in.o: In function `cpu_alloc_init':
> > > (.init.text+0x1492): undefined reference to `__per_cpu_end'
> > > mm/built-in.o: In function `cpu_alloc_init':
> > > (.init.text+0x1496): undefined reference to `__per_cpu_end'
> > 
> > Any contigencies for __per_cpu_start/end in your blackfin vmlinux.lds.h?
> > That is where these symbols are defined
> > 
> > Or did you use generic percpu support and set
> > CONFIG_HAVE_ZERO_BASED_PER_CPU?
> 
> Also a avr32 allnoconfig
> (http://kisskb.ellerman.id.au/kisskb/buildresult/53233/) gets:
> 
> backing-dev.c:(.init.text+0xc4c): undefined reference to `__per_cpu_start'
> backing-dev.c:(.init.text+0xc50): undefined reference to `__per_cpu_end'
> 
> and avr32 defconfig
> (http://kisskb.ellerman.id.au/kisskb/buildresult/53225/) gets:
> 
> vmstat.c:(.init.text+0xff0): undefined reference to `__per_cpu_start'
> vmstat.c:(.init.text+0xff4): undefined reference to `__per_cpu_end'

BTW, on alpha I get

mm/cpu_alloc.c:146:1: error: pasting "per_cpu__" and "(" does not give a valid preprocessing token
