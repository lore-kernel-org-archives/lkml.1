Return-Path: <linux-kernel-owner+w=401wt.eu-S1751745AbZIPEUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745AbZIPEUz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 00:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbZIPEUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 00:20:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47240 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750742AbZIPEUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 00:20:53 -0400
Date: Tue, 15 Sep 2009 21:20:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Joel Becker <Joel.Becker@oracle.com>
cc: Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ocfs2-devel@oss.oracle.com
Subject: Re: [GIT PULL] ocfs2 changes for 2.6.32
In-Reply-To: <20090915214530.GA11060@mail.oracle.com>
Message-ID: <alpine.LFD.2.01.0909152116180.4950@localhost.localdomain>
References: <20090911200458.GA15416@mail.oracle.com> <alpine.LFD.2.01.0909141417180.4950@localhost.localdomain> <20090914221434.GA4507@mail.oracle.com> <alpine.LFD.2.01.0909141614350.4950@localhost.localdomain> <20090915000417.GC4507@mail.oracle.com>
 <alpine.LFD.2.01.0909141727150.4950@localhost.localdomain> <20090915005417.GD4507@mail.oracle.com> <alpine.LFD.2.01.0909141828070.4950@localhost.localdomain> <20090915040601.GE4507@mail.oracle.com> <alpine.LFD.2.01.0909150923180.4950@localhost.localdomain>
 <20090915214530.GA11060@mail.oracle.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Sep 2009, Joel Becker wrote:
>
> 	Perhaps ->copyfile takes the following flags:
> 
> #define ALLOW_COW_SHARED	0x0001
> #define REQUIRE_COW_SHARED	0x0002
> #define REQUIRE_BASIC_ATTRS	0x0004
> #define REQUIRE_FULL_ATTRS	0x0008
> #define REQUIRE_ATOMIC		0x0010
> #define SNAPSHOT		(REQUIRE_COW_SHARED |
> 				 REQUIRE_BASIC_ATTRS |
> 				 REQUIRE_ATOMIC)
> #define SNAPSHOT_PRESERVE	(SNAPSHOT | REQUIRE_FULL_ATTRS)
> 
> Thus, sys_reflink/sys_snapfile(oldpath, newpath, 0) becomes:
> ...

Yes. The above all sounds sane to me.

I still worry that especially the non-atomic case will want some kind of 
partial-copy updates (think graphical file managers that want to show the 
progress of the copy), and that (think EINTR and continuing) makes me 
think "that could get really complex really quickly", but that's something 
that the NFS/SMB people would have to pipe up on. I'm pretty sure the NFS 
spec has some kind "partial completion notification" model, I dunno about 
SMB.

			Linus
