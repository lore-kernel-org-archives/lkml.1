Return-Path: <linux-kernel-owner+w=401wt.eu-S1757499AbXF0Ec5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499AbXF0Ec5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 00:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751707AbXF0Ecs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 00:32:48 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:3182 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbXF0Ecs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 00:32:48 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 26 Jun 2007 21:32:44 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Rik van Riel <riel@redhat.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/3] MAP_NOZERO - implement a new VM_NOZERO/MAP_NOZERO
 page retirement policy
In-Reply-To: <4681E52A.8030300@redhat.com>
Message-ID: <Pine.LNX.4.64.0706262127300.26540@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.29496.1182912259.1>
 <4681D37E.2020706@redhat.com> <Pine.LNX.4.64.0706262016080.26540@alien.or.mcafeemobile.com>
 <4681E52A.8030300@redhat.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2007, Rik van Riel wrote:

> Davide Libenzi wrote:
> > On Tue, 26 Jun 2007, Rik van Riel wrote:
> > 
> > > SUID programs should not be able to use this feature,
> > > either.
> > 
> > Why? A SUID programs runs under the UID of the owner, and should be no
> > problems in it seeing the owners data.
> 
> Because an SUID program can change its UID back.
> 
> At least, one that was SUID root.  OTOH, any
> program running as root can change UID, so we
> should probably not allow root to get nonzeroed
> pages.

Well, root can in general access the whole system in any case. At the 
moment, root cannot access othe UIDs pages. Only their own. And this 
differs from standard security policies where root can access everything.
Pages used internally by the kernel, cannot be reused by anyone.



> > I tried to look, and the attempt to reuse _mapcount failed miserably :)
> > The last time we have the owner info (vma->mm) available, is before
> > processing of the other fields ends. OTOH I'm not VM guru either, so I may
> > be wrong. It can share ->virtual (when enabled).
> 
> I think the process that actually calls the page freeing
> functions is always the process that owned the page, so
> going for current->mm should work.

I'll try to see if that works out...



- Davide


