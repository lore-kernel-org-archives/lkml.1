Return-Path: <linux-kernel-owner+w=401wt.eu-S936298AbYEURyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936298AbYEURyF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 13:54:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763664AbYEURxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 13:53:52 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:33156 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934727AbYEURxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 13:53:51 -0400
Date: Wed, 21 May 2008 18:52:27 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Andrew Morton <akpm@linux-foundation.org>
cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: iput() in reclaim context
In-Reply-To: <20080520232444.8bff5ccf.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0805211840200.13797@blonde.site>
References: <20080515231045.GY155679365@sgi.com>
 <Pine.LNX.4.64.0805161000390.29603@schroedinger.engr.sgi.com>
 <20080519054554.GY103491721@sgi.com> <Pine.LNX.4.64.0805190942530.18431@schroedinger.engr.sgi.com>
 <20080520002503.GC173056135@sgi.com> <20080520065622.GA13968@2ka.mipt.ru>
 <20080520214617.GU103491721@sgi.com> <20080520222505.GA23988@2ka.mipt.ru>
 <20080520231942.GX103491721@sgi.com> <20080520162816.e5dfeffa.akpm@linux-foundation.org>
 <20080521061531.GA27362@2ka.mipt.ru> <20080520232444.8bff5ccf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2008, Andrew Morton wrote:
> On Wed, 21 May 2008 10:15:32 +0400 Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> > On Tue, May 20, 2008 at 04:28:16PM -0700, Andrew Morton (akpm@linux-foundation.org) wrote:
> > > It's more than efficiency.  There are lots and lots of things we cannot
> > > do in direct-reclaim context.
> > > 
> > > ...
> > > 
> > > c) Cannot run iput().  Or at least, we couldn't five or six years
> > >    ago.  afaik nobody has investigated whether the situation is now
> > >    better or worse.

I happened to notice your remark in the buffer heads defrag thread.
Do you remember what that limitation was about?

Because just a few months ago I discovered a shmem race which I fixed
by doing igrab+iput in shmem_writepage, in the reclaim context.  Feeling
guilty now: I'd better investigate, but would welcome a starting pointer.

(If I'm lucky, it'll be that the generic code in vmscan.c cannot
use iput, but particular filesystems might themselves be safe to.)

Thanks,
Hugh
