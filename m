Return-Path: <linux-kernel-owner+w=401wt.eu-S1757572AbZCSRLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572AbZCSRLW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 13:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152AbZCSRLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 13:11:10 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:10493 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbZCSRLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 13:11:09 -0400
Date: Thu, 19 Mar 2009 11:11:07 -0600
From: Alex Chiang <achiang@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: [PATCH v4 07/12] PCI: Introduce /sys/bus/pci/rescan
Message-ID: <20090319171107.GG8074@ldl.fc.hp.com>
References: <20090318222426.887.1008.stgit@bob.kio> <20090318224001.887.63554.stgit@bob.kio> <20090319023453.7467644a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090319023453.7467644a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton <akpm@linux-foundation.org>:
> On Wed, 18 Mar 2009 16:40:01 -0600 Alex Chiang <achiang@hp.com> wrote:
> 
> > +#ifdef CONFIG_HOTPLUG
> > +static DEFINE_MUTEX(pci_remove_rescan_mutex);
> > +static ssize_t bus_rescan_store(struct bus_type *bus, const char *buf,
> > +				size_t count)
> > +{
> > +	unsigned long val;
> > +	struct pci_bus *b = NULL;
> > +
> > +	if (strict_strtoul(buf, 0, &val) < 0)
> > +		return -EINVAL;
> > +
> > +	if (!capable(CAP_SYS_ADMIN))
> > +		return -EPERM;
> > +
> > +	if (val) {
> > +		mutex_lock(&pci_remove_rescan_mutex);
> > +		while ((b = pci_find_next_bus(b)) != NULL)
> > +			pci_rescan_bus(b);
> > +		mutex_unlock(&pci_remove_rescan_mutex);
> > +	}
> > +	return count;
> > +}
> > +
> > +struct bus_attribute pci_bus_attrs[] = {
> > +	__ATTR(rescan, S_IWUSR, NULL, bus_rescan_store),
> > +	__ATTR_NULL
> > +};
> > +#endif
> 
> Why CONFIG_HOTPLUG rather than CONFIG_HOTPLUG_PCI (or similar)?

I first started out with CONFIG_HOTPLUG_PCI but then all that
stuff got compiled out, and I couldn't figure out why at the
time.

I'll go back and try and figure out what's really going on. :-/

Thanks.

/ac

