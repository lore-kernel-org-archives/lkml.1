Return-Path: <linux-kernel-owner+w=401wt.eu-S1754491AbZESKfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbZESKfX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 06:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751782AbZESKfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 06:35:12 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:50383 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbZESKfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 06:35:11 -0400
To: jblunck@suse.de
CC: miklos@szeredi.hu, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       bharata@in.ibm.com, dwmw2@infradead.org, mszeredi@suse.cz,
       vaurora@redhat.com
In-reply-to: <20090519102939.GK16526@bolzano.suse.de> (message from Jan Blunck
	on Tue, 19 May 2009 12:29:39 +0200)
Subject: Re: [PATCH 00/32] VFS based Union Mount (V3)
References: <1242662968-11684-1-git-send-email-jblunck@suse.de> <E1M6LvU-0000mN-HN@pomaz-ex.szeredi.hu> <20090519102939.GK16526@bolzano.suse.de>
Message-Id: <E1M6Mez-0000tG-3q@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 19 May 2009 12:35:01 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 May 2009, Jan Blunck wrote:
> The directory in the topmost filesystem is created during
> lookup. The contents of the directory isn't copied up presistently
> at that point in time. Therefore you have an empty directory in the
> topmost filesystem after the lookup. This was necessary to get rid
> of the union_relookup_topmost() calls during create, mknod, mkdir
> etc.
> 
> When readdir is called, the topmost directory is filed up with
> fallthru entries which are persistently stored. This is only
> necessary to get readdir right wrt POSIX. During lookup the fallthru
> dentry, which is in fact a special negative dentry, is ignored and
> therefore the lookup continues on the lower filesystem.

So this means that the topmost branch always needs to be writable,
right?  It isn't possible to make a union of two iso9660 filesystems,
for example?

Thanks,
Miklos
