Return-Path: <linux-kernel-owner+w=401wt.eu-S932681AbZJFOHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932681AbZJFOHV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 10:07:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932641AbZJFOHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 10:07:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57010 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932639AbZJFOHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 10:07:19 -0400
Date: Tue, 6 Oct 2009 16:06:41 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH][RFC] add MAP_UNLOCKED mmap flag
Message-ID: <20091006140641.GL9832@redhat.com>
References: <20091006190938.126F.A69D9226@jp.fujitsu.com>
 <20091006102136.GH9832@redhat.com>
 <20091006192454.1272.A69D9226@jp.fujitsu.com>
 <20091006103300.GI9832@redhat.com>
 <2f11576a0910060510y401c1d5ax6f17135478d22899@mail.gmail.com>
 <20091006121603.GK9832@redhat.com>
 <1254837003.21044.283.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254837003.21044.283.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 03:50:03PM +0200, Peter Zijlstra wrote:
> On Tue, 2009-10-06 at 14:16 +0200, Gleb Natapov wrote:
> > > No, I only think your case doesn't fit MC_FUTURE.
> > > I haven't find any real benefit in this patch.
> 
> > I did. It allows me to achieve something I can't now. Steps you provide
> > just don't fit my needs. I need all memory areas (current and feature) to be
> > locked except one. Very big one. You propose to lock memory at some
> > arbitrary point and from that point on all newly mapped memory areas will
> > be unlocked. Don't you see it is different?
> 
> While true, it does demonstrates very sloppy programming. The proper fix
> is to rework qemu to mlock what is needed.
> 
So you are saying for application (any application forget about qemu) to lock
everything except one memory region it needs to provide its own memory allocation
routings and its own dynamic linker? BTW the interface is not symmetric currently.
Application may mmap single memory area locked (MAP_LOCKED), but can't do reverse
if mlockall(MC_FUTURE) was called.

> I'm not sure encouraging mlockall() usage is a good thing. When using
This is up to application programmer to decide whether he wants to use
mlockall() or not. May be he has a good reason do so. As it stands the
existing interface doesn't allow to do what I need without rewriting
libc memory allocator and dynamic linking loader.

> resource locks one had better know what he's doing. mlockall() doesn't
> promote caution.
No need to patronize userspace developers. Lets provide them with
flexible interface and if they'll use it inappropriately we will not use
their software.

--
			Gleb.
