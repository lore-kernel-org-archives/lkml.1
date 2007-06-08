Return-Path: <linux-kernel-owner+w=401wt.eu-S937647AbXFHEve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937647AbXFHEve (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 00:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756135AbXFHEvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 00:51:12 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40668 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755224AbXFHEvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 00:51:10 -0400
Date: Thu, 7 Jun 2007 21:48:09 -0700
From: Greg KH <greg@kroah.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-kernel@vger.kernel.org,
       "linux-acpi@vger" <linux-acpi@vger.kernel.org>, lenb@kernel.org
Subject: Re: [PATCH]: add parameter "struct bin_attribute *" in
	.read/.write methods for sysfs binary attributes
Message-ID: <20070608044809.GB28395@kroah.com>
References: <1181208695.5317.2.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181208695.5317.2.camel@localhost.localdomain>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 05:31:35PM +0800, Zhang Rui wrote:
> From: Zhang Rui <rui.zhang@intel.com>
> 
> Well, first of all, I don't want to change so many files either.
> 
> What I do:
> Adding a new parameter "struct bin_attribute *" in the
> .read/.write methods for the sysfs binary attributes.
> 
> In fact, only the four lines change in fs/sysfs/bin.c and
> include/linux/sysfs.h do the real work.
> But I have to update all the files that use binary attributes
> to make them compatible with the new .read and .write methods.
> I'm not sure if I missed any. :(
> 
> Why I do this:
> For a sysfs attribute, we can get a pointer pointing to the
> struct attribute in the .show/.store method,
> while we can't do this for the binary attributes.
> I don't know why this is different, but this does make it not
> so handy to use the binary attributes as the regular ones.
> So I think this patch is reasonable. :)
> 
> Who benefits from it:
> The patch that exposes ACPI tables in sysfs
> requires such an improvement.
> All the table binary attributes share the same .read method.
> Parameter "struct bin_attribute *" is used to get
> the table signature and instance number which are used to
> distinguish different ACPI table binary attributes.
> 
> Without this parameter, we need to offer different .read methods
> for different ACPI table binary attributes.
> This is impossible as there are various ACPI tables on different
> platforms, and we don't know what they are until they are loaded.

I have no objection to this patch but it failes the checkpatch.pl script
pretty badly with too long of lines.  Care to fix it up and resend it?

thanks,

greg k-h
