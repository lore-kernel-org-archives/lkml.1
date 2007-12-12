Return-Path: <linux-kernel-owner+w=401wt.eu-S1756707AbXLLRqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707AbXLLRqh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 12:46:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751682AbXLLRq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 12:46:27 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:50625 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551AbXLLRqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 12:46:25 -0500
Date: Wed, 12 Dec 2007 09:45:07 -0800
From: Greg KH <greg@kroah.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Dave Young <hidave.darkstar@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] x86 boot : export boot_params via sysfs (forward
	to Greg)
Message-ID: <20071212174507.GB16049@kroah.com>
References: <1197443265.14443.59.camel@caritas-dev.intel.com> <20071212073502.GA31348@kroah.com> <1197447079.14443.82.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1197447079.14443.82.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2007 at 04:11:19PM +0800, Huang, Ying wrote:
> On Tue, 2007-12-11 at 23:35 -0800, Greg KH wrote:
> > > +static struct attribute *boot_params_attrs[] = {
> > > +	&boot_params_version_attr.attr,
> > > +	NULL
> > > +};
> > > +
> > > +static struct attribute_group boot_params_attr_group = {
> > > +	.attrs = boot_params_attrs,
> > > +};
> > > +
> > > +static ssize_t boot_params_data_read(struct kobject *kobj,
> > > +				     struct bin_attribute *bin_attr,
> > > +				     char *buf, loff_t off, size_t count)
> > > +{
> > > +	memcpy(buf, (void *)&boot_params + off, count);
> > > +	return count;
> > > +}
> > 
> > Why is the whole structure being exported to userspace directly?
> > Traditionally we only use the binary files for blobs that are not
> > interpreted by the kernel in any way.  Is that what this structure
> > really is?
> 
> The struct boot_params is not the case. But it is too complex (such as
> the struct edd_info in it). It is very complex to output every fields
> include the first level fields until the primary data type. And Peter
> Anvin think it is OK to output it as a big binary file.

Well, I respectively disagree.  sysfs is NOT for exporting various
binary kernel structures to userspace directly.  Again, the binary files
in sysfs are for chunks of memory that are PASS-THROUGH from hardware to
userspace, with no kernel intervention at all.

If you really need such a thing, use debugfs, as the only rule for
debugfs is that there is no rules :)

So I do not agree with this change at this time, and do not want to see
it applied to the tree.

If you really need this kind of information exported to userspace
through sysfs, then expand it all, in a one-text-value-per-file
format.  I would have no objection to that.

thanks,

greg k-h
