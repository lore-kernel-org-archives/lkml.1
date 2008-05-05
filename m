Return-Path: <linux-kernel-owner+w=401wt.eu-S1760888AbYEETJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760888AbYEETJq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 15:09:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbYEETJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 15:09:36 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33574 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbYEETJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 15:09:35 -0400
Date: Mon, 5 May 2008 20:09:34 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Enrico Weigelt <weigelt@metux.de>
Cc: linux kernel list <linux-kernel@vger.kernel.org>
Subject: Re: VFS + path walktrough
Message-ID: <20080505190934.GR5882@ZenIV.linux.org.uk>
References: <20080505131307.GM5882@ZenIV.linux.org.uk> <20080505134315.GF32019@nibiru.local> <20080505153501.GN5882@ZenIV.linux.org.uk> <E1Jt3nB-0006ZP-6S@pomaz-ex.szeredi.hu> <20080505171425.GO5882@ZenIV.linux.org.uk> <E1Jt4Ye-0006hz-9i@pomaz-ex.szeredi.hu> <20080505174048.GP5882@ZenIV.linux.org.uk> <20080505182308.GG32019@nibiru.local> <20080505183420.GQ5882@ZenIV.linux.org.uk> <20080505190243.GI32019@nibiru.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505190243.GI32019@nibiru.local>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 09:02:43PM +0200, Enrico Weigelt wrote:
> * Al Viro <viro@ZenIV.linux.org.uk> wrote:
> 
> > How _can_ server resolve symlinks, when result of symlink 
> > resolution depends on where the damn thing is mounted on client 
> > and even how deeply the process trying to do lookup happens 
> > to be chrooted?
> 
> In the same way as, eg. http servers, do. Of course this fails 
> if the symlink isn't resolvable within server's fs.

Umm...  You know, it might make more sense if you
	* explained what are you really trying to do
	* short of that, perhaps figured out what the hell symlinks and
bindings _are_.

Again, _no_ symlink is resolvable by server alone, simply because
server can not know if target of that symlink is overmounted from
the point of view of whoever is doing lookup.  Note that it *does*
depend on who's doing that and where in the namespace we are seeing
that sucker (the latter kills the "we want per-user connection"
variants).
