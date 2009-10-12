Return-Path: <linux-kernel-owner+w=401wt.eu-S1755972AbZJLKUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbZJLKUM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 06:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755427AbZJLKUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 06:20:11 -0400
Received: from mail-yx0-f188.google.com ([209.85.210.188]:50145 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675AbZJLKUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 06:20:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Herw6f9jyCHPlF6w2c/6QTGh3wKfYpZwZH7DUc9cl5wKU6/79LvbznuEXDw7effr7b
         nx8BUdUA4iUmX228Xv0l1BDj234A5cX6BgCExDdIci4cdzL+EF2LAOoZbJ61xl3FRDTn
         Wl5tH18nEyrSH9GzqhLzCQNv1QpDIOSWpxr2A=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0910121209140.3658@localhost.localdomain>
References: <alpine.LFD.2.00.0910112216060.12574@localhost.localdomain>
	 <21d7e9970910120203k3b411796pf00e3453c4d2297b@mail.gmail.com>
	 <alpine.LFD.2.00.0910121209140.3658@localhost.localdomain>
Date: Mon, 12 Oct 2009 20:19:33 +1000
Message-ID: <21d7e9970910120319v34af6fe5y7ccc42c6db67276@mail.gmail.com>
Subject: Re: [PATCH RFC] frontend.c: Remove the BKL from agp_open
From: Dave Airlie <airlied@gmail.com>
To: John Kacur <jkacur@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       David Airlie <airlied@linux.ie>, Jonathan Corbet <corbet@lwn.net>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Vincent Sanders <vince@simtec.co.uk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> On Mon, Oct 12, 2009 at 6:24 AM, John Kacur <jkacur@redhat.com> wrote:
>> >
>> > @David Airlie. I was looking at the agp driver for removal of the bkl
>> > lock. From what I could tell, the mutex_lock(&(agp_fe.agp_mutex)) should
>> > cover what we need. However, I may have easily missed something, and would
>> > appreciate your review / comments on the patch.
>>
>> This seems fine, though I suck at locking logic,
>>
>> One thing to note is the number of users of this interface is probably
>> close to 0,
>> so even if this does break something we probably won't ever find out.
>>
>> Dave.
>>
>
> Hmnn, you are listed as the maintainer - don't at least YOU use this
> driver? Also, if it seem fine to you, can I have an ack?

The AGP frontend isn't a driver, its just an interface to the AGP driver,
for very old X servers pre-drm support, most X servers don't use this
interface at all anymore, the graphics driver deals with it.

But it looks fine to me, so

Acked-by: Dave Airlie <airlied@redhat.com>

>
> Thanks
>
