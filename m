Return-Path: <linux-kernel-owner+w=401wt.eu-S1753024AbYLZSIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbYLZSIE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 13:08:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751098AbYLZSHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 13:07:53 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:64649 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750953AbYLZSHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 13:07:52 -0500
Date: Fri, 26 Dec 2008 13:06:42 -0500
From: Theodore Tso <tytso@MIT.EDU>
To: Alberto Bertogli <albertito@blitiri.com.ar>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com
Subject: Re: jbd2 inside a device mapper module
Message-ID: <20081226180642.GO9871@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Alberto Bertogli <albertito@blitiri.com.ar>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	dm-devel@redhat.com
References: <20081224211038.GT4127@blitiri.com.ar> <20081224234915.GA23723@mit.edu> <20081225143535.GA4127@blitiri.com.ar> <20081225155248.GJ9871@mit.edu> <20081226000005.GB4127@blitiri.com.ar> <20081226033736.GK9871@mit.edu> <20081226161708.GC4127@blitiri.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081226161708.GC4127@blitiri.com.ar>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 26, 2008 at 02:17:08PM -0200, Alberto Bertogli wrote:
> 
> At this moment I'm trying to keep it simple, so I plan to batch two for
> each sector written to the device: one for the metadata and one for the
> data.
> 

I think I can pretty much guarantee that your performance will be so
horrible that it won't be worth using.

> > Yes, this is necessary because in a production system you need to be
> > able to identify the external journal by UUID, and the ext2/3/4
> > superblock makes it easy to add a label, UUID, et. al.  It also
> > significantly lowers the chance that an external journal will get
> > misidentified as some other filesystem based on the data stored in the
> > journal.
> 
> Yes, it makes sense. I've reserved the first sector for that purpose.

Why not just use the ext3/4 external journal format?

						- Ted
