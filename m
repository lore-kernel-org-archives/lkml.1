Return-Path: <linux-kernel-owner+w=401wt.eu-S1756438AbYGKXCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438AbYGKXCq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 19:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753620AbYGKXCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 19:02:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54101 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755915AbYGKXCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 19:02:31 -0400
Date: Fri, 11 Jul 2008 16:02:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [patch 13/17] Use WARN() in drivers/base/
Message-Id: <20080711160213.ec94e613.akpm@linux-foundation.org>
In-Reply-To: <20080711155105.70eb496a@infradead.org>
References: <20080708093800.274504ba@infradead.org>
	<20080708095307.6423cb6f@infradead.org>
	<20080711122011.7ddf42ef.akpm@linux-foundation.org>
	<20080711135409.6638498d@infradead.org>
	<20080711151110.ab2b5401.akpm@linux-foundation.org>
	<20080711155105.70eb496a@infradead.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2008 15:51:05 -0700 Arjan van de Ven <arjan@infradead.org> wrote:

> On Fri, 11 Jul 2008 15:11:10 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > 
> > I don't suppose there's any way of tricking the preprocessor into
> > supporting
> > 
> > 	WARN_ON(foo == 42);
> > 
> > as well as
> > 
> > 	WARN_ON(foo == 42, "bite me!");
> > 
> 
> after reading preprocessor docs from gcc and trying some things:
> We can do this. It comes at a price: the price is a blank line in the
> WARN trace for the "no printk comments" case, and we lose the ability
> to override the printk level. (which you can argue is a feature by just
> setting it to KERN_WARNING).
> 
> (and some interesting but otherwise non-harmful preprocessor stuff in
> headers)

the blank line: might be avoidable by doing some extra work at runtime
to recognise its presence?

overriding facility level: doesn't sound very useful, as WARN()'s
stack-trace's facility level is not controllable.

> Is this is price worth paying to not have a second macro?

Dunno, how ugly is the patch?

It would be rather nice to not go and fatten the interface.  Would
there be additional text or data size costs?
