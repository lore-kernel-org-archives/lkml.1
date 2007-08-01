Return-Path: <linux-kernel-owner+w=401wt.eu-S1755720AbXHAVPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720AbXHAVPs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 17:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755305AbXHAVP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 17:15:26 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55975 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755188AbXHAVPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 17:15:23 -0400
Date: Wed, 1 Aug 2007 14:14:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: kupdate weirdness
Message-Id: <20070801141439.ff1c29f9.akpm@linux-foundation.org>
In-Reply-To: <E1IGL4G-00088R-00@dorka.pomaz.szeredi.hu>
References: <E1IGL4G-00088R-00@dorka.pomaz.szeredi.hu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Aug 2007 22:45:16 +0200
Miklos Szeredi <miklos@szeredi.hu> wrote:

> The following strange behavior can be observed:
> 
> 1. large file is written
> 2. after 30 seconds, nr_dirty goes down by 1024
> 3. then for some time (< 30 sec) nothing happens (disk idle)
> 4. then nr_dirty again goes down by 1024
> 5. repeat from 3. until whole file is written
> 
> So basically a 4Mbyte chunk of the file is written every 30 seconds.
> I'm quite sure this is not the intended behavior.
> 
> The reason seems to be that __sync_single_inode() will move the
> partially written inode from s_io onto s_dirty, and sync_sb_inode()
> will not splice it back onto s_io until the rest of the inodes on s_io
> has been processed.

It does all sorts of weird crap.

> Since there will probably be a recently dirtied inode on s_io, this
> will take some of time, but always less than 30 sec.
> 
> I don't know what's the easiest solution.
> 
> Any ideas?

Try 2.6.23-rc1-mm2.
