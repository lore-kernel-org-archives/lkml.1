Return-Path: <linux-kernel-owner+w=401wt.eu-S1758486AbXF0D3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758486AbXF0D3B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 23:29:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbXF0D2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 23:28:52 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:4214 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbXF0D2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 23:28:52 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 26 Jun 2007 20:28:49 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Rik van Riel <riel@redhat.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/3] MAP_NOZERO - implement a new VM_NOZERO/MAP_NOZERO
 page retirement policy
In-Reply-To: <4681D37E.2020706@redhat.com>
Message-ID: <Pine.LNX.4.64.0706262016080.26540@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.29496.1182912259.1>
 <4681D37E.2020706@redhat.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2007, Rik van Riel wrote:

> SUID programs should not be able to use this feature,
> either.

Why? A SUID programs runs under the UID of the owner, and should be no 
problems in it seeing the owners data.
But the patch post was more a quest for possible scenarios where the use 
of MAP_NOZERO can result in lower security WRT the same program (under the 
same security restrictions) not using such feature.
If you have something specific in mind, please go ahead and shoot.



> > When pages exit (unmapped from) a  vma, they are marked with the effective
> > UID of the  mm_struct  that owns it.
> 
> 
> > --- linux-2.6.mod.orig/include/linux/mm_types.h	2007-06-21
> > 14:02:06.000000000 -0700
> > +++ linux-2.6.mod/include/linux/mm_types.h	2007-06-25 19:11:22.000000000
> > -0700
> > @@ -64,6 +64,7 @@
> >  	struct list_head lru;		/* Pageout list, eg. active_list
> >  					 * protected by zone->lru_lock !
> >  					 */
> > +	int owner_uid;			/* Last owner of the page */
> >  	/*
> >  	 * On machines where all RAM is mapped into kernel address space,
> >  	 * we can simply calculate the virtual address. On machines with
> 
> Since this is only set when the page is freed, could
> the owner_uid and security context be put inside a
> union with some fields that are not otherwise used
> for free pages?

I tried to look, and the attempt to reuse _mapcount failed miserably :)
The last time we have the owner info (vma->mm) available, is before 
processing of the other fields ends. OTOH I'm not VM guru either, so I may 
be wrong. It can share ->virtual (when enabled).




- Davide


