Return-Path: <linux-kernel-owner+w=401wt.eu-S1758124AbYFNI2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124AbYFNI2A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 04:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753683AbYFNI1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 04:27:50 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:55503 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753461AbYFNI1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 04:27:48 -0400
To: hch@infradead.org
Cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 01/15] security: pass path to inode_create
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20080529134903.615127628@szeredi.hu>
	<E1K38aL-0003KY-Qq@pomaz-ex.szeredi.hu>
	<20080602123244.GC8562@parisc-linux.org>
	<200806021445.13831.agruen@suse.de>
In-Reply-To: <200806021445.13831.agruen@suse.de>
Message-Id: <200806141727.ADG13075.FOVHFSFQtOJLOM@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sat, 14 Jun 2008 17:27:41 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Christoph wrote:
> Well, pathname based access control is a dumb idea, and we've been
> through this N times.
I have a question for you.

Matthew Wilcox wrote:
> Yes, if someone mounts /etc onto /etc2/ and has a rule to allow them to
> access /etc/shadow, they will then be able to access /etc2/shadow as
> well (which they weren't able to under previous apparmour).  But I can't
> think of a way that permits Something Bad to happen (since the contents
> of the file could have been accessed through /etc/shadow *anyway*).
No. Something Bad happens even if you use object based access controls.

Andreas Gruenbacher wrote:
> One consequence of this is that pathname-based models must control who is
> allowed to create aliases where, of course.
The object based access controls *also* have to care about pathnames,
or Something Bad happens.

Have you ever thought that the pathname plays some part of security?
Please read part 3 and part 4 of http://lkml.org/lkml/2008/4/12/63 if
you have never thought that.
"Applications depend on pathnames, not on inode's number or labels.
 Thinking little of pathnames leads to serious result."

Why do you think it is a bad thing to implement an access control that
restricts pathnames?
