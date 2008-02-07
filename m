Return-Path: <linux-kernel-owner+w=401wt.eu-S1758854AbYBGIK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758854AbYBGIK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 03:10:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754394AbYBGIKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 03:10:06 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:59873 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758126AbYBGIKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 03:10:01 -0500
To: serue@us.ibm.com
CC: miklos@szeredi.hu, serue@us.ibm.com, akpm@linux-foundation.org,
       hch@infradead.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <20080206224527.GB24246@sergelap.austin.ibm.com>
	(serue@us.ibm.com)
Subject: Re: [patch 07/10] unprivileged mounts: add sysctl tunable for
	"safe" property
References: <20080205213616.343721693@szeredi.hu> <20080205213705.120219893@szeredi.hu> <20080206202110.GA20528@sergelap.ibm.com> <E1JMrXw-0000qq-O9@pomaz-ex.szeredi.hu> <20080206224527.GB24246@sergelap.austin.ibm.com>
Message-Id: <E1JN1p3-0001zF-4l@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 07 Feb 2008 09:09:29 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Maybe sysctls just need to check capabilities, instead of uids.  I
> > think that would make a lot of sense anyway.
> 
> Would it be as simple as tagging the inodes with capability sets?  One
> set for writing, or one each for reading and writing?

Yes, or something even simpler, like mapping the owner permission bits
to CAP_SYS_ADMIN.  There seem to be very few different permissions
under /proc/sys:

--w-------
-r--r--r--
-rw-------
-rw-r--r--

As long as the group and other bits are always the same, and we accept
that the owner bits really mean CAP_SYS_ADMIN and not something else,
then the permission check would not need to look at uids or gids at
all.

Miklos
