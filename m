Return-Path: <linux-kernel-owner+w=401wt.eu-S1752687Ab0AROJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab0AROJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 09:09:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752336Ab0AROJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 09:09:38 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:65527 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab0AROJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 09:09:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=fOw0aURRkjjnv/WfOa+LCPvFNN12QGVw7ypmRylCToypENLjXFW/8vNduPcnwfiEUS
         N9vwbn4gr0H1fuJv+mj4r7c1I6WPRnzLhRtsICCMdBgdaB/OWgLyr4jSHZnbV/p7/3vv
         Hm9uTWSQHWyuYGkRihYdrx612dC0oeEHr9h34=
MIME-Version: 1.0
In-Reply-To: <20100118133755.GG30698@redhat.com>
References: <20100118133755.GG30698@redhat.com>
Date: Mon, 18 Jan 2010 16:09:35 +0200
X-Google-Sender-Auth: 26d50aaee4cba18b
Message-ID: <84144f021001180609r4d7fbbd0p972d5bc0e227d09a@mail.gmail.com>
Subject: Re: [PATCH v6] add MAP_UNLOCKED mmap flag
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Gleb Natapov <gleb@redhat.com>
Cc: linux-mm@kvack.org, kosaki.motohiro@jp.fujitsu.com,
       linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
       akpm@linux-foundation.org, andrew.c.morrow@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gleb,

On Mon, Jan 18, 2010 at 3:37 PM, Gleb Natapov <gleb@redhat.com> wrote:
> The current interaction between mlockall(MCL_FUTURE) and mmap has a
> deficiency. In 'normal' mode, without MCL_FUTURE in force, the default
> is that new memory mappings are not locked, but mmap provides MAP_LOCKED
> specifically to override that default. However, with MCL_FUTURE toggled
> to on, there is no analogous way to tell mmap to override the default. The
> proposed MAP_UNLOCKED flag would resolve this deficiency.
>
> The benefit of the patch is that it makes it possible for an application
> which has previously called mlockall(MCL_FUTURE) to selectively exempt
> new memory mappings from memory locking, on a per-mmap-call basis. There
> is currently no thread-safe way for an application to do this as
> toggling MCL_FUTURE around calls to mmap is racy in a multi-threaded
> context. Other threads may manipulate the address space during the
> window where MCL_FUTURE is off, subverting the programmers intended
> memory locking semantics.
>
> The ability to exempt specific memory mappings from memory locking is
> necessary when the region to be mapped is larger than physical memory.
> In such cases a call to mmap the region cannot succeed, unless
> MAP_UNLOCKED is available.

The changelog doesn't mention what kind of applications would want to
use this. Are there some? Using mlockall(MCL_FUTURE) but then having
some memory regions MAP_UNLOCKED sounds like a strange combination to
me.
