Return-Path: <linux-kernel-owner+w=401wt.eu-S1762764AbYBFXB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762764AbYBFXB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:01:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762170AbYBFXBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:01:46 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761668AbYBFXBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:01:45 -0500
Message-ID: <47AA3C4C.6080004@redhat.com>
Date: Wed, 06 Feb 2008 17:01:32 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] reduce large do_mount stack usage with noinlines
References: <47AA3126.8090102@redhat.com>	<20080206143457.03e8741d.akpm@linux-foundation.org> <20080206145439.4ef971f2@laptopd505.fenrus.org>
In-Reply-To: <20080206145439.4ef971f2@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Wed, 6 Feb 2008 14:34:57 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
>> Does the patch actually help?  I mean, if a() calls b() and both use N
>> bytes of locals, our worst-case stack usage remains ~2N whether or
>> not b() was inlined in a()?  In fact, uninlining makes things a
>> little worse due to callframe stuff.
> 
> it gets interesting at the three-way..
> if a() calls b() and then calls c(), and they all use N,
> the total usage is now 3N not 2N.

*nod*

It'd be nice if it could be max of (a,b,c) though.  Or maybe compilers
don't work that way.  :)

> (although current gcc is already somewhat smarter about this, and 3N might actually be 2N for some cases)

on x86, gcc 4.1.2, do_mount goes from 360 to 112 bytes w/ the patch I sent.

with gcc 4.3, it goes from 364 to 104.

-ERic
