Return-Path: <linux-kernel-owner+w=401wt.eu-S1759579AbYEEQoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759579AbYEEQoe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 12:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755953AbYEEQoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 12:44:08 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46392 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755669AbYEEQoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 12:44:07 -0400
To: viro@ZenIV.linux.org.uk
CC: weigelt@metux.de, linux-kernel@vger.kernel.org
In-reply-to: <20080505153501.GN5882@ZenIV.linux.org.uk> (message from Al Viro
	on Mon, 5 May 2008 16:35:01 +0100)
Subject: Re: VFS + path walktrough
References: <20080505124041.GB32019@nibiru.local> <20080505130623.GC32019@nibiru.local> <20080505131307.GM5882@ZenIV.linux.org.uk> <20080505134315.GF32019@nibiru.local> <20080505153501.GN5882@ZenIV.linux.org.uk>
Message-Id: <E1Jt3nB-0006ZP-6S@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 05 May 2008 18:43:57 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > * Al Viro <viro@ZenIV.linux.org.uk> wrote:
> > > That you have quite forgotten about mounts.  
> > 
> > hmm, I though this would be done before the link_path_walk() 
> > call happens ;-o
> 
> How on the earth...?  You don't know where will pathname resolution
> get you, so how could you possibly handle mountpoint transitions prior
> to it?

One way this could be done cleanly, is to pass the rest of the path
(as hint) to the filesystem in its lookup function.  Most filesystems
would just ignore it, but those which have the capabilities can use it
to do the lookup in one go, and internally cache the result.  The VFS
doesn't need to know _anything_ about all this.  If there are
mountpoints, they are already cached, so ->lookup() wouldn't be called
at all, only ->d_revalidate(), which is a different issue.

Miklos
