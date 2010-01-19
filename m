Return-Path: <linux-kernel-owner+w=401wt.eu-S1755369Ab0ASIHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab0ASIHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 03:07:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754968Ab0ASIHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 03:07:13 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:60419 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932153Ab0ASIHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 03:07:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=XoH5a0iG52ctAI4o4QJBLqEdY4QcxBVQAm7Awj2kF9IdgbIhQ8E9km8NgWSHgCy1xj
         6HPMlmfoyw39i20BoL1fvdA5z624gtP8rKEjkymOtyo9nYQvaMPwIxWV6cj8XRQmuBBK
         wipAWGYkm3AVp+lUtxEnd4mRQI7t/36M3rJ/U=
MIME-Version: 1.0
In-Reply-To: <20100119075205.GI14345@redhat.com>
References: <20100118133755.GG30698@redhat.com>
	 <20100118141938.GI30698@redhat.com>
	 <84144f021001180805q4d1203b8qab8ccb1de87b2866@mail.gmail.com>
	 <20100118170816.GA22111@redhat.com>
	 <84144f021001181009m52f7eaebp2bd746f92de08da9@mail.gmail.com>
	 <20100118181942.GD22111@redhat.com>
	 <20100118191031.0088f49a@lxorguk.ukuu.org.uk>
	 <20100119071734.GG14345@redhat.com>
	 <84144f021001182337o274c8ed3q8ce60581094bc2b9@mail.gmail.com>
	 <20100119075205.GI14345@redhat.com>
Date: Tue, 19 Jan 2010 10:07:07 +0200
X-Google-Sender-Auth: 21a8032aac59ea4d
Message-ID: <84144f021001190007q54a334dfwed64189e6cf0b7c4@mail.gmail.com>
Subject: Re: [PATCH v6] add MAP_UNLOCKED mmap flag
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Gleb Natapov <gleb@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-mm@kvack.org,
       kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-api@vger.kernel.org, akpm@linux-foundation.org,
       andrew.c.morrow@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gleb,

On Tue, Jan 19, 2010 at 9:52 AM, Gleb Natapov <gleb@redhat.com> wrote:
>> It would be probably useful if you could point us to the application
>> source code that actually wants this feature.
>>
> This is two line patch to qemu that calls mlockall(MCL_CURRENT|MCL_FUTURE)
> at the beginning of the main() and changes guest memory allocation to
> use MAP_UNLOCKED flag. All alternative solutions in this thread suggest
> that I should rewrite qemu + all library it uses. You see why I can't
> take them seriously?

Well, that's not going to be portable, is it, so the application
design would still be broken, no? Did you try using (or extending)
posix_madvise(MADV_DONTNEED) for the guest address space? It seems to
me that you're trying to use a big hammer (mlock) when a polite hint
for the VM would probably be sufficient for it do its job.

                        Pekka
