Return-Path: <linux-kernel-owner+w=401wt.eu-S1753163AbYJNSE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163AbYJNSE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 14:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751429AbYJNSEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 14:04:49 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:47625 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751422AbYJNSEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 14:04:49 -0400
Date: Tue, 14 Oct 2008 14:04:48 -0400
To: Pavel Machek <pavel@suse.cz>
Cc: Chris Snook <csnook@redhat.com>, Stefan Monnier <monnier@iro.umontreal.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: Filesystem for block devices using flash storage?
Message-ID: <20081014180448.GC22851@csclub.uwaterloo.ca>
References: <jwvvdw33v5p.fsf-monnier+gmane.linux.kernel@gnu.org> <48ED1D62.8080100@redhat.com> <20081011143552.GA1556@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081011143552.GA1556@ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 11, 2008 at 04:35:52PM +0200, Pavel Machek wrote:
> I don't think ext3 is safe w.r.t. whole eraseblocks disappearing. So
> if you write data 'nearby' root directory and power fails, bye bye
> filesystem, and journal will not help.
> 
> Actually ext2 will at least detect damage...

I have never seen a flash device that worked that way.  All the ones I
have seen have extra spare blocks and will copy an existing block to an
empty block changing the required bits while doing the copy to represent
the new data to be written.  When done, they update the block map of the
device to point to the new block, then the old block is erase and added
to the spare block list.

This is also used as part of wear leveling, where better devices will
occationally take a rarely written block, move it to a more used spare
block, and then add the previously rarely used block to the spare list
for more use.

In cases of decent devices like this, ext3 works great.  I have never
had a chunk of the filesystem disappear yet, although perhaps 2000
compact flash using units isn't a large enough data set to say much.

-- 
Len Sorensen
