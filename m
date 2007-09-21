Return-Path: <linux-kernel-owner+w=401wt.eu-S932781AbXIUXDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932781AbXIUXDr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 19:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762202AbXIUXDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 19:03:38 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50174 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760805AbXIUXDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 19:03:37 -0400
Date: Fri, 21 Sep 2007 16:03:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 07/25] r/o bind mounts: elevate write count for some
 ioctls
Message-Id: <20070921160314.67b116ed.akpm@linux-foundation.org>
In-Reply-To: <20070920195257.0E38EED5@kernel>
References: <20070920195249.852667D5@kernel>
	<20070920195257.0E38EED5@kernel>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2007 12:52:57 -0700
Dave Hansen <haveblue@us.ibm.com> wrote:

> Some ioctl()s can cause writes to the filesystem.  Take
> these, and make them use mnt_want/drop_write() instead.
> 
> We need to pass the filp one layer deeper in XFS, but
> somebody _just_ pulled it out in February because nobody
> was using it, so I don't feel guilty for adding it back.

Note that -mm's ext2-reservations.patch adds EXT2_IOC_SETRSVSZ,
and it doesn't do mnt_want_write().
