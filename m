Return-Path: <linux-kernel-owner+w=401wt.eu-S1758406AbZKKSbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758406AbZKKSbM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 13:31:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758352AbZKKSbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 13:31:11 -0500
Received: from THUNK.ORG ([69.25.196.29]:48600 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758238AbZKKSbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 13:31:10 -0500
Date: Wed, 11 Nov 2009 13:29:25 -0500
From: Theodore Tso <tytso@mit.edu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeff Garzik <jeff@garzik.org>, Arjan van de Ven <arjan@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>, auke-jan.h.kok@intel.com
Subject: Re: [PATCH] vfs: Add a trace point in the mark_inode_dirty function
Message-ID: <20091111182925.GH13262@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
	Jeff Garzik <jeff@garzik.org>,
	Arjan van de Ven <arjan@infradead.org>,
	Wu Fengguang <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Frederic Weisbecker <fweisbec@gmail.com>, auke-jan.h.kok@intel.com
References: <20091025225342.007138f5@infradead.org> <20091111020108.GA11423@localhost> <20091110223456.01ef355f@infradead.org> <4AFA6AEF.5060306@garzik.org> <20091111074542.GB25132@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091111074542.GB25132@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 11, 2009 at 08:45:42AM +0100, Ingo Molnar wrote:
> Without an inode->vfs-name lookup/matching service it's of limited 
> utility though to developers and users. So inode numbers are fine (as 
> nicely unique physical identifiers)- as long as corresponding vfs name 
> string is available too.

Inode numbers are quite usable for me; but I'm not afraid to do

      debugfs /dev/sdb -R "ncheck 12345"

:-)

If you really want to avoid that, one relatively lightweight thing we
could do, which would avoid needing to dump the entire pathname out,
would be to print out the triple (devno, dir_ino, file_ino), and then
provide a privileged syscall which translates this to a user-visible
pathname.  It won't be necessarily the pathname which the user used to
open the file (since there might be links, and bind mounts, et. al),
but if the goal is to give one of the user-friendly names of the inode
(as opposed to _the_ pathname used to open the file), it's quite sufficient.

    	       	     	      	      - Ted
