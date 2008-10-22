Return-Path: <linux-kernel-owner+w=401wt.eu-S1756252AbYJVJmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252AbYJVJmB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 05:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755575AbYJVJj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 05:39:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50104 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755909AbYJVJjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 05:39:55 -0400
Date: Wed, 22 Oct 2008 04:48:13 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
Cc: J?rn Engel <joern@logfs.org>,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       tim.bird@am.sony.com
Subject: Re: Subject: [PATCH 01/16] Squashfs: inode operations
Message-ID: <20081022084813.GA1740@infradead.org>
References: <E1KqrTW-0001xC-9M@dylan> <20081017165300.GA8076@logfs.org> <1224605666.31157.71.camel@moss-terrapins.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224605666.31157.71.camel@moss-terrapins.epoch.ncsc.mil>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2008 at 12:14:26PM -0400, David P. Quigley wrote:
> I looked at where filesystems such as ext3 store these and it seems to
> be in include/linux. I'm assuming this is because usespace utilities
> like fsck need them. It seems wrong for userspace tools to have their
> own private copy since you can potentially have them out of sync with
> the kernel you are running and it provides more chance for you
> forgetting to update a structure somewhere. 

All modern filesystems have it in their directories, and ext3 will have
that soon too.  The only thing that should go into include/linux are
defintions for ioctls if you have them.  It is absolutely intention that
the tools can get out of sync with the kernel, because that actually
keeps them compiling when you update things in the kernel - note that
a single on disk format can be represented by lots of different things
in C, and for various reaosons those can change once in a while in the
kernel.  It also allows you to actually compile the tools on a system
that doesn't have new enough kernel headers yet (e.g. debian
autobuilders) or even run the tools on various platforms that have no
or different kernel implementations.

