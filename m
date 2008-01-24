Return-Path: <linux-kernel-owner+w=401wt.eu-S1755235AbYAXTF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235AbYAXTF0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 14:05:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbYAXTFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 14:05:11 -0500
Received: from phunq.net ([64.81.85.152]:60478 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751960AbYAXTFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 14:05:09 -0500
From: Daniel Phillips <phillips@phunq.net>
To: Theodore Tso <tytso@mit.edu>
Subject: Re: [CALL FOR TESTING] Make Ext3 fsck way faster [2.6.24-rc6 -mm patch]
Date: Thu, 24 Jan 2008 11:04:53 -0800
User-Agent: KMail/1.9.5
Cc: Abhishek Rai <abhishekrai@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       rohitseth@google.com, linux-ext4@vger.kernel.org
References: <200801140839.01986.abhishekrai@google.com> <200801192010.20699.phillips@phunq.net> <20080121025117.GB8105@mit.edu>
In-Reply-To: <20080121025117.GB8105@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801241104.53717.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 20 January 2008 18:51, Theodore Tso wrote:
> On Sat, Jan 19, 2008 at 08:10:20PM -0800, Daniel Phillips wrote:
> > I can see value in preemptively loading indirect blocks into the
> > buffer cache, but is building a second-order extent tree really
> > worth the effort?  Probing the buffer cache is very fast.
>
> It's not that much effort, and for a big database (say, like a 50GB
> database file), the indirect blocks would take up 50 megabytes of
> memory.  Collapsing it into an extent tree would save that memory
> into a few kilobytes.  I suppose a database server would probably
> have 5-10GB's of memory, so the grand scheme of things it's not a
> vast amount of memory, but the trick is keeping the indirect blocks
> pinned so they don't get pushed out by some vast, gigunndo Java
> application running in the same server as the database.  If you have
> the indirect blocks encoded into the extent tree, then you don't have
> to worry about that.

Hi Ted,

OK I think you are right, because this is a nice step towards developing 
an on-disk extent format for Ext4 that avoids committing design 
mistakes to permanent storage.  The benefit can be proven using a pure 
cache, in order to justify the considerable work necessary to make it 
persistent.

Chris and Jens have an effort going to implement a physical disk extent 
cache for loop.c.  It is actually the same problem, and I smell a 
library here.

Issue: how do you propose to make this cache evictable?

Regards,

Daniel
