Return-Path: <linux-kernel-owner+w=401wt.eu-S1031158AbXDJQ60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031158AbXDJQ60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 12:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031157AbXDJQ60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 12:58:26 -0400
Received: from waste.org ([66.93.16.53]:34883 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031149AbXDJQ6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 12:58:24 -0400
Date: Tue, 10 Apr 2007 11:44:51 -0500
From: Matt Mackall <mpm@selenic.com>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>
Cc: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
       Phillip Susi <psusi@cfl.rr.com>,
       Samuel Thibault <samuel.thibault@ens-lyon.org>,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Add a norecovery option to ext3/4?
Message-ID: <20070410164451.GC10459@waste.org>
References: <20070409000556.GA13980@implementation> <461A5F13.7040705@cfl.rr.com> <461A760B.1040103@redhat.com> <20070410072253.GA28665@lazybastard.org> <20070410112718.GF13650@thunk.org> <20070410120825.GA29487@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070410120825.GA29487@lazybastard.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2007 at 02:08:26PM +0200, Jörn Engel wrote:
> On Tue, 10 April 2007 07:27:18 -0400, Theodore Tso wrote:
> > 
> > I suppose what you could do is to read in the journal, and use it to
> > create an remapping table so that when you want to read block #5126,
> > and block number 5126 is in the journal, to read the journal version
> > of the block instead of the one on disk.  That would allow for safe
> > access to a filesystem being mounted read-only without the journal
> > being present.
> 
> Another option would be to access the medium through a mapping inode,
> replay the journal into the mapping inode and _not_ flush the dirty
> pages.  But as long as a remapping table is sufficient for ext3 journal
> format, such a table should be simpler and faster.

Or you could make a snapshot with device-mapper and then mount it.
Requires some free disk space somewhere (or a hack with loop on
tmpfs), but should be doable today.

-- 
Mathematics is the supreme nostalgia of our time.
