Return-Path: <linux-kernel-owner+w=401wt.eu-S1754280AbYKGQGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280AbYKGQGU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 11:06:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbYKGQGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 11:06:04 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48161 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751796AbYKGQGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 11:06:01 -0500
Date: Fri, 7 Nov 2008 08:05:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com, viro@ZenIV.linux.org.uk,
       containers@lists.osdl.org
Subject: Re: [PATCH 2/7] proc: Implement support for automounts in task
 directories
Message-Id: <20081107080529.6f4de3ad.akpm@linux-foundation.org>
In-Reply-To: <m1d4h7v8jf.fsf@frodo.ebiederm.org>
References: <m1ej1p2l6u.fsf@frodo.ebiederm.org>
	<m1abcd2kqk.fsf@frodo.ebiederm.org>
	<20081106172617.dd51d0af.akpm@linux-foundation.org>
	<m1abccxpc5.fsf@frodo.ebiederm.org>
	<20081106184945.179c248a.akpm@linux-foundation.org>
	<m1iqr0urb8.fsf@frodo.ebiederm.org>
	<20081106202822.a1af8a6e.akpm@linux-foundation.org>
	<m1d4h7v8jf.fsf@frodo.ebiederm.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Nov 2008 07:51:32 -0800 ebiederm@xmission.com (Eric W. Biederman) wrote:

> >> and where this is at least partially
> >> a bug fix I would rather not have the change depend on enhancing
> >> the VFS.
> >> 
> >> The algorithm is actually very aggressive and in practice you don't
> >> see any /proc/<pid>/net showing up as a mount point.
> >
> > Do you think it has failure modes?  Most particularly: obscure usage
> > patterns which can cause memory exhaustion?
> 
> I don't think we can pin anything that way that we can't
> pin right now.
> 
> You might be able to pin more if you happen to mount something
> on top of /proc/<pid>/net/  but that is an unprivileged operation.

I was thinking more along the lines of some repeated operation which
generates reclaimable storage, only nothing reclaims that storage
sufficiently promptly (the 500 second delay, perhaps).

Like the problem we had with SLAB_DESTROY_BY_RCU and, umm, I think it
was route cache entries increasing like mad and not getting reaped.
