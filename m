Return-Path: <linux-kernel-owner+w=401wt.eu-S1758789AbYEERDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758789AbYEERDs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 13:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754916AbYEERDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 13:03:39 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:49388 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219AbYEERDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 13:03:38 -0400
To: miklos@szeredi.hu
CC: viro@ZenIV.linux.org.uk, weigelt@metux.de, linux-kernel@vger.kernel.org
In-reply-to: <E1Jt3nB-0006ZP-6S@pomaz-ex.szeredi.hu> (message from Miklos
	Szeredi on Mon, 05 May 2008 18:43:57 +0200)
Subject: Re: VFS + path walktrough
References: <20080505124041.GB32019@nibiru.local> <20080505130623.GC32019@nibiru.local> <20080505131307.GM5882@ZenIV.linux.org.uk> <20080505134315.GF32019@nibiru.local> <20080505153501.GN5882@ZenIV.linux.org.uk> <E1Jt3nB-0006ZP-6S@pomaz-ex.szeredi.hu>
Message-Id: <E1Jt469-0006db-Ct@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 05 May 2008 19:03:33 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > * Al Viro <viro@ZenIV.linux.org.uk> wrote:
> > > > That you have quite forgotten about mounts.  
> > > 
> > > hmm, I though this would be done before the link_path_walk() 
> > > call happens ;-o
> > 
> > How on the earth...?  You don't know where will pathname resolution
> > get you, so how could you possibly handle mountpoint transitions prior
> > to it?
> 
> One way this could be done cleanly, is to pass the rest of the path
> (as hint) to the filesystem in its lookup function.  Most filesystems
> would just ignore it, but those which have the capabilities can use it
> to do the lookup in one go, and internally

Better, the filesystem can just populate the dcache with the result.
The entry being looked up is locked, so noone can get at it, and so it
should be quite safe to build a tree below.

Miklos
