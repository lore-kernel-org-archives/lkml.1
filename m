Return-Path: <linux-kernel-owner+w=401wt.eu-S1753161AbYLZDiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161AbYLZDiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 22:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752682AbYLZDiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 22:38:09 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:51871 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752225AbYLZDiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 22:38:08 -0500
Date: Thu, 25 Dec 2008 22:37:36 -0500
From: Theodore Tso <tytso@MIT.EDU>
To: Alberto Bertogli <albertito@blitiri.com.ar>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com
Subject: Re: jbd2 inside a device mapper module
Message-ID: <20081226033736.GK9871@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Alberto Bertogli <albertito@blitiri.com.ar>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	dm-devel@redhat.com
References: <20081224211038.GT4127@blitiri.com.ar> <20081224234915.GA23723@mit.edu> <20081225143535.GA4127@blitiri.com.ar> <20081225155248.GJ9871@mit.edu> <20081226000005.GB4127@blitiri.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081226000005.GB4127@blitiri.com.ar>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 25, 2008 at 10:00:05PM -0200, Alberto Bertogli wrote:
> 
> I think I'm not explaining myself correctly. My code has _nothing_ to do
> with ext2/3/4 (or any other filesystem) whatsoever. I'm not using the
> journal as an external one for a filesystem. I want to use it to be able
> to do atomic writes in my own, filesystem independant, device-mapper
> code.

How many block writes are you batching into a single transaction?  If
you're not careful you may find that performance overhead will be
quite expensive.

> After what you told me (both this and the deprecation of
> jbd2_journal_create()), I took a look at e2fsprogs' source. From what I
> could see, "mke2fs -O journal_dev" creates the external journal inside
> some ext2/3/4 structures, which caused my journal-loading code to fail
> (because it doesn't know about ext stuff).

Yes, this is necessary because in a production system you need to be
able to identify the external journal by UUID, and the ext2/3/4
superblock makes it easy to add a label, UUID, et. al.  It also
significantly lowers the chance that an external journal will get
misidentified as some other filesystem based on the data stored in the
journal.

					- Ted

