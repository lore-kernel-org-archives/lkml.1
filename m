Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425Ab0BNSDk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 13:03:40 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:54484 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab0BNSDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 13:03:39 -0500
To: "J.H." <warthog9@kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, mirrors@kernel.org,
       users@kernel.org, "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       lasse.collin@tukaani.org
Subject: Re: [kernel.org users] XZ Migration discussion
References: <4B744E13.8040004@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 14 Feb 2010 10:03:31 -0800
In-Reply-To: <4B744E13.8040004@kernel.org> (J. H.'s message of "Thu\, 11 Feb 2010 10\:36\:03 -0800")
Message-ID: <m1bpfritjg.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"J.H." <warthog9@kernel.org> writes:

> Hey Everyone,
>
> So as the subject states this is more a centralized discussion on
> migration plans to using and providing xz for content on kernel.org.
> Currently we provide gz and bz2, with gz acting as the original content
> and kernel.org itself generating the resulting bz2 files.  There are a
> couple of possible proposals and wanted to toss them out there, and get
> feedback from everyone: the kernel community, the mirrors of kernel.org
> and the direct users of kernel.org.
>
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
>
> - John 'Warthog9' Hawley
> Chief Kernel.org Administrator

My would go for Option 1.

With respect to migration Option 2.  The last time we had a
succsessful change of the default compression format from compress to
gzip, it required a change from a encumbered format to an unencombered
format, and gunzip was able to decompress files created with compress.

Neither xz nor bzip2 can decompress gzip'd files, and appear to be
heavy enough that for modest file sizes they give little gain.  bzip2
fills a niche but does not act as a generally available, general
purpose compressor today.  It appears that xz is coming up fast in
bzip2's niche, and provides better compression, so would appear to be
a good replacement for bzip2.

The role of gzip is to be compatible with the everything, and I would
be very sad to see it gzip disappear as that would make files on
kernel.org much less accessible.  


Migration option 2 sounds like I would could just replace bzip2 support
in scripts with xz support so it sounds handy, but I will leave the
details to those who have to run the servers.


Right now xz suffers from limited availability.  I just checked the
systems I have handy and of the 4 distro's I have installed on various
machines only 1 provides xz, so I expect it will be a while before
xz achieves ubiquity.  At the same time the fact that xz reduces
the linux-2.6.32 tarball by 10Megs is a welcome benefit, and seems
to make the replacement of bzip2 with xz worth doing.

Eric
