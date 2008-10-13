Return-Path: <linux-kernel-owner+w=401wt.eu-S1756557AbYJMPXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557AbYJMPXa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 11:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754558AbYJMPXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 11:23:19 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:33261 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbYJMPXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 11:23:19 -0400
To: cl@linux-foundation.org
CC: penberg@cs.helsinki.fi, nickpiggin@yahoo.com.au, hugh@veritas.com,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-reply-to: <E1KpOjX-0003dt-AY@pomaz-ex.szeredi.hu> (message from Miklos
	Szeredi on Mon, 13 Oct 2008 16:49:19 +0200)
Subject: Re: SLUB defrag pull request?
References: <1223883004.31587.15.camel@penberg-laptop> <1223883164.31587.16.camel@penberg-laptop> <Pine.LNX.4.64.0810131227120.20511@blonde.site> <200810132354.30789.nickpiggin@yahoo.com.au> <E1KpNwq-0003OW-8f@pomaz-ex.szeredi.hu> <E1KpOOL-0003Vf-9y@pomaz-ex.szeredi.hu> <48F378C6.7030206@linux-foundation.org> <E1KpOjX-0003dt-AY@pomaz-ex.szeredi.hu>
Message-Id: <E1KpPFv-0003ol-NV@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 13 Oct 2008 17:22:47 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And BTW the whole thing seems to be broken WRT umount.  Getting a
reference to a dentry or an inode without also getting reference to a
vfsmount is going to result in "VFS: Busy inodes after unmount of
%s. Self-destruct in 5 seconds.  Have a nice day...\n".  And getting a
reference to the vfsmount will result in EBUSY when trying to umount,
which is also not what we want.

So it seemst that this two pass method will not work with dentries or
inodes at all :(

Miklos
