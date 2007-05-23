Return-Path: <linux-kernel-owner+w=401wt.eu-S1765367AbXEWJah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765367AbXEWJah (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 05:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758263AbXEWJaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 05:30:25 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:52714 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764992AbXEWJaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 05:30:23 -0400
To: jblunck@suse.de
CC: viro@ftp.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
In-reply-to: <4de7f8a60705230216n4425e19bqddd8b54b6a0ff74a@mail.gmail.com>
	(jblunck@suse.de)
Subject: Re: [RFC PATCH] file as directory
References: <E1HqZPd-0008Dh-00@dorka.pomaz.szeredi.hu>
	 <20070522221045.GH4095@ftp.linux.org.uk>
	 <E1HqkS4-00017K-00@dorka.pomaz.szeredi.hu>
	 <20070523070306.GM4095@ftp.linux.org.uk>
	 <E1Hql7t-0001EQ-00@dorka.pomaz.szeredi.hu>
	 <20070523073658.GO4095@ftp.linux.org.uk>
	 <E1HqlqT-0001KD-00@dorka.pomaz.szeredi.hu> <4de7f8a60705230216n4425e19bqddd8b54b6a0ff74a@mail.gmail.com>
Message-Id: <E1Hqn9I-0001V1-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 23 May 2007 11:28:52 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > So your question is, which mount takes priority on the lookup?  It
> > probably should be the propagated real mount, rather than the
> > dir-on-file one, shouldn't it?
> >
> 
> Maybe this might belong into __link_path_walk() similar to the
> handling of symbolic links. If the real mount has always higher
> priority why do we bother in follow_mount() about it.

Do you mean, that follow_mount() should never descend into the
dir-on-file mount but that should always be done by
__link_path_walk()?

This could make sense.

__lookup_mnt() currently returns the first matching mount in the hash
list.  With your suggestion, we'd need two __lookup_mnt() variants (or
a parameter).  One, that only matches normal mounts, and one that only
matches dir-on-file mounts.  Is that it?

Miklos
