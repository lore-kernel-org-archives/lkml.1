Return-Path: <linux-kernel-owner+w=401wt.eu-S1163294AbXD1SSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163294AbXD1SSg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:18:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163465AbXD1SSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 14:18:30 -0400
Received: from smtp-out.google.com ([216.239.45.13]:38270 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1163297AbXD1SSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 14:18:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:from:message-id:to:cc:subject:date:mime-version:
	content-type:content-transfer-encoding:x-mailer:in-reply-to:x-mimeole:thread-index;
	b=Z+uhThAWvguY5xvhUT0pGAeylv1yzqma47ILt4uzZOlgjdKbpj0It1md5oEEuD+tI
	dFkhBJJ9FuiZPTdW7RgiA==
From: Rohit Seth <rohitseth@google.com>
Message-Id: <200704281817.l3SIHu0P001764@smtp.corp.google.com>
To: "'Hugh Dickins'" <hugh@veritas.com>
Cc: "'Nick Piggin'" <nickpiggin@yahoo.com.au>,
       "'Mike Stroyan'" <mike.stroyan@hp.com>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'Luck, Tony'" <tony.luck@intel.com>, <linux-ia64@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: RE: Fw: [PATCH] ia64: race flushing icache in do_no_page path
Date: Sat, 28 Apr 2007 11:17:45 -0700
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook, Build 11.0.6353
In-Reply-To: <Pine.LNX.4.64.0704280620150.9554@blonde.wat.veritas.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Thread-Index: AceJVvEwu7f6EhlxTLuPm01ZMOb+mwAaO6hg
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 Hi Hugh,

-----Original Message-----
From: Hugh Dickins [mailto:hugh@veritas.com] 
Sent: Friday, April 27, 2007 10:34 PM
To: Rohit Seth
Cc: Nick Piggin; Mike Stroyan; Andrew Morton; Luck, Tony;
linux-ia64@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: Fw: [PATCH] ia64: race flushing icache in do_no_page path

On Fri, 27 Apr 2007, Rohit Seth wrote:

> lazy_mmu_prot_update was added specifically for notifying change in 
> protection.  So, in a way it is closer to update_mmu_cache (Which is 
> for change in mappings itself).  Though for ia64 implementation, this 
> ends up flushing the icaches when needed.

>The ia64 implementation is the only one which has any use for it, 

Even Itanium didn't need it for almost 5 years :)  Though I think archs that
have incoherent I & D caches could be (theoritically) exposed to same
(original) mprotect code path bug that triggered this API.

>and 
>it's only interested when it's executable i.e. "lazy_mmu_prot_update"
>is a name concealing some overdesign.

You are right that ia64 is only interested in whne the execute permissions
kick in (and FWIW ia64 used to use update_mmu_cache API to do what it is now
doing lazy_mmu_prot_update).  Though the idea was to design an API that any
arch can use to know when ever there is change in protections on a mapping.

Cheers,
-rohit


