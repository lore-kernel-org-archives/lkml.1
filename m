Return-Path: <linux-kernel-owner+w=401wt.eu-S1032518AbXEHWgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032518AbXEHWgq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 18:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968440AbXEHWgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 18:36:42 -0400
Received: from smtp-out.google.com ([216.239.45.13]:14573 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968474AbXEHWgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 18:36:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=F18/xHjWC31B4KWMNJYD7LHVGmGDNNtOf7OEbqBEK/fn9Pmpasw0d/3wTi8PrOJ+K
	JnsTbHJ7e2QV+LWUx3TUg==
Date: Tue, 8 May 2007 15:35:31 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Sokolovsky <pmiscml@gmail.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: [RFC/PATCH] doc: volatile considered evil
In-Reply-To: <4640F9C4.8050804@goop.org>
Message-ID: <alpine.DEB.0.99.0705081531270.26621@chino.kir.corp.google.com>
References: <516386418.20070501080839@gmail.com> <20070430235642.e576e917.akpm@linux-foundation.org>
 <20070508121404.17bd97a6.randy.dunlap@oracle.com>
 <alpine.DEB.0.99.0705081217180.12908@chino.kir.corp.google.com>
 <4640E98B.4030107@goop.org> <alpine.DEB.0.99.0705081423500.24138@chino.kir.corp.google.com>
 <4640ED7D.708@goop.org> <alpine.DEB.0.99.0705081453350.25466@chino.kir.corp.google.com>
 <4640F3FD.80001@goop.org> <alpine.DEB.0.99.0705081510370.25865@chino.kir.corp.google.com>
 <4640F9C4.8050804@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007, Jeremy Fitzhardinge wrote:

> Sounds like it's referring to micro-architectural reordering, which is
> distinct from compiler reordering.  In other words, even if you
> specified "-mvolatile-asm-stop" I would assume that the compiler could
> still reorder the asm statements.  Am I right, or should I read more
> into the manual description than it actually says?
> 

The ia64 architecture does not include any interlocks for asm constructs 
and allow them to be executed in parallel without stop bits (although it 
should emit a diagnostic message from gcc, although that is not a 
constraint that was introduced in C99).  Adding -mvolatile-asm-stops will 
add these stop bits for any asm volatile construct that does not already 
have them so that gcc is aware that it is unsafe to execute such 
constructs in parallel.

 [ This is a tangent because we currently don't have -mvolatile-asm-stop
   support and it's ia64-specific.  If they ever request such support,
   then this will simply alter your warning about reordering asm
   volatile constructs to exclude the ia64 case. ]

		David
