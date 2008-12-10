Return-Path: <linux-kernel-owner+w=401wt.eu-S1756132AbYLJRk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbYLJRk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 12:40:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753250AbYLJRkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 12:40:11 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41196 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753181AbYLJRkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 12:40:09 -0500
Date: Wed, 10 Dec 2008 09:39:10 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Manfred Spraul <manfred@colorfullife.com>
cc: linux-kernel@vger.kernel.org, cebbert@redhat.com, airlied@gmail.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH] lib/idr.c: Fix bug introduced by RCU fix
In-Reply-To: <200812101729.mBAHTGdr008642@mail.q-ag.de>
Message-ID: <alpine.LFD.2.00.0812100938210.3340@localhost.localdomain>
References: <200812101729.mBAHTGdr008642@mail.q-ag.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 10 Dec 2008, Manfred Spraul wrote:
>
> The last patch to lib/idr.c caused a bug if idr_get_new_above() was
> called on an empty idr:
> Usually, nodes stay on the same layer. New layers are added to the top
> of the tree.
> The exception is idr_get_new_above() on an empty tree: In this case,
> the new root node is first added on layer 0, then moved upwards.
> p->layer was not updated.
> 
> As usual: You shall never rely on the source code comments, they
> will only mislead you.
> 
> Signed-off-by: Manfred Spraul <manfred@colorfullife.com>

Dave Airlie - can you get this tested and acked with the people who saw 
this problem with DRI?

		Linus
