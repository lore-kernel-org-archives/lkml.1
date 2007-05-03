Return-Path: <linux-kernel-owner+w=401wt.eu-S1161878AbXECM7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161878AbXECM7Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 08:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161879AbXECM7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 08:59:24 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:34233 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161878AbXECM7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 08:59:23 -0400
Date: Thu, 3 May 2007 08:57:41 -0400
From: Chris Mason <chris.mason@oracle.com>
To: David Chinner <dgc@sgi.com>
Cc: "Cabot, Mason B" <mason.b.cabot@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: Ext3 vs NTFS performance
Message-ID: <20070503125741.GA1518@think.oraclecorp.com>
References: <B326D0531AF1BA48B4C1E9EBA239A050033DB3C1@scsmsx412.amr.corp.intel.com> <20070502154414.GB77450368@melbourne.sgi.com> <20070502194621.GY1518@think.oraclecorp.com> <20070503001511.GD77450368@melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070503001511.GD77450368@melbourne.sgi.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2007 at 10:15:11AM +1000, David Chinner wrote:
[ bad fragmentation from a funky write one byte every 128k system ]
> 
> This only becomes a problem if the system has enough pages dirty to
> be triggering throttling so that the 1byte writes are converted before
> the data actually hits the server.
> 
> Even then, if you are on an XFS filesystem with a sunit/swidth set,
> the alocation alignments and speculative allocations will go a long
> way to preventing fragmentations.
> 
> If that doesn't work, then set the extent allocation size hint on the
> XFS inode to 128k or 256k to set the minimum all ocation size for the
> file to span the distance between the 1 byte writes. This attribute
> can be inherited from the parent directory on create, so it's a
> set and forget type of thing...
> 
> i.e. XFS has lots of ways to prevent perfromance from degrading
> on these sorts of issues.

I'm not surprised that XFS would fair the best in this workload,
but this sounds like a lot of magic that shouldn't be required.  The
fact that it is good to have the allocation knobs and delalloc in
general doesn't mean that samba shouldn't do the right thing and
preallocate the space in a sensible fashion.

-chris

