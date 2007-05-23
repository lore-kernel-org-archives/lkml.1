Return-Path: <linux-kernel-owner+w=401wt.eu-S1764850AbXEWMF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764850AbXEWMF2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 08:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758852AbXEWMFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 08:05:18 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:37274 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758390AbXEWMFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 08:05:17 -0400
Date: Wed, 23 May 2007 14:01:24 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, viro@ftp.linux.org.uk,
       torvalds@linux-foundation.org
Subject: Re: [RFC PATCH] file as directory
In-Reply-To: <E1HqZPd-0008Dh-00@dorka.pomaz.szeredi.hu>
Message-ID: <Pine.LNX.4.61.0705231358020.4452@yvahk01.tjqt.qr>
References: <E1HqZPd-0008Dh-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 22 2007 20:48, Miklos Szeredi wrote:
>Why do we want this?
>--------------------
>
>That depends on who you ask.  My answer is this:
>
>  'foo.tar.gz/foo/bar' or
>  'foo.tar.gz/contents/foo/bar'
>
>or something similar.

Stole reiser4 an idea.
These semantics are quite fragile. Until now, chdir is only possible
for directories (otherwise, -ENOTDIR), and opening a directory without
O_DIRECTORY gives -EISDIR. You can't just change semantics.

That said, with FUSE, something like this should already be possible,
should not it?

And looking at your example of foo.tar.gz/foo/bar,the tar.gz needs to
be read at least once to get at foo/bar.


	Jan
-- 
