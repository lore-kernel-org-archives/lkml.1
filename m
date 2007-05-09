Return-Path: <linux-kernel-owner+w=401wt.eu-S1757074AbXEIKZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074AbXEIKZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 06:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755121AbXEIKZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 06:25:47 -0400
Received: from smtp-out.google.com ([216.239.45.13]:34316 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755024AbXEIKZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 06:25:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=TmYj8Q8ImiI1IhWLMOyDKwU6sasr9gEK98eXbUZ1knJFgWxg4qT7jov9jDSy1sZPz
	/jEqsfMUYNpQOtLME5a6A==
Date: Wed, 9 May 2007 03:25:06 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Sokolovsky <pmiscml@gmail.com>, linux-kernel@vger.kernel.org,
       jeremy@goop.org
Subject: Re: [PATCH] doc: volatile considered evil
In-Reply-To: <20070509102134.5d722386@the-village.bc.nu>
Message-ID: <alpine.DEB.0.99.0705090308150.17598@chino.kir.corp.google.com>
References: <516386418.20070501080839@gmail.com> <20070430235642.e576e917.akpm@linux-foundation.org>
 <20070508121404.17bd97a6.randy.dunlap@oracle.com>
 <a781481a0705081307r546f8889qecca3db16ea03fb8@mail.gmail.com>
 <20070508163452.8b71f682.randy.dunlap@oracle.com>
 <alpine.DEB.0.99.0705081702070.28511@chino.kir.corp.google.com>
 <20070508190800.1334b968.randy.dunlap@oracle.com>
 <alpine.DEB.0.99.0705081934390.20751@chino.kir.corp.google.com>
 <20070509102134.5d722386@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2007, Alan Cox wrote:

> When Might You Need volatile ?
> ------------------------------
> 
> When you are implementing the locking primitives on a new platform. When
> you are implementing the I/O and atomic prmitives on a new platform. Also
> in inline gcc assembler where "volatile" is used for subtly different
> purposes.
> 

What is determined to be an "access" (read or modify) to an object such 
as a locking primitive that is type-qualified with the keyword 'volatile' 
is implementation defined.

You cannot guarantee that the value in such an object would agree 
with the evaluation thus far as specified by the semantics of the code
even at sequence points because such an object can be modified without 
knowledge to the implementation.  The only thing you _can_ guarantee at 
these sequence points is that their previous accesses are complete and 
later accesses, as specified by the semantics of the code, have not yet 
occurred.  This does not exclude the possibility that they were modified 
without knowledge to the implementation.  In this case, the actual and 
abstract semantics of the text may not agree.

Thus, any reliance on type-qualifying an object that represents an atomic 
or locking primitive on the keyword 'volatile' is misplaced.

		David
