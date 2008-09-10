Return-Path: <linux-kernel-owner+w=401wt.eu-S1754529AbYIJSZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbYIJSZl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 14:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbYIJSZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 14:25:31 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:38155 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126AbYIJSZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 14:25:30 -0400
Subject: Re: [Open-FCoE] [PATCH 1/3] 24-bit types: typedef and macros for
	accessing 3-byte arrays as integers
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Chris Leech <christopher.leech@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       jfs-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
In-Reply-To: <48C807A9.60509@intel.com>
References: <20080905165732.16689.50256.stgit@localhost.localdomain>
	 <20080910140712.GA12280@infradead.org>
	 <1221061241.27385.14.camel@norville.austin.ibm.com>
	 <48C7F4EC.1080709@intel.com>  <48C807A9.60509@intel.com>
Content-Type: text/plain
Date: Wed, 10 Sep 2008 13:23:51 -0500
Message-Id: <1221071031.27385.21.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-10 at 10:45 -0700, Chris Leech wrote:
> Chris Leech wrote:
> > Dave Kleikamp wrote:
> >> @@ -62,7 +60,7 @@ struct timestruc_t {
> >>   */
> >>  typedef struct {
> >>  	unsigned len:24;
> >> -	unsigned off1:8;
> >> +	u8 off1;
> >>  	u32 off2;
> >>  } lxd_t;
> > 
> > Shouldn't len here be changed to a __le24?  I think this just changed
> > the size of lxd_t by a byte.
> 
> Never mind, I see that it's a host order field.  And presently surprised
> to see that gcc combines the 24-bit bitfield with the following u8.

Right.  I just made a note to throw away this ridiculous structure and
replace it with something sane.  It's only used in-memory and there's no
reason not to have an unsigned long long for offset, and an int for len.
This patch didn't seem to be the right place to fix that though.

-- 
David Kleikamp
IBM Linux Technology Center

