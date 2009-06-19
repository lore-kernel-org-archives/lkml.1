Return-Path: <linux-kernel-owner+w=401wt.eu-S1761386AbZFSWi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761386AbZFSWi7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 18:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760994AbZFSWhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 18:37:23 -0400
Received: from smtp-out.google.com ([216.239.45.13]:8619 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760972AbZFSWhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 18:37:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=hrNPi2XM8+C2m4Mx38brxoybl1BaJYAMFZDryjb9Nrs9Wi0eaWrOA7cnJMU9+To0i
	X1x3JxIaqZRQEw1c944Tw==
Date: Fri, 19 Jun 2009 15:37:17 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: David Miller <davem@davemloft.net>, eric.dumazet@gmail.com,
       jpiszcz@lucidpixels.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] ipv4: don't warn about skb ack allocation failures
In-Reply-To: <m1ljnoyn0e.fsf@fess.ebiederm.org>
Message-ID: <alpine.DEB.2.00.0906191524470.30455@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0906180935130.2894@chino.kir.corp.google.com> <20090618.120034.246557840.davem@davemloft.net> <alpine.DEB.2.00.0906181212380.10979@chino.kir.corp.google.com> <20090618.123708.78849607.davem@davemloft.net>
 <m1ljnoyn0e.fsf@fess.ebiederm.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Jun 2009, Eric W. Biederman wrote:

> But Mr. Reintjes if you really want the traces I can set up 
> an script to email them to you every time it happens.  Say about
> 1 a minute from my paltry little farm of machines.
> 

Perhaps you missed my email where I suggested emitting the page allocation 
warnings only when CONFIG_DEBUG_VM is enabled.  It's at 
http://lkml.org/lkml/2009/6/18/355.

We can then keep the __GFP_NOFAIL flag to indicate that the warnings 
should never be emitted for that allocation, regardless of the .config.

It's funny, though, that the problem that originally started this thread 
was quickly diagnosed because of these messages.  As far as I know, my 
suggestion to increase /proc/sys/vm/dirty_background_ratio to kick pdflush 
earlier has prevented the slab allocation failures and not required 
delayed acks for nfsd.

That was possible because of the page allocation failure messages that 
were noticed by the user; without this evidence, the only symptom would 
have been extremely slow I/O over nfs.  This could involve any number of 
subsystems and I doubt the first reaction would have been to enable 
CONFIG_DEBUG_VM.
