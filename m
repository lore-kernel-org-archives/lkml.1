Return-Path: <linux-kernel-owner+w=401wt.eu-S1754595AbZAJSNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbZAJSNu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 13:13:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbZAJSNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 13:13:40 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42620 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752127AbZAJSNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 13:13:39 -0500
Date: Sat, 10 Jan 2009 10:12:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Ingo Molnar <mingo@elte.hu>, David Brown <lkml@davidb.org>,
       Phil Oester <kernel@linuxace.com>, Kay Sievers <kay.sievers@vrfy.org>,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       Christoph Hellwig <hch@infradead.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [GIT PULL] Squashfs pull request for 2.6.29
Message-Id: <20090110101235.7ca24c44.akpm@linux-foundation.org>
In-Reply-To: <20090110165033.GA23943@logfs.org>
References: <E1LKy3v-0003KO-Nx@dylan.lougher.demon.co.uk>
	<20090108165029.GA10951@infradead.org>
	<20090108175338.2abbee16.akpm@linux-foundation.org>
	<4966B24E.1050700@lougher.demon.co.uk>
	<ac3eb2510901081824g38abc47g4619e80ffaf8f1c5@mail.gmail.com>
	<20090109023629.GA29520@linuxace.com>
	<20090109165422.GF24884@logfs.org>
	<20090109193738.GA9827@linode.davidb.org>
	<20090109211937.GA14342@logfs.org>
	<20090110124335.GB30744@elte.hu>
	<20090110165033.GA23943@logfs.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Jan 2009 17:50:33 +0100 J__rn Engel <joern@logfs.org> wrote:

> What is the thing that makes a read only
> filesystem special?

Nothing, really.

The filesystem has mount options (I think).  That interface needs to be
maintained.

More importantly, the filesystem driver has to be able to read older
filesystem instances.  This is a userspace-visible binary interface!
A really complex one.

If for some reason we wish to change the on-disk format then that could
be done now.  But once the code is merged, such changes could only be
done in a back-compatible way.

And the day-one code (ie: this code) would need to be designed so that
such on-disk changes can be made - we don't want old kernels exploding
when asked to read new-layout filesystem instances.  This is what `grep
-i compat include/linux/ext2_fs.h' is all about.

