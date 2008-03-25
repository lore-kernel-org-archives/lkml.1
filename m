Return-Path: <linux-kernel-owner+w=401wt.eu-S1755675AbYCYMdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675AbYCYMdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 08:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbYCYMdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 08:33:25 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50426 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278AbYCYMdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 08:33:24 -0400
Date: Tue, 25 Mar 2008 13:36:33 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] RWSEM: Rewrite rwsem.c and rwsem-spinlock.c more simply.
Message-ID: <20080325123633.GL2170@one.firstfloor.org>
References: <alpine.LFD.1.00.0803250659530.18358@localhost.localdomain> <87skyfgg4y.fsf@basil.nowhere.org> <alpine.LFD.1.00.0803250813190.19386@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803250813190.19386@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> i'm not sure what this means -- which of the transformations in that
> patch is considered unsafe?  here's a typical simplification:

It is not unsafe, just generates slight worse code.

current is inline assembler and the compiler doesn't know that it could
cache it in a register because it is not marked pure 
for various reasons. That is why current is often cached explicitely
in a local variable to tell the compiler that.

Before you run off and do that everywhere: it is also not a large
win, just a small one unless current is used very often.

-Andi
