Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919Ab0BLOBv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 09:01:51 -0500
Received: from poutre.nerim.net ([62.4.16.124]:61787 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756869Ab0BLOBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 09:01:44 -0500
Date: Fri, 12 Feb 2010 15:01:37 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "J.H." <warthog9@kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, mirrors@kernel.org,
       users@kernel.org, "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       lasse.collin@tukaani.org
Subject: Re: [kernel.org users] XZ Migration discussion
Message-ID: <20100212150137.648dca7c@hyperion.delvare>
In-Reply-To: <4B744E13.8040004@kernel.org>
References: <4B744E13.8040004@kernel.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Feb 2010 10:36:03 -0800, J.H. wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Hey Everyone,
> 
> So as the subject states this is more a centralized discussion on
> migration plans to using and providing xz for content on kernel.org.
> Currently we provide gz and bz2, with gz acting as the original content
> and kernel.org itself generating the resulting bz2 files.  There are a
> couple of possible proposals and wanted to toss them out there, and get
> feedback from everyone: the kernel community, the mirrors of kernel.org
> and the direct users of kernel.org.

Don't you have download statistics available? If we knew which
compression format is preferred, an by which margin, it would help make
an educated decision.

> ========================================================================
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
> 
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

Maybe that's just me, but my main concern is neither download times nor
decompression times. My main concern is the access time to directory
indexes when browsing the kernel archive, because there are 5 entries
for every patch or tarball: .bz2, .bz2.sign, .gz, .gz.sign and .sign.
This is horribly slow. The main directory for 2.6 kernels has an index
weighting over 300 kB raw, turning into a ~600 kB document when
HTML-ized. Just fetching it takes 3 seconds and then my browser takes a
long time to format it. There are 3881 entries in that directory today,
and it keeps growing!

So, once we have settled for a compression strategy, I think it would
be the right time to discuss the directory structure. With the advent
of the stable branches and the new development model - which pretty
much implies that we'll live with main version 2.6 forever - the file
count is much higher than it used to me.

I can think of several ways to improve the situation here, some of
which could be combined.

1* Keep a single compression format. This saves almost 40% of the
files.

2* Move one of the compression formats somewhere else, so that it
doesn't get in the way but is still available if needed.

3* Create a new subdirectory for every 2.6.x kernel, and move all the
related files there. This would shrink the main index drastically, and
each subdirectory would have a reasonable size (except maybe 2.6.16 and
2.6.27.) Oddly enough this has been done for the files under testing/
already, so I am curious why we don't do it for the release files (and
the testing/incr/ files, while we're at it.)

4* Get rid of the LATEST-IS-* files. This is a small count, won't save
much, but these files seem totally useless to me these days. Depending
on what you want exactly, there are many versions which can be
considered the latest, and there are better ways to know which they are
(for example http://www.eu.kernel.org/kdist/finger_banner ). And these
files tend to get stuck so you can't rely on them anyway.

I wouldn't worry too much about breaking the current locations. Just
give some time for software authors (ketchup comes to mind) to update
their code and it shouldn't be a big problem.

Thanks,
-- 
Jean Delvare
