Return-Path: <linux-kernel-owner+w=401wt.eu-S1757143AbYFWOeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143AbYFWOeS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 10:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755322AbYFWOeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 10:34:05 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:59247 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755205AbYFWOeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 10:34:04 -0400
To: viro@ZenIV.linux.org.uk
CC: miklos@szeredi.hu, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, hch@infradead.org
In-reply-to: <20080623135549.GW28946@ZenIV.linux.org.uk> (message from Al Viro
	on Mon, 23 Jun 2008 14:55:49 +0100)
Subject: Re: [patch 2/3] vfs: fix sys_getcwd for detached mounts
References: <20080616112804.930095761@szeredi.hu> <20080616112828.731144133@szeredi.hu> <20080623135549.GW28946@ZenIV.linux.org.uk>
Message-Id: <E1KAn7I-0007E6-St@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 23 Jun 2008 16:34:00 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > After the patch it will give a much saner "/skel" result.
> 
> I'm not sure that /skel is much saner, to be honest.

Just for argument's sake: before the patch getcwd() on detached object
wasn't consistent with any definition of "absolute path".  After the
patch it's at least consistent with defining it as the path from the
ultimate reachable ancestor (which does have at least some historical
relevance).

>  Existing
> behaviour is BS, no arguments about that, but I suspect that
> we want that to be recognizable.  How about doing something
> like detached:<rest of path> instead (c.f. "pipe:[6969]" and
> its ilk)?

OK, obviously current users don't care, otherwise somebody would have
complained about this issue.  So if we agree on "detached:...", I'm
fine with that.

Thanks,
Miklos
