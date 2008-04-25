Return-Path: <linux-kernel-owner+w=401wt.eu-S1754117AbYDYHXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbYDYHXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 03:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbYDYHXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 03:23:05 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:51303 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955AbYDYHXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 03:23:04 -0400
To: viro@ZenIV.linux.org.uk
CC: miklos@szeredi.hu, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, dave@linux.vnet.ibm.com,
       ezk@cs.sunysb.edu, mhalcrow@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <20080424155954.GM15214@ZenIV.linux.org.uk> (message from Al Viro
	on Thu, 24 Apr 2008 16:59:54 +0100)
Subject: Re: [patch 00/13] vfs: add helpers to check r/o bind mounts
References: <E1Jp18b-0003iB-FK@pomaz-ex.szeredi.hu> <20080424134826.GD15214@ZenIV.linux.org.uk> <20080424140000.GE15214@ZenIV.linux.org.uk> <E1Jp2Fo-0003sr-BX@pomaz-ex.szeredi.hu> <20080424143537.GG15214@ZenIV.linux.org.uk> <E1Jp2ey-0003zd-TL@pomaz-ex.szeredi.hu> <20080424144815.GI15214@ZenIV.linux.org.uk> <E1Jp2tc-00044i-6k@pomaz-ex.szeredi.hu> <20080424152129.GK15214@ZenIV.linux.org.uk> <E1Jp3Vz-0004FH-Ih@pomaz-ex.szeredi.hu> <20080424155954.GM15214@ZenIV.linux.org.uk>
Message-Id: <E1JpIGK-0005zh-Sk@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 25 Apr 2008 09:22:28 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> OK, explain me, in small words, WTF should something that wants to do
> operations on filesystem tree have a vfsmount.  Slowly.

And BTW in the highly unlikely case, that something didn't have a
vfsmount and wanted to do some operation, it _should_ definitely just
allocate a kernel-private mount for that.  Why?  Because that means
that another interface, namely the grab-sb-for-write and
release-sb-for-write interfaces won't have to be exported for such
users, resulting in an overall smaller and simpler API.  And that's
good.

Now tell me in small words, why do we need the vfs_ interface to stay
around?

Miklos
