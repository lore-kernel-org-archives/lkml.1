Return-Path: <linux-kernel-owner+w=401wt.eu-S2993442AbXEBQQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993442AbXEBQQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 12:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993445AbXEBQQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 12:16:53 -0400
Received: from THUNK.ORG ([69.25.196.29]:56388 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993442AbXEBQQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 12:16:52 -0400
Date: Wed, 2 May 2007 12:16:38 -0400
From: Theodore Tso <tytso@mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Cabot, Mason B" <mason.b.cabot@intel.com>, linux-kernel@vger.kernel.org,
       tridge@samba.com, jra@samba.org
Subject: Re: Ext3 vs NTFS performance
Message-ID: <20070502161638.GB19442@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Cabot, Mason B" <mason.b.cabot@intel.com>,
	linux-kernel@vger.kernel.org, tridge@samba.com, jra@samba.org
References: <B326D0531AF1BA48B4C1E9EBA239A050033DB3C1@scsmsx412.amr.corp.intel.com> <20070501142325.09c294bd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070501142325.09c294bd.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 02:23:25PM -0700, Andrew Morton wrote:
> On Tue, 1 May 2007 13:43:18 -0700
> "Cabot, Mason B" <mason.b.cabot@intel.com> wrote:
> 
> > I've been testing the NAS performance of ext3/Openfiler 2.2 against
> > NTFS/WinXP and have found that NTFS significantly outperforms ext3 for
> > video workloads. The Windows CIFS client will attempt a poor-man's
> > pre-allocation of the file on the server by sending 1-byte writes at
> > 128K-byte strides, breaking block allocation on ext3 and leading to
> > fragmentation and poor performance. This will happen for many
> > applications (including iTunes) as the CIFS client issues these
> > pre-allocates under the application layer.
> 
> Oh my gawd, what a stupid hack.  Now we know what the MS interoperability
> lab has been working on.

I wonder if they patented this technique as well, as well as one of
their dozen or so patents they are filing every day?  "A Method of
Screwing Over Samba's Performance So that Windows Longhorn Can Compete
On Performance" coming soon, to a patent database near you!  :-)

> > I've posted a brief paper on Intel's OSS website
> > (http://softwarecommunity.intel.com/articles/eng/1259.htm). Please give
> > it a read and let me know what you think. In particular, I'd like to
> > arrive at the right place to fix this problem: is it in the filesystem,
> > VFS, or Samba?

The right place is clearly Samba.  I can't think of any other program
or filesystem protocol where writing a 1 byte write at 128k strides
would be used to signal a desire to do preallocation.  In fact, it's
hard to think of a worse way of doing things.

							- Ted
