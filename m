Return-Path: <linux-kernel-owner+w=401wt.eu-S1754300AbYIQOy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300AbYIQOy7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 10:54:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbYIQOyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 10:54:49 -0400
Received: from lazybastard.de ([212.112.238.170]:51406 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbYIQOys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 10:54:48 -0400
Date: Wed, 17 Sep 2008 16:54:38 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/27] nilfs2: add document
Message-ID: <20080917145437.GE8750@logfs.org>
References: <1221419304-18572-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp> <1221419304-18572-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1221419304-18572-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 September 2008 04:07:58 +0900, Ryusuke Konishi wrote:
> +
> +The logs include regular files, directory files, symbolic link files
> +and several meta data files.  The mata data files are the files used
> +to maintain file system meta data.  The current version of NILFS2 uses
> +the following meta data files:
> +
> + 1) Inode file (ifile)             -- Stores on-disk inodes
> + 2) Checkpoint file (cpfile)       -- Stores checkpoints
> + 3) Segment usage file (sufile)    -- Stores allocation state of segments
> + 4) Data address translation file  -- Maps virtual block numbers to usual
> +    (DAT)                             block numbers.  This file serves to
> +                                      make on-disk blocks relocatable.
> + 5) Sketch file (sketch)           -- Keeps read-only data which can be
> +                                      associated with checkpoints (optional)

How are the sufile and the DAT written?  If you naively stick to the
log-structured approach, their contents will reflect a filesystem state
prior to writing them and be outdated by the time they hit the medium.
So either you bend the rules here and update those files in-place or you
do something tricky.  Can you explain your solution?

Jörn

-- 
Write programs that do one thing and do it well. Write programs to work
together. Write programs to handle text streams, because that is a
universal interface.
-- Doug MacIlroy
