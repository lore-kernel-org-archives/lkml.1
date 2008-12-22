Return-Path: <linux-kernel-owner+w=401wt.eu-S1754845AbYLVNwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845AbYLVNwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 08:52:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753848AbYLVNwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 08:52:32 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:36650 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbYLVNwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 08:52:31 -0500
To: raven@themaw.net
CC: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org, jblunck@suse.de,
       dlezcano@fr.ibm.com, linux-kernel@vger.kernel.org,
       bharata@linux.vnet.ibm.com, viro@ZenIV.linux.org.uk, vaurora@redhat.com
In-reply-to: <1229651242.3026.39.camel@zeus.themaw.net> (message from Ian Kent
	on Fri, 19 Dec 2008 10:47:22 +0900)
Subject: Re: [rfc git patch] union directory
References: <E1L616K-0005v3-Uc@pomaz-ex.szeredi.hu>
	 <alpine.LFD.2.00.0812171350350.11591@zeus.themaw.net>
	 <E1LDLzo-0007oD-Lg@pomaz-ex.szeredi.hu> <1229651242.3026.39.camel@zeus.themaw.net>
Message-Id: <E1LElCn-0005gp-G1@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 22 Dec 2008 14:52:21 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Dec 2008, Ian Kent wrote:
> Whether the VFS is implementing readdir for a mount's top level or also
> for deeper levels it still has the issue described by Barata Rao in
> http://marc.info/?l=linux-fsdevel&m=118914402631822&w=2. But my
> suggestion doesn't only relate to the readdir issue it implies managing
> such things as whiteout persistence also, but outside of individual file
> systems. So, yes, I'm a bit off topic but the patch series here is going
> to need something like this somewhere to ultimately be useful and all
> I'm saying is that somewhere probably shouldn't be within individual
> file systems and, yes, not in the VFS.

I kind of agree.  I think that adding whiteout (and other bits) to
filesystems to support union{fs,mount} is kludgey.

But I don't agree that union mounts are useless without whiteouts.
Yes, file creation and removal will have unusual semantics, and that
might exclude some (maybe the majority) of uses, but definitely not
all.

> Valerie Henson is planning to start a project (when she is done with
> current commitments) along the lines of a lightweight stacking layer
> with union support included in the file system. These continuing
> individual efforts are a little disjoint so such a project could be an
> ideal way to define what's needed, what the issues are and how it will
> be done in one place. Hopefully everyone that is keen to see progress in
> this area will want to be involved too, ;)

Interesting.

It maybe worth mentioning here that fuse is also a very capable
"stacking layer" and with planned performance improvements it might
become the best option to implement such fs stacks.

Thanks,
Miklos
