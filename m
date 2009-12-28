Return-Path: <linux-kernel-owner+w=401wt.eu-S1751594AbZL1UrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594AbZL1UrG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 15:47:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbZL1UrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 15:47:05 -0500
Received: from smtp-out.google.com ([216.239.44.51]:22896 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbZL1UrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 15:47:02 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=ual36I9iLLrn4daT7PLUYgRn79CVWj7XtB19Vyev5sIt88Yzoi/htkvV1Bd8vSo8N
	DClQctRnL+eLQjO5pMOag==
Date: Mon, 28 Dec 2009 12:46:55 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Emese Revfy <re.emese@gmail.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [PATCH 3/4] Constify struct kset_uevent_ops for 	2.6.32-git-053fe57ac
 v2
In-Reply-To: <4B355AEF.3060508@gmail.com>
Message-ID: <alpine.DEB.2.00.0912281244400.12772@chino.kir.corp.google.com>
References: <cover.1260663000.git.re.emese@gmail.com>  <eff97be7c5839477c88f7ba61ef100f38c58bf7d.1260663000.git.re.emese@gmail.com> <84144f020912250331h23b8b724v73cf70c384d385ec@mail.gmail.com> <4B355AEF.3060508@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Dec 2009, Emese Revfy wrote:

> >> diff --git a/mm/slub.c b/mm/slub.c
> >> index 4996fc7..fb63aca 100644
> >> --- a/mm/slub.c
> >> +++ b/mm/slub.c
> >> @@ -4522,7 +4522,7 @@ static int uevent_filter(struct kset *kset, struct kobject *kobj)
> >>        return 0;
> >>  }
> >>
> >> -static struct kset_uevent_ops slab_uevent_ops = {
> >> +static const struct kset_uevent_ops slab_uevent_ops = {
> >>        .filter = uevent_filter,
> >>  };
> > 
> >   CC      mm/slub.o
> > mm/slub.c: In function 'slab_sysfs_init':
> > mm/slub.c:4679: warning: passing argument 2 of 'kset_create_and_add'
> > discards qualifiers from pointer target type
> > include/linux/kobject.h:164: note: expected 'struct kset_uevent_ops *'
> > but argument is of type 'const struct kset_uevent_ops *'
> > 
> > Hmm?
> > 
> 
> I double checked both the declaration and definitions of the affected
> function/structure and they are consistently const here.
> Can you tell me what patch/tree combination you encountered this warning with?
> Thanks, Emese
> 

The warning emitted by gcc is pretty explicit; the second formal of 
kset_create_and_add() takes a 'struct kset_uevent_ops *' type while you're 
now passing 'const struct kset_uevent_ops *' as the result of your change.  
That said, kset_create() could probably be modified with the const 
qualifier, but that's outside the scope of your patchset and would have to 
be proposed seperately.
