Return-Path: <linux-kernel-owner+w=401wt.eu-S1761625AbYCXQf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761625AbYCXQf7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 12:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754516AbYCXQfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 12:35:48 -0400
Received: from wr-out-0506.google.com ([64.233.184.232]:14371 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416AbYCXQfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 12:35:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WZfXg5hDwCwTgzLpOt1Cr8NApHA8DuwOUw9+WeOs8LwroJtt68sAO6CerHNQb4kYLhOERq63yheiM1VdQzng2KLT8iZHSeTubJ0vbGLyGL6q0tsbxsCPcn3uRIUqrD9MtQyYapGVwvWbhPWoTnhXY5zq6axlEE7u9Xf1XdiDeC0=
Subject: Re: [RFC PATCH] kernel: add byteorder macros with alignment fixups
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-netdev <netdev@vger.kernel.org>
In-Reply-To: <20080323135939.GC4580@ucw.cz>
References: <1206034454.17059.4.camel@brick>
	 <20080320182911.GQ10722@ZenIV.linux.org.uk>
	 <1206038244.17059.7.camel@brick>
	 <20080320190953.GR10722@ZenIV.linux.org.uk>
	 <1206040953.17059.13.camel@brick>  <20080323135939.GC4580@ucw.cz>
Content-Type: text/plain
Date: Mon, 24 Mar 2008 09:35:43 -0700
Message-Id: <1206376543.9265.5.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-03-23 at 14:59 +0100, Pavel Machek wrote:
> On Thu 2008-03-20 12:22:33, Harvey Harrison wrote:
> > +#ifdef __KERNEL__
> > +
> > +static inline u64 le64_to_cpu_unaligned(void *p)
> > +{
> > +	return __le64_to_cpu(get_unaligned((__le64 *)p));
> > +}
> 
> Why the cast? Should le64_to_cpu() take __le64 * parameter, so that normal
> typechecking still works?
> 							Pavel

Well, most places that would use this have a char *, or a u8 * so I was
avoiding a cast in most callers.

HPA made a good suggestion about this being in asm-generic allowing
arches to optimize this, so I'm reworking with that approach.

Harvey

