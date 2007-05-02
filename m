Return-Path: <linux-kernel-owner+w=401wt.eu-S2992897AbXEBIIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992897AbXEBIIb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 04:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992896AbXEBIIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 04:08:31 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:45216 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992897AbXEBII1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 04:08:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iRm8pWyVP0Isf/0pWcvaK/d0Oi7LEE47QJvEjcCpWemZoS5mH8BOYfIniVVxDLDMBYoXHJVqozd6AVSs42TtzeFg3oPIwJVV46F5epmsSa2oDKbeqMXcBwK3qjEp8JN6Xoi0J4lryamkRFV6REWfitfEW/C6nV4t5lfr+LUem0A=
Message-ID: <a36005b50705020108o6fb7495ak2383ae64e49c48a0@mail.gmail.com>
Date: Wed, 2 May 2007 01:08:26 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Eric Dumazet" <dada1@cosmosbay.com>
Subject: Re: [patch 14/22] pollfs: pollable futex
Cc: "Davi Arnaut" <davi@haxent.com.br>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Davide Libenzi" <davidel@xmailserver.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070502095503.a06f5472.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070502052235.914764000@haxent.com.br>
	 <20070502053427.123392000@haxent.com.br>
	 <a36005b50705020040l8874d64m1bcf25da5cae885d@mail.gmail.com>
	 <20070502095503.a06f5472.dada1@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/2/07, Eric Dumazet <dada1@cosmosbay.com> wrote:
> Well, poll() level edge semantic is well defined, you cannot cheat or change it.
>
> If many threads call poll() on the same end point, they should *all* return POLLIN/whatever status.

This means to me it's the wrong abstraction for this.  We had a nice
solution for this with Evgeniy's kevent interfaces.  It worked without
forcing futexes is this inflexible poll() interface.



> This is why programs usually use one thread to dispatch events to workers, or at least dont queue XXXX threads calling poll() on one fd.

No.  This is why programs are forced to waste cycles by doing this.
Ideally this would not happen.  Ideally you'd park all worker thread
in the same place and have them woken up one by one.  Again, Evgeniy's
code was able to do this.  This approach seems to be a big step
backward.
