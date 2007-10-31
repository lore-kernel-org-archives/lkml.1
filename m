Return-Path: <linux-kernel-owner+w=401wt.eu-S1754473AbXJaGly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473AbXJaGly (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 02:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbXJaGlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 02:41:46 -0400
Received: from adsl-76-245-85-235.dsl.pltn13.sbcglobal.net ([76.245.85.235]:60524
	"EHLO cynthia.pants.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbXJaGlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 02:41:45 -0400
X-Greylist: delayed 2534 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Oct 2007 02:41:45 EDT
Date: Tue, 30 Oct 2007 20:43:05 -0700
From: Brad Boyer <flar@allandria.com>
To: Jan Kara <jack@suse.cz>
Cc: Jan Blunck <jblunck@suse.de>, Christoph Hellwig <hch@lst.de>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC 0/2] readdir() as an inode operation
Message-ID: <20071031034305.GD23984@cynthia.pants.nu>
References: <20071020100903.717837398@X40.localnet> <20071030152604.GC27039@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071030152604.GC27039@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2007 at 04:26:04PM +0100, Jan Kara wrote:
> > This is a first try to move readdir() to become an inode operation. This is
> > necessary for a VFS implementation of "something like union-mounts" where a
> > readdir() needs to read the directory contents of multiple directories.
> > Besides that the new interface is no longer giving the struct file to the
> > filesystem implementations anymore.
> > 
> > Comments, please?
>   Hmm, are you sure there are no users which keep some per-struct-file
> information for directories? File offset is one such obvious thing which
> you've handled but actually filesystem with more complicated structure
> of directory may remember some hints about where we really are, keep
> some readahead information or so...

The hfsplus code keeps some extra data in the ->private_data of directories,
although I've lost track of the exact benefit from not looking at the code
in some years. As I recall it was a performance enhancement due to the
fact that the data for all directories is effectively in a single file.
I believe it was easier to keep the current position as a structure
rather than just an offset and be careful about the tracking. The hfs
code is almost identical to the hfsplus code in this area.

	Brad Boyer
	flar@allandria.com

