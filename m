Return-Path: <linux-kernel-owner+w=401wt.eu-S1757915AbZANBox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915AbZANBox (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 20:44:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbZANBom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 20:44:42 -0500
Received: from THUNK.ORG ([69.25.196.29]:47071 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753254AbZANBol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 20:44:41 -0500
Date: Tue, 13 Jan 2009 20:44:34 -0500
From: Theodore Tso <tytso@mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: kernel BUG at fs/ext/super.c:428
Message-ID: <20090114014434.GE14730@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
	Arjan van de Ven <arjan@linux.intel.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
References: <20090110003645.GA16107@linux-os.sc.intel.com> <20090113164842.c6aa7095.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113164842.c6aa7095.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 04:48:42PM -0800, Andrew Morton wrote:
> Well that's not good.  I don't recall us making any changes which
> affect the orphan list handling.  Perhaps "filesystem freeze: add error
> handling of write_super_lockfs/unlockfs", but only indirectly.
> 
> Does Arjan's new async stuff play with filesystems at umount/shutdown
> time?  Don't think so.

Well, Arjan's commit, efaee192: "async: make the final inode deletion
an asynchronous event", does change how inodes get deleted, and this
looks like a race where an inode is getting deleted during the umount.

So I would try reverting commit efaee192 and see if it fixes things
before starting a full bisect...

							- Ted
