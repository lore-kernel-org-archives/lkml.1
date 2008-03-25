Return-Path: <linux-kernel-owner+w=401wt.eu-S1758895AbYCYTPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895AbYCYTPK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 15:15:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757205AbYCYTO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 15:14:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34216 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757065AbYCYTO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 15:14:58 -0400
Date: Tue, 25 Mar 2008 12:14:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RWSEM: Rewrite rwsem.c and rwsem-spinlock.c more
 simply.
Message-Id: <20080325121438.883f7ceb.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0803250834220.19530@localhost.localdomain>
References: <alpine.LFD.1.00.0803250659530.18358@localhost.localdomain>
	<87skyfgg4y.fsf@basil.nowhere.org>
	<alpine.LFD.1.00.0803250813190.19386@localhost.localdomain>
	<20080325123633.GL2170@one.firstfloor.org>
	<alpine.LFD.1.00.0803250834220.19530@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar 2008 08:42:48 -0400 (EDT)
"Robert P. J. Day" <rpjday@crashcourse.ca> wrote:

> On Tue, 25 Mar 2008, Andi Kleen wrote:
> 
> > > i'm not sure what this means -- which of the transformations in
> > > that patch is considered unsafe?  here's a typical simplification:
> >
> > It is not unsafe, just generates slight worse code.
> >
> > current is inline assembler and the compiler doesn't know that it
> > could cache it in a register because it is not marked pure for
> > various reasons. That is why current is often cached explicitely in
> > a local variable to tell the compiler that.
> 
>   ah, i think i see, thanks.  learn something every day.

A crude measyure is /usr/bin/size.  Your patch increased rwsem-spinlock.o
from 1595 bytes of text up to 1629.

A text size increase isn't necessarily always a bad thing, but it does need
to be monitored, understood, explained, etc.

