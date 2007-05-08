Return-Path: <linux-kernel-owner+w=401wt.eu-S934706AbXEHWUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934706AbXEHWUF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 18:20:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934695AbXEHWT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 18:19:58 -0400
Received: from smtp-out.google.com ([216.239.45.13]:10938 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934644AbXEHWT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 18:19:57 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=YZvcXjv4STD3gmv6G7Il/B/D5WoemdphCLJ0UszaOyMMvCp+KPwwiY2OzYfc4kitY
	9gpzioJ16n5fNQOJoSB4A==
Date: Tue, 8 May 2007 15:19:29 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Sokolovsky <pmiscml@gmail.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: [RFC/PATCH] doc: volatile considered evil
In-Reply-To: <4640F3FD.80001@goop.org>
Message-ID: <alpine.DEB.0.99.0705081510370.25865@chino.kir.corp.google.com>
References: <516386418.20070501080839@gmail.com> <20070430235642.e576e917.akpm@linux-foundation.org>
 <20070508121404.17bd97a6.randy.dunlap@oracle.com>
 <alpine.DEB.0.99.0705081217180.12908@chino.kir.corp.google.com>
 <4640E98B.4030107@goop.org> <alpine.DEB.0.99.0705081423500.24138@chino.kir.corp.google.com>
 <4640ED7D.708@goop.org> <alpine.DEB.0.99.0705081453350.25466@chino.kir.corp.google.com>
 <4640F3FD.80001@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007, Jeremy Fitzhardinge wrote:

> > You're point about reordering "asm volatile" constructs differs depending 
> > on -mvolatile-asm-stop or -mno-volatile-asm-stop, however.
> >   
> 
> Erm, that seems to be ia64 specific, and I have no idea what adding a
> "stop bit" implies.  Can you set even or odd parity too?
> 

It is analogous with a sequence point for ia64.  But, as you mentioned, it 
is ia64 specific so your comment about "asm volatile" constructs not being 
reordered is always appropriate outside of ia64 specific code but may not 
apply to ia64 if we ever compiled with -mvolatile-asm-stop.  If we do not
compile with that option, the behavior is unspecified.  I don't think 
we'll be adding -mvolatile-asm-stop support any time soon so your warning 
certainly is appropriate for all code at this time.

		David
