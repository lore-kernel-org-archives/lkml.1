Return-Path: <linux-kernel-owner+w=401wt.eu-S1763430AbXGJXbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763430AbXGJXbe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 19:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761453AbXGJXae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 19:30:34 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42965 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760870AbXGJXab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 19:30:31 -0400
Date: Tue, 10 Jul 2007 16:30:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: cmm@us.ibm.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: [EXT4 set 2][PATCH 1/5] cleanups: Propagate some i_flags to
 disk
Message-Id: <20070710163017.7c8f1043.akpm@linux-foundation.org>
In-Reply-To: <1183275372.4010.120.camel@localhost.localdomain>
References: <1183275372.4010.120.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 01 Jul 2007 03:36:12 -0400
Mingming Cao <cmm@us.ibm.com> wrote:

> Propagate flags such as S_APPEND, S_IMMUTABLE, etc. from i_flags into
> ext4-specific i_flags. Hence, when someone sets these flags via a different
> interface than ioctl, they are stored correctly.
> 

This changelog is inadequate.  I had to hunt down the equivalent ext3
patch's changelog to understand the reasons for this change.  Please update
this patch's changelog using the below: 

    ext3: copy i_flags to inode flags on write
    
    A patch that stores inode flags such as S_IMMUTABLE, S_APPEND, etc.  from
    i_flags to EXT3_I(inode)->i_flags when inode is written to disk.  The same
    thing is done on GETFLAGS ioctl.
    
    Quota code changes these flags on quota files (to make it harder for
    sysadmin to screw himself) and these changes were not correctly propagated
    into the filesystem (especially, lsattr did not show them and users were
    wondering...).
    
    Propagate flags such as S_APPEND, S_IMMUTABLE, etc.  from i_flags into
    ext3-specific i_flags.  Hence, when someone sets these flags via a
    different interface than ioctl, they are stored correctly.

