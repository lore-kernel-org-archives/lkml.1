Return-Path: <linux-kernel-owner+w=401wt.eu-S965396AbXCFRn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965396AbXCFRn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 12:43:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965397AbXCFRn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 12:43:26 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965396AbXCFRnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 12:43:25 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0703060910340.5963@woody.linux-foundation.org> 
References: <Pine.LNX.4.64.0703060910340.5963@woody.linux-foundation.org>  <1173200555.9349.2.camel@localhost.localdomain> 
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: get_order() broken ! 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Tue, 06 Mar 2007 17:43:16 +0000
Message-ID: <2793.1173202996@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Yeah, I think the recent get_order() changes to change it to use ilog2() 
> are just crap. I actually looked at it when it went in, but I assumed that 
> it had been tested. I don't think it has.

It had, it's just that the testing totally failed to show up the problem; that
and I think my userspace testing went wrong because I made the wrong
assumptions about what the answer should be.

However, having discussed it with Ben, HPA and David Woodhouse and others I've
come up with a patch (sent separately) that should fix it by using:

	ilog2((n) - 1) + 1 

as the basis for the calculation as this should round up the result.  I've
encapsulated this as a function called ilog2_up() and fixed the docs to make
it cleared how ilog2() and co actually work.

David
