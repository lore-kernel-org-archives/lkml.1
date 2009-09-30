Return-Path: <linux-kernel-owner+w=401wt.eu-S1753963AbZI3Wes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbZI3Wes (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 18:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752754AbZI3Wes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 18:34:48 -0400
Received: from thunk.org ([69.25.196.29]:46277 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbZI3Wer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 18:34:47 -0400
Date: Wed, 30 Sep 2009 18:34:47 -0400
From: Theodore Tso <tytso@mit.edu>
To: wbrana@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: ext4/reiser3/btr directory create/read perf
Message-ID: <20090930223447.GO24383@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, wbrana@gmail.com,
	linux-kernel@vger.kernel.org
References: <a769871e0909270527j5d4a6a51ycb5627ebe94704be@mail.gmail.com> <20090928142903.GD17514@mit.edu> <a769871e0909301205x771e1fc3y62a25790e1728754@mail.gmail.com> <a769871e0909301244nec4764albeb7bf042495cc1e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a769871e0909301244nec4764albeb7bf042495cc1e@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30, 2009 at 09:44:04PM +0200, wbrana@gmail.com wrote:
> 
> Times with 1000 directories and dir_index enabled
> /mnt/md8: 64 kB chunks
> reiser3
> void cfs::vdirs_create(): 973 msec
> void cfs::vdirs_read(): 60 msec
> ext4
> void cfs::vdirs_create(): 2435 msec
> void cfs::vdirs_read(): 3326 msec
> btrfs
> void cfs::vdirs_create(): 1036 msec
> void cfs::vdirs_read(): 155 msec
> 
> ext4 was 55 times slower than reiser3 in vdirs_read()

On a micro brenchmark, simply creating an empty directory will much
faster in pure b-tree oriented filesystems, since it's just a node
insert.  So yes, reiser3 will always be faster for mkdir(), and
there's not much that can be done about it.  

I suppose we could implement XFS-style short-form directories (where
the directory is stored in i_blocks, which would work for directories
with 4 or fewer directory entries with short names), but it's not
clear it's really worth it, since in practice, there are very few
directories that have really small number of entries, and there's a
lot more regarding real-world performance than just creating empty
directories.

						- Ted
