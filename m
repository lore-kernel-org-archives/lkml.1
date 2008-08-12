Return-Path: <linux-kernel-owner+w=401wt.eu-S1753329AbYHLW4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbYHLW4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 18:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbYHLW4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 18:56:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:47062 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbYHLW4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 18:56:01 -0400
Date: Tue, 12 Aug 2008 15:12:01 -0700
From: Greg KH <greg@kroah.com>
To: Pavel Machek <pavel@suse.cz>
Cc: Mark Langsdorf <mark.langsdorf@amd.com>, joachim.deguara@amd.com,
       gregkh@ucw.cz, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/01][retry 1] x86: L3 cache index disable for 2.6.26
Message-ID: <20080812221201.GA3550@kroah.com>
References: <200807181603.52332.mark.langsdorf@amd.com> <20080808220011.GA12156@ucw.cz> <200808121104.09288.mark.langsdorf@amd.com> <20080812215659.GA12911@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080812215659.GA12911@elf.ucw.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2008 at 11:56:59PM +0200, Pavel Machek wrote:
> Hi!
> 
> > > I think there's one-value-per-file rule in sysfs...
> > > 
> > > I guess it is better to return -EOPNOTSUP (or something) instead of
> > > english text explaining that...
> > > 
> > > No, really, what you created is impossible to parse -- /proc like
> > > nightmare.
> > 
> > Okay, this is a simpler version that includes most of Ingo's
> > clean-ups and style changes.  It only displays the two
> > cache index values.  Is this acceptable?
> 
> Not sure, lets ask greg. And it probably should have few lines
> in Documentation going with it, so we know new interface is added and
> how it looks.

ALL new sysfs files require an entry in Documentation/ABI/ showing what
the file is for and how to use it.  See the README file in that
directory for the format to use.

> > +static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf)
> > +{
> > +        int node = cpu_to_node(first_cpu(this_leaf->shared_cpu_map));
> > +        struct pci_dev *dev = get_k8_northbridge(node);
> > +        ssize_t ret = 0;
> > +        int i;
> > +
> > +        if (!this_leaf->can_disable) 
> > +                return sprintf(buf, "-1");
> 
> This should return -ERRNO, right?
> 
> > +        for (i = 0; i < 2; i++) {
> > +                unsigned int reg = 0;
> > +
> > +                pci_read_config_dword(dev, 0x1BC + i * 4, &reg);
> > +
> > +                ret += sprintf(buf, "%s %x\t", buf, reg);
> > +        }
> > +	ret += sprintf(buf,"%s\n", buf);
> 
> So you print "buf" few times? Why? And you use both \t and \n as deliminer...

Why are you printing more than one value per sysfs file?  That's almost
never allowed.

thanks,

greg k-h
