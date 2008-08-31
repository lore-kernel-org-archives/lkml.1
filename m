Return-Path: <linux-kernel-owner+w=401wt.eu-S1757937AbYHaD74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937AbYHaD74 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 23:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbYHaD7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 23:59:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57421 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751089AbYHaD7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 23:59:47 -0400
Date: Sat, 30 Aug 2008 20:58:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Jordan Crouse <jordan.crouse@amd.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, David Witbrodt <dawitbro@sbcglobal.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers <kernel-testers@vger.kernel.org>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit
 a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
In-Reply-To: <86802c440808302053r46256f68mf356797a259ad164@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0808302055040.12958@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>  <alpine.LFD.1.10.0808301214310.3290@nehalem.linux-foundation.org>  <86802c440808301314t525d1b75r9afcc73857cf5c79@mail.gmail.com>  <alpine.LFD.1.10.0808301539391.3290@nehalem.linux-foundation.org>
  <86802c440808301550s627dfcb0h7ff8971c8248703a@mail.gmail.com>  <alpine.LFD.1.10.0808301615450.3290@nehalem.linux-foundation.org>  <86802c440808301639j137ebef1r1ecadeebd351fc03@mail.gmail.com>  <86802c440808301727k3e86c816j323eca0fb5e3f4fc@mail.gmail.com>
  <86802c440808301750w6655bbek557e6a23b8036654@mail.gmail.com>  <alpine.LFD.1.10.0808301949100.3290@nehalem.linux-foundation.org> <86802c440808302053r46256f68mf356797a259ad164@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 30 Aug 2008, Yinghai Lu wrote:
>
> then
> 1. we should not probe them in probe.c
> 2. at least we should not try to request_resource for them in
> pcibios_resource_survey...
> 
> just pretend that they are not existing.

You are missing the fact that we need to know where existing resources 
are, even if we can't do anything about them!

Read my explanation from yesterday about why we need to add the e820 
resources to the resource map in the first place.

Short recap:

 - we need to populate the resource map with as much possible information 
   about the system as we can..

 - .. because when we assign _dynamic_ resources, we need to make sure 
   that they don't clash with random system resources that we don't really 
   otherwise have a lot of visibility into.

So the resource tree is not just about resources we control, it's also 
about resources that others control(led) and we don't necessarily know a 
lot about.

			Linus
