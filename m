Return-Path: <linux-kernel-owner+w=401wt.eu-S1764897AbYEOT6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764897AbYEOT6k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 15:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759001AbYEOT4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 15:56:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47176 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762466AbYEOT4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 15:56:18 -0400
Date: Thu, 15 May 2008 12:54:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: ajones@riverbed.com, a.p.zijlstra@chello.nl, mszeredi@suse.cz,
       akpm@linux-foundation.org, kay.sievers@vrfy.org, greg@kroah.com,
       trond.myklebust@fys.uio.no, linux-kernel@vger.kernel.org
Subject: Re: [BUG] mm: bdi: export BDI attributes in sysfs
In-Reply-To: <E1Jwj7G-0007Zs-GB@pomaz-ex.szeredi.hu>
Message-ID: <alpine.LFD.1.10.0805151247010.3019@woody.linux-foundation.org>
References: <20080513190435.GG23649@ajones-laptop.nbttech.com> <20080514144030.GD6458@ajones-laptop.nbttech.com> <E1JwiZa-0007UA-Tm@pomaz-ex.szeredi.hu> <alpine.LFD.1.10.0805151213430.3019@woody.linux-foundation.org> <E1Jwj7G-0007Zs-GB@pomaz-ex.szeredi.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 15 May 2008, Miklos Szeredi wrote:
> 
> Actually nothing should need protection.  The only problem AFAICS is
> that the device_create()/dev_set_drvdata() interface is racy: somebody
> can come in after the device has been created but before drvdata has
> been set, and then we are in trouble.

Well, I'm not sure that the locking should be at that level. Maybe the 
locking *should* be in the driver that does this. It may need to do other 
setup too, after all.

Of course, doing a device_create_drvdata() thing might be the right 
solution, at least part of the time. Greg?

		Linus
