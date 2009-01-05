Return-Path: <linux-kernel-owner+w=401wt.eu-S1753919AbZAEKzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919AbZAEKzU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 05:55:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751745AbZAEKzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 05:55:06 -0500
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:44555 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751625AbZAEKzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 05:55:05 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Gkai9IC132gDr8JdkzlZ+xuzEECNsnjVOjeeYw01kWCT+YgqmRjQxF20QgQsNu09vbt1km7g5SIjH5m6DIlMcQzNP3j7v5UDX7r4ZlaQeTaT3c7SSvlHBwW599K+3RBAU2n9rrU+OvX4BS+70xBH9OfaHcJbrXA9VKmPCFq1egM=  ;
X-YMail-OSG: 5sFU5ykVM1nhxtEl.PvXN2TfX2KXKyirNK7GekgYRhx27zfZA25tE16qb1oM_x1rFhO.SY6e2S8WKwMAvKfdG1rmFE2VQX0iHvo16p9cyGAMYGwUq3m2mX5uydecLUByL1j2IrGT5zONktVBMUS9kHkQdtySEz5bMxQtbvRyedTc3B0mxGmx18qBMCS7hA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: atomics: document that linux expects certain atomic behaviour from unsigned long
Date: Mon, 5 Jan 2009 21:54:45 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Pavel Machek <pavel@suse.cz>, kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
References: <20090103124400.GA1572@ucw.cz> <20090103205628.GE1666@elf.ucw.cz> <20090103231419.197727ba@lxorguk.ukuu.org.uk>
In-Reply-To: <20090103231419.197727ba@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901052154.45958.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 January 2009 10:14:19 Alan Cox wrote:
> > Is there concrete architecture where it breaks? I'd expect i386/x86-64
> > to be safe, and pretty much everyone to be safe as long as that long
> > is aligned.... or that was the result of arch-maintainers
> > discussion...
>
> It'll break on x86 if gcc decides to cache the value and you don't have
> explicit barriers.

Same as atomic_read on x86.

> If the long is not aligned it's not safe on x86 at all.

Same as atomic_t.

AFAIK, Linux requires aligned loads and stores to int and long (and pointer)
to be atomic.

Pretty much everywhere that uses RCU for example does so using atomic pointer
loads and stores. The nastiest issue IMO actually is reloading the value
through the pointer even if it isn't explicitly dereferenced. RCU gets this
right with ACCESS_ONCE. Probably a lot of code using basic types does not.
x86 atomic_read maybe should be using ACCESS_ONCE too...

