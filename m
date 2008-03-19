Return-Path: <linux-kernel-owner+w=401wt.eu-S940217AbYCTATA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940217AbYCTATA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754075AbYCSXfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 19:35:33 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:50604 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758429AbYCSXfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 19:35:25 -0400
To: viro@ZenIV.linux.org.uk
CC: miklos@szeredi.hu, akpm@linux-foundation.org, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <20080319121235.GM10722@ZenIV.linux.org.uk> (message from Al Viro
	on Wed, 19 Mar 2008 12:12:35 +0000)
Subject: Re: [patch 6/6] vfs: mountinfo: only show mounts under tasks root
References: <20080313212641.989467982@szeredi.hu> <20080313212739.736781502@szeredi.hu> <20080319121235.GM10722@ZenIV.linux.org.uk>
Message-Id: <E1JbxM9-0002GF-K4@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 19 Mar 2008 13:25:21 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  static int show_mountinfo(struct seq_file *m, void *v)
> >  {
> > +	struct proc_mounts *p = m->private;
> > +	size_t count_save = m->count;
> 
> *UGH*.  Do you really need that?  Frankly, in that case I'd rather
> separate the check from __d_path(); unwinds like that are Not Nice(tm).

Agreed.  I did the separate check first, but then there's a window
between the check and __d_path() where the mountpoint might move
outside the root, and trying to prevent that would also add quite a
bit of ugliness.

Miklos
