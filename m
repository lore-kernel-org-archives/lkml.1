Return-Path: <linux-kernel-owner+w=401wt.eu-S1755525AbYEaXrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbYEaXrr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 19:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753618AbYEaXrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 19:47:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44876 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751593AbYEaXrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 19:47:39 -0400
Date: Sat, 31 May 2008 16:47:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, Jens Axboe <jens.axboe@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Ian Campbell <Ian.Campbell@eu.citrix.com>
Subject: Re: [PATCH 5 of 5] xen: Avoid allocations causing swap activity on
 the resume path
Message-Id: <20080531164712.2788baf2.akpm@linux-foundation.org>
In-Reply-To: <4841240A.1000008@goop.org>
References: <c692f3a12da1e99a4a43.1212192095@localhost>
	<4840B0C5.4020606@pobox.com>
	<48411F70.5020100@goop.org>
	<20080531025949.7c8b17bc.akpm@linux-foundation.org>
	<4841240A.1000008@goop.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 May 2008 11:10:18 +0100 Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> > Whether you should also add __GFP_HIGH to cause the page allocation to
> > bite harder into the page reserves is unclear to me, sorry.
> >   
> 
> Well, if the allocation fails the machine is dead in the water, because 
> it probably can't go on without its devices.  I think it's worth eating 
> to the reserves to avoid that.  (I'll have a close look to only add it 
> to allocations which are really unrecoverable if they fail.)

OK.

I don't actually have a clue what you're doing here.  Restoring a
virtual machine from disk/network or something like that?

It might be appropriate to do a big memory-reclaim before starting the
operation, along the lines of suspend-to-disk - go off and allocate
(and possible pin) sufficient memroy for the entire operation before
actually starting it?

