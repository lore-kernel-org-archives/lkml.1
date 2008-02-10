Return-Path: <linux-kernel-owner+w=401wt.eu-S1757343AbYBJMZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343AbYBJMZs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 07:25:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755322AbYBJMZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 07:25:41 -0500
Received: from smtp-100-sunday.noc.nerim.net ([62.4.17.100]:1565 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754875AbYBJMZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 07:25:40 -0500
Date: Sun, 10 Feb 2008 13:25:36 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: trenn@suse.de, linux-acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, "Mark M. Hoffman" <mhoffman@lightlink.com>
Subject: Re: [PATCH 2/5] Provide acpi_check_{mem_}region.
Message-ID: <20080210132536.7c4d1cb1@hyperion.delvare>
In-Reply-To: <20080207234002.e31563be.akpm@linux-foundation.org>
References: <1193236379.4590.229.camel@queen.suse.de>
	<20080207234002.e31563be.akpm@linux-foundation.org>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Thu, 7 Feb 2008 23:40:02 -0800, Andrew Morton wrote:
> On Wed, 24 Oct 2007 16:32:59 +0200 Thomas Renninger <trenn@suse.de> wrote:
> 
> > Provide acpi_check_{mem_}region.
> > 
> > Drivers can additionally check against possible ACPI interference by also
> > invoking this shortly before they call request_region.
> > If -EBUSY is returned, the driver must not load.
> > Use acpi_enforce_resources=strict/lax/no options to:
> >   - strict: let conflicting drivers fail to load with an error message
> >   - lax:    let conflicting driver work normal with a warning message
> >   - no:     no functional change at all
> > 
> > 
> 
> OK, so Len has merged these into the acpi test tree.  My understanding is
> that once this work hits mainline, we can then merge
> check-for-acpi-resource-conflicts-in-hwmon-drivers.patch.

Correct. Same applies to a second patch:
check-for-acpi-resource-conflicts-in-i2c-bus-drivers.patch
Both patches should be merged upstream at the same time.

> My normal approach would be to send
> check-for-acpi-resource-conflicts-in-hwmon-drivers.patch to Mark for
> inclusion in git-hwmon one Len has merged the prerequisites into mainline. 
> 
> Problem is, if Len merges late in the 2.6.26 merge window, Mark might not
> have time to gets these changes into mainline before 2.6.27.  Which is all
> getting a bit dumb considering I first merged everything in October. 
> Fortunately things aren't mormally _this_ inefficient when one follows the
> rules - this was an unusual patchset.
> 
> But still, I think we could afford to speed things up a bit more than that.
>  We could ask Len to consider merging this work into 2.6.25 and then if
> Mark can ack check-for-acpi-resource-conflicts-in-hwmon-drivers.patch
> (below) for an akpm-merge, we're good to go.  But I do recall that people
> were a bit uncertain about it all back in October.
> 
> Please share your thoughts with us.

Len already merged all the acpi bits for 2.6.25 as far as I can see, so
all that is missing now is these two patches:
check-for-acpi-resource-conflicts-in-hwmon-drivers.patch
check-for-acpi-resource-conflicts-in-i2c-bus-drivers.patch
Both have been in -mm for quite some time.

In the default mode (acpi_enforce_resources=lax) these patches simply
print warnings but still let the drivers load, so they are safe to
merge, and the sooner, the better. The idea is to get feedback on how
many systems out there have ACPI resource conflicts. Then we'll see how
we can address them (if at all.)

I don't remember anyone objecting to these patches, and anyway the
problem has been there for years and nobody took care, so if anyone
really isn't happy with the solution designed by Thomas, that person
will have to do the work and submit something better later. That
shouldn't delay the merge of what we have now.

Andrew, both patches are

Acked-by: Jean Delvare <khali@linux-fr.org>

and I am totally fine with you pushing them to Linus now. But of course
having Mark's ack would be good too.

Thanks,
-- 
Jean Delvare
