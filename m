Return-Path: <linux-kernel-owner+w=401wt.eu-S1161464AbXD2Vqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161464AbXD2Vqh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 17:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161473AbXD2Vqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 17:46:37 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48558 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161464AbXD2Vqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 17:46:36 -0400
Date: Sun, 29 Apr 2007 14:45:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Jones <davej@redhat.com>
Cc: bbpetkov@yahoo.de, Andy Whitcroft <apw@shadowen.org>,
       linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: Re: [PATCH] mm/memory.c: remove warning from an uninitialized
 spinlock. was: Re: 2.6.21-rc7-mm2
Message-Id: <20070429144542.be8b8285.akpm@linux-foundation.org>
In-Reply-To: <20070429213601.GB14857@redhat.com>
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
	<20070426182519.GA4532@gollum.tnic>
	<20070427172230.94b82829.akpm@linux-foundation.org>
	<4633DD55.1020006@shadowen.org>
	<20070429065049.GB4446@gollum.tnic>
	<20070429022440.cb8fc8c4.akpm@linux-foundation.org>
	<20070429213601.GB14857@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Apr 2007 17:36:01 -0400 Dave Jones <davej@redhat.com> wrote:

> On Sun, Apr 29, 2007 at 02:24:40AM -0700, Andrew Morton wrote:
>  > On Sun, 29 Apr 2007 08:50:49 +0200 Borislav Petkov <bbpetkov@yahoo.de> wrote:
>  > 
>  > > Introduce a macro for suppressing gcc from generating a warning about a probable
>  > > unitialized state of a variable.
>  > 
>  > I ended up doing the below.
>  > 
>  > It's better to make this a per-compiler-version thing: later versions of
>  > gcc might need different tricks, or might provide __attribute__((stfu)) or
>  > whatever.
> 
> __attribute__((unused))  ?

That'll prevent unused-variable warnings, but there doesn't appear to be
an attribute to prevent might-be-used-uninitialized warnings.
