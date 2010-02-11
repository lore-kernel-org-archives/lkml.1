Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930Ab0BKT5h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 14:57:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43367 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756119Ab0BKT5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 14:57:36 -0500
Message-ID: <4B745EFD.9030805@zytor.com>
Date: Thu, 11 Feb 2010 11:48:13 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: "J.H." <warthog9@kernel.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>, mirrors@kernel.org,
       users@kernel.org, lasse.collin@tukaani.org,
       "FTPAdmin Kernel.org" <ftpadmin@kernel.org>
Subject: Re: XZ Migration discussion
References: <4B744E13.8040004@kernel.org>
In-Reply-To: <4B744E13.8040004@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2010 10:36 AM, J.H. wrote:
> 
> Option 1)
> 
> Leave gz as the master, and migrate bz2 to xz.  This will happen in
> stages obviously. with bz2 ultimately being phased out.
> 
> 	Migration option 1)
> 
> 		All new content would be provided in .bz2 and .xz with
> 		an ultimate date set that the .bz2 files would stop
> 		being generated with new content.  This would leave all
> 		existing content alone and it would not be a migration
> 		of the current .bz2 files to xz
> 
> 	Migration option 2)
> 
> 		At some point there would be a mass conversion of all
> 		existing content to include .bz2 and .xz.  These would
> 		be run in parallel for a time period until it was
> 		determined that .bz2 was no longer needed and it would
> 		be removed from the servers leaving .gz and .xz
> Option 2)
> 
> Convert the master data from gz to bz2 and use xz as the new file
> format.  This has the downside of causing more tool churn as it means
> the kernel developers will have to eventually convert from gz to bz2,
> which means for a time there will be nag e-mails if you upload gz
> instead of bz2 and such.  It would also mean that we (kernel.org) would
> need to be able to support .gz and .bz2 as master data for a time.
> 
> Migration options are identical to Option 1 more or less, with either
> just new content getting converted, or all content getting converted.
> 
> ========================================================================
> 
> I'm personally leaning towards option 1, though personally don't really
> have a preference on the migration options, as both obviously offer
> different advantages, and again this e-mail is more to spur on the
> discussion and come to some general consensus across all of the groups
> concerned before moving forward with a more specific plan.
> 
> So I'm inviting discussion, questions and comments on this so we know
> which way to ultimately go.

My personal recommendation would be for Option 1, Migration option 2.

I think the idea of having two "best" file formats (Migration Option 1)
in use indefinitely is rather pointless.

As for the motivations for Option 1:

a) Currently, .gz contents is original, whereas .bz2 contents is
automatically generated.  Flushing the .gz files would mean flushing
original content.

b) .gz is one of the most widely supported compression formats ever
created, plus it is very fast, especially on the decompression side.
.xz is reasonably fast but very memory intensive; .bz2 is moderately
fast and still fairly memory intensive (but not as much as .xz).  In
other words, .gz provides an option for small, slow or old systems, or
systems running inferior operating systems.  .xz provides the best
compression.  .bz2 is in between, but it doesn't serve either purpose as
well as the other two.

Realistically speaking, kernel.org itself will carry all three formats
for an extended transition time (at least a year); we will probably
discontinue the victim format only when we start running shy on disk
space.  However, we obviously don't want to push this burden onto all
the mirrors.  Therefore, I would really appreciate feedback from mirror
admins as to how you would prefer to see the transition -- either
transition -- happen.

	-hpa
