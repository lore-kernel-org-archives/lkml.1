Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750876Ab0BCDQL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 22:16:11 -0500
Received: from kroah.org ([198.145.64.141]:55801 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840Ab0BCDQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 22:16:03 -0500
Date: Tue, 2 Feb 2010 18:22:47 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: linux-next: driver-core tree build warning
Message-ID: <20100203022247.GA11904@kroah.com>
References: <20100119172741.2dd81553.sfr@canb.auug.org.au> <20100119210417.GC10928@kroah.com> <20100120104525.752a790f.sfr@canb.auug.org.au> <20100120172543.e884a8af.sfr@canb.auug.org.au> <20100120174441.e1b12fd7.sfr@canb.auug.org.au> <20100121231010.GB29796@kroah.com> <20100129182115.99918a0e.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100129182115.99918a0e.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 29, 2010 at 06:21:15PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> On Thu, 21 Jan 2010 15:10:10 -0800 Greg KH <greg@kroah.com> wrote:
> >
> > Here's a patch that I just applied to my tree to hopefully resolve this
> > issue.
> 
> I still get the warnings.
> 
> > -static CLASS_ATTR(probe, S_IWUSR, NULL, cpu_probe_store);
> > -static CLASS_ATTR(release, S_IWUSR, NULL, cpu_release_store);
> > +static SYSDEV_ATTR(probe, S_IWUSR, NULL, cpu_probe_store);
> 
> This defines attr_probe as a "struct sysdev_attribute" whose attr element
> is a "struct attribute".
> 
> > +static SYSDEV_ATTR(release, S_IWUSR, NULL, cpu_release_store);
> >  #endif /* CONFIG_ARCH_CPU_PROBE_RELEASE */
> >  
> >  #else /* ... !CONFIG_HOTPLUG_CPU */
> > @@ -261,8 +261,8 @@ int __init cpu_dev_init(void)
> >  
> >  static struct sysdev_class_attribute *cpu_sysdev_class_attrs[] = {
> >  #ifdef CONFIG_ARCH_CPU_PROBE_RELEASE
> > -	&class_attr_probe.attr,
> > -	&class_attr_release.attr,
> > +	&attr_probe.attr,
> 
> so here we are initialising a "struct sysdev_class_attribute *" with a
> "struct attribute *".  Thus the warning.

Doh, sorry about that.  I've fixed it up now and pushed it out.

thanks,

greg k-h
