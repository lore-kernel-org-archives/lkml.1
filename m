Return-Path: <linux-kernel-owner+w=401wt.eu-S1753200AbZKBF4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbZKBF4j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 00:56:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbZKBF4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 00:56:39 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:36180 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbZKBF4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 00:56:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=us4B8ef1mYziKPxO4mXyN0cYrZxgXb+0zGtcTEtMlTYd46Yam4pzfvhA5FvHKsKicQ
         DV5uiLt4bW48zRjc7tVV5RJWDZ6c5Inm+/UyF4b1zg4LAATB8yiG16crIGEgZiUXqMQJ
         Lzuj+QvtsAjvKt4mTHE3kTCU4GhQfIEp8G9Tw=
Date: Mon, 2 Nov 2009 08:56:38 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: remove /proc/*/status "Stack usage:"
Message-ID: <20091102055638.GA2186@x200>
References: <20091101131518.GA18284@x200>
 <1257086397.31587.5.camel@wall-e>
 <20091101155345.GA3867@x200>
 <1257118328.7978.9.camel@wall-e>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257118328.7978.9.camel@wall-e>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 12:32:08AM +0100, Stefani Seibold wrote:
> Am Sonntag, den 01.11.2009, 18:53 +0300 schrieb Alexey Dobriyan:
> > On Sun, Nov 01, 2009 at 03:39:57PM +0100, Stefani Seibold wrote:
> > > Am Sonntag, den 01.11.2009, 16:15 +0300 schrieb Alexey Dobriyan:
> > > > We have /proc/*/pagemap to determine how much stack was consumed.
> > > > Leave "threadstack" though.
> > > > 
> > > 
> > > Stop! /proc/*/pagemap is not a real substitute for the stackm usage
> > > patch. If you have problems with this patch i will have a look on it.
> > 
> > Why?
> > 
> > You grab thread stack start from /proc/*/stat, then for every page of
> > stack VMA, you lookup state of page, which is exactly what you're doing
> > by employing page walker.
> 
> First, as you figured out there is currently no way to get the stack
> start of a thread. But i currently check this and hope to find a
> solution in the next 24 hours.
> 
> Second, this patch aims to the embedded world and there is normally no
> tools available when you need it, but /proc is always there. Especially
> outside in the field.

Poor embedded people!

There is even Documentation/vm/page-types.c which is trivially adapted
to show stack pages state.

> Like Dr Frank. N. Furter in the "Rocky Horror Picture Show" says: remove
> the cause but NOT the symptoms!

The root of the problem is that you're measuring badly defined value.

Kernel doesn't know SP register of a running task until it stops it.
Even if task is stopped or inside kernel, kernel doesn't know where
userpace stack starts, because, in theory, application can move it's
stack to anywhere.

> And the cause is the miss implemented KSTK_ESP in a x86_64. I also
> checked all other architekture depended KSTK_ESP definitions and this
> definitions looks okay for me. 
