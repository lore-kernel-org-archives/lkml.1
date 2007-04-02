Return-Path: <linux-kernel-owner+w=401wt.eu-S934024AbXDBMoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934024AbXDBMoO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 08:44:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934023AbXDBMoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 08:44:14 -0400
Received: from styx.suse.cz ([82.119.242.94]:34450 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933979AbXDBMoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 08:44:13 -0400
Date: Mon, 2 Apr 2007 14:51:24 +0200
From: Jan Kara <jack@suse.cz>
To: Xin Zhao <uszhaoxin@gmail.com>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: Linux page cache issue?
Message-ID: <20070402125124.GI3728@duck.suse.cz>
References: <4ae3c140703272345y3b3cb3cexf4c4b63e0035d5b9@mail.gmail.com> <1175091028.12882.15.camel@kleikamp.austin.ibm.com> <4ae3c140703280839q72164accic94666d7801243c1@mail.gmail.com> <20070329092745.GA14616@atrey.karlin.mff.cuni.cz> <4ae3c140703290741p58199472u3bf9f3f58e4d1db1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ae3c140703290741p58199472u3bf9f3f58e4d1db1@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi Xin,

On Thu 29-03-07 10:41:01, Xin Zhao wrote:
> I know we can use device inode's radix tree to achieve the same goal.
> The only downside could be: First, by default, Linux will not add the
> data pages into that radix tree. Only when a file is opened in
  Right.

> O_DIRECT, the data pages will be put into dev's radix tree. Moreover,
  If you use O_DIRECT, I don't think the data will and in any radix tree -
ideally they go directly to disk in this case.

> if the partition is big, I am not sure whether the lookup overhead is
> an issue. So it might need some optimization.
  Maybe, but I'd not say so as my first guess.

> Can you elaborate more about the aliasing issues mentioned in your
> email? I do have some mechanisms to handle the following situation:
> suppose two files share same data blocks. Now two processes open the
> two files separately. If one process writes a file, the other file
> will be affected. Is this the aliasing issue you referred to?
  Yes, this is exactly what I meant. Note that these problems are not
only about writes but also about truncate and such...

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
