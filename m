Return-Path: <linux-kernel-owner+w=401wt.eu-S1760656AbZFQUkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760656AbZFQUkI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 16:40:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbZFQUj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 16:39:58 -0400
Received: from smtp-out.google.com ([216.239.33.17]:24796 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbZFQUj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 16:39:57 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=b5+CZJg+wz/F0meBLW9R19JszbJBtH9nZlq12ifsyfUZRRlzIc6y2ydiqQWidSObO
	YNHPYsXbWv5sIgtVE6Aog==
Date: Wed, 17 Jun 2009 13:39:52 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michael Tokarev <mjt@tls.msk.ru>
cc: "J. Bruce Fields" <bfields@fieldses.org>,
       Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.29.1: nfsd: page allocation failure - nfsd or kernel
 problem?
In-Reply-To: <4A395119.5060108@msgid.tls.msk.ru>
Message-ID: <alpine.DEB.2.00.0906171335590.4786@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0906161203160.27742@p34.internal.lan> <alpine.DEB.2.00.0906161205260.27742@p34.internal.lan> <4A37FE48.6070306@msgid.tls.msk.ru> <4A38ACC0.3060501@msgid.tls.msk.ru> <alpine.DEB.2.00.0906170542170.3600@p34.internal.lan>
 <4A38C7CA.7040005@msgid.tls.msk.ru> <20090617185139.GF24040@fieldses.org> <4A395119.5060108@msgid.tls.msk.ru>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Jun 2009, Michael Tokarev wrote:

> > 	http://bugzilla.kernel.org/show_bug.cgi?id=13518
> 
> Does not look similar.
> 
> I repeated the issue here.  The slab which is growing here is buffer_head.
> It's growing slowly -- right now, after ~5 minutes of constant writes over
> nfs, its size is 428423 objects, growing at about 5000 objects/minute rate.
> When stopping writing, the cache shrinks slowly back to an acceptable
> size, probably when the data gets actually written to disk.
> 

Not sure if you're referring to the bugzilla entry or Justin's reported 
issue.  Justin's issue is actually allocating a skbuff_head_cache slab 
while the system is oom.

> It looks like we need a bug entry for this :)
> 
> I'll re-try 2.6.30 hopefully tomorrow.
> 

You should get the same page allocation failure warning with 2.6.30.  You 
may want to try my patch in http://lkml.org/lkml/2009/6/17/437 which 
suppresses the warnings since, as you previously mentioned, there are no 
side effects and the failure is easily recoverable.
