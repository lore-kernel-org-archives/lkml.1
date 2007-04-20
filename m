Return-Path: <linux-kernel-owner+w=401wt.eu-S1767253AbXDTUwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767253AbXDTUwo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 16:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767259AbXDTUwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 16:52:44 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:51066 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767253AbXDTUwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 16:52:43 -0400
Date: Fri, 20 Apr 2007 22:52:36 +0200
From: Jan Kara <jack@suse.cz>
To: Marat Buharov <marat.buharov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: why UDF have so ugly filesize limit?
Message-ID: <20070420205235.GN14172@atrey.karlin.mff.cuni.cz>
References: <698310e10704190655j1263035bi77c5f551db510646@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <698310e10704190655j1263035bi77c5f551db510646@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> from fs/udf/super.c:
> in function udf_fill_super
> sb->s_maxbytes = 1<<30; (1 GB)
> 
> Why sb->s_maxbytes is not equal to MAX_LFS_FILESIZE?
  Because UDF had some flaws and user could crash a kernel with larger
filesize. In -mm kernel are patches fixing the flaw and also raising the
limit back to MAX_LFS_FILESIZE.

> So, in include/linux/fs.h written that the filesystems should put that
> (MAX_LFS_FILESIZE) into their s_maxbytes, otherwise bad things can
> happen in VM.
  Bad things can happen only if you set it to more than
MAX_LFS_FILESIZE. With smaller values only users are disappointed ;).

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
