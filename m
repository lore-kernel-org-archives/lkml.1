Return-Path: <linux-kernel-owner+w=401wt.eu-S1756072AbYDVErS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbYDVErS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 00:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbYDVErH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 00:47:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38600 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751130AbYDVErH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 00:47:07 -0400
Date: Mon, 21 Apr 2008 21:46:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: jason.wessel@windriver.com, linux-kernel@vger.kernel.org
Subject: Re: kgdb: core
Message-Id: <20080421214636.617970c6.akpm@linux-foundation.org>
In-Reply-To: <20080421141252.GR9554@elte.hu>
References: <200804181741.m3IHfTeC012089@hera.kernel.org>
	<20080418150930.476ea7aa.akpm@linux-foundation.org>
	<20080421141252.GR9554@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 21 Apr 2008 16:12:52 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> > So please
> > 
> > a) make this a kerneldoc comment and
> > 
> > b) remove the kerneldoc at the definition site(s).
> > 
> > (alternative: teach the kerneldoc system to go fishing in the various 
> > arch directories to find the appropriate documentation, but I don't 
> > know enough about kerneldoc to be able say anything about that).
> 
> well there's lkml feedback ping-pong effect here. It was pointed out in 
> earlier kgdb review that it's an "error" to put kerneldoc into header 
> files.

It is, normally.  Nobody thought about this case.

> I pointed out that it makes no sense to do otherwise but removed 
> the kerneldoc annotation to resolve the "objection".

Duplicating the same stuff in multiple places is the larger sin.  It sounds
like the best compromise would be to kernel-doc the interface in the .h
file and remove the duplicated comments from .c.

Or perhaps we kernel-doc the interface in the x86 .c files and leave it at
that - people should go there to find the docs.  Problem is, this will
presumably generate bad results if one builds the formal kerneldoc output
for a different architecture.  The kerneldoc system could of course fix
this somehow, but I don't know what shape it would take nor how much work
it would be.
