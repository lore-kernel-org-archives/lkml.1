Return-Path: <linux-kernel-owner+w=401wt.eu-S1753076AbXBJKAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbXBJKAM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 05:00:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753081AbXBJKAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 05:00:12 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:27500 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbXBJKAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 05:00:10 -0500
Date: Sat, 10 Feb 2007 10:58:58 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com,
       Neil Brown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.21 -- md-dm-reduce-stack-usage-with-stacked-block-devices.patch
Message-ID: <20070210095858.GA8145@osiris.boeblingen.de.ibm.com>
References: <20070208150710.1324f6b4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070208150710.1324f6b4.akpm@linux-foundation.org>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 08, 2007 at 03:07:10PM -0800, Andrew Morton wrote:
> drivers-mdc-use-array_size-macro-when-appropriate.patch
> md-dm-reduce-stack-usage-with-stacked-block-devices.patch
>  
>  -> neilb
>  
>  (The second one is getting idiotic.  When are we going to fix this??)

Since it was me who asked to have the stack usage reduced and Neil was
kind enough to fix this, I'm wondering what the state of dm is.

I think more than a year ago we had this:

Alasdair G Kergon <agk@redhat.com> said:

 I can see nothing wrong with this in principle.

 For device-mapper at the moment though it's essential that, while the bio
 mappings may now get delayed, they still get processed in exactly
 the same order as they were passed to generic_make_request().

 My main concern is whether the timing changes implicit in this patch
 will make the rare data-corrupting races in the existing snapshot code
 more likely. (I'm working on a fix for these races, but the unfinished
 patch is already several hundred lines long.)

 It would be helpful if some people on this mailing list would test
 this patch in various scenarios and report back.

Alasdair, is dm already fixed or is there any chance that it will
ever get fixed?
