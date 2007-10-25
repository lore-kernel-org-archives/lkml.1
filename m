Return-Path: <linux-kernel-owner+w=401wt.eu-S1756981AbXJYVgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981AbXJYVgl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 17:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753314AbXJYVgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 17:36:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:60640 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723AbXJYVgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 17:36:31 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: trenn@suse.de
Subject: Re: [PATCH 0/5] Detect hwmon and i2c bus drivers interfering with ACPI Operation Region resources
Date: Thu, 25 Oct 2007 17:36:07 -0400
User-Agent: KMail/1.9.5
Cc: linux-acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Jean Delvare <khali@linux-fr.org>
References: <1193236319.4590.225.camel@queen.suse.de>
In-Reply-To: <1193236319.4590.225.camel@queen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710251736.07868.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is one of the most imortant issues with ACPI in Linux,
and I too thank you, Thomas and Jean, for your hard work
seeking the right solution.

1, 2 and 3 of 5 applied to acpi-test.

thanks,
-Len

On Wednesday 24 October 2007 10:31, Thomas Renninger wrote:
> Hi,
> 
> it seems Len's test tree and Linus tree diverged a bit, at least with
> this patch set things do not apply cleanly.
> 
> Therefore I post these for discussion whether and in which kernel tree
> they should end up before doing work for nothing.
> If they are still a candidate for 2.6.24 (rather unintrusive), pls tell
> me whether and when I should base them against Len's test/release branch
> or whatever other tree.
> If not, it would be great if they can be included into the -mm tree and
> I can rebase them against this one.
> 
> Be aware that there is a small change in ACPICA (first patch, that's
> also the reason why this one would not compile on its own).
> 
> Many thanks for detailed review, testing and a lot implementation help
> go to Jean Delvare, without his help I would not be able to post
> anything right now.
> 
> Thanks for any help/advise,
> 
>   Thomas
> 
> --------------
> Short general description:
> 
> In ACPI, AML can define accesses to IO ports and System Memory by
> Operation Regions. Those are not registered as done by PNPACPI using
> resource templates (and _CRS/_SRS methods).
> The IO ports and System Memory regions may get accessed by arbitrary AML
> code. When native drivers are accessing the same resources bad things
> can happen (e.g. a critical shutdown temperature of 3000 C every 2
> months or so).
> It is not really possible to register the operation regions via
> request_resource, as they often overlap with pnp or other resources
> (e.g. statically setup IO resources below 0x100).
> This approach stores all Operation Region declarations (IO and System
> Memory only) at ACPI table parse time. It offers a similar functionality
> like request_region and let drivers which are known to possibly use the
> same IO ports and Memory which are also often used by ACPI (hwmon and
> i2c) check for ACPI interference.
> 
> A boot parameter acpi_enforce_resources=strict/lax/no is provided, which
> is default set to lax:
>   - strict: let conflicting drivers fail to load with an error message
>   - lax:    let conflicting driver work normal with a warning message
>   - no:     no functional change at all
> Depending on the feedback and the kind of interferences we see, this
> should be set to strict at later time.
> 
> Goal of this patch set is:
>   - Identify ACPI interferences in bug reports (very hard to reproduce
>     and to identify)
>   - Find BIOSes for that an ACPI driver should exist for specific HW
>     instead of a native one.
>   - stability in general
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
