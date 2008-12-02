Return-Path: <linux-kernel-owner+w=401wt.eu-S1754125AbYLBAP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125AbYLBAP7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 19:15:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbYLBAPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 19:15:51 -0500
Received: from smtp-out.google.com ([216.239.45.13]:29596 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbYLBAPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 19:15:50 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=Gpy/6jXur0UJk2QbdYLTN/CVlUq9wNzoo+DSwJw1GFD3fd5i7CQqXx3b1/fCKM/bn
	Ym2R2pK9+sRDwv1o8J50Q==
MIME-Version: 1.0
In-Reply-To: <492FB3FB.6060806@cn.fujitsu.com>
References: <492F9D4C.2020204@cn.fujitsu.com> <492FB3FB.6060806@cn.fujitsu.com>
Date: Mon, 1 Dec 2008 16:15:47 -0800
Message-ID: <6599ad830812011615qe28ac37q7af73920e0f9a429@mail.gmail.com>
Subject: Re: [PATCH 1/2] cgroups: cleanup for dummy root
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2008 at 1:03 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>
> Hmmm...Sorry, this patch is wrong, when a subsystem is inactive thus in
> rootnode, it may still iterate tasks in dummy top cgroup, though currently
> no subsystem does so.

Right - iterating across the tasks in a cgroup for an unmounted
subsystem is a completely valid thing to do. I suppose it might make
sense to optimize that to just scan the tasklist and thread lists in
that case, to avoid the overhead of maintaining the cg links for the
unmounted subsystems, but you'd have to change the cgroup iterator
first, before you stop maintaining the links. Given that I suspect the
main overhead of maintaining the links is taking css_set_lock, I'm not
sure how much it hurts to be keeping the links for the inactive
hierarchies too and keeping the code simpler.

Paul
