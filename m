Return-Path: <linux-kernel-owner+w=401wt.eu-S1753140AbZGXPHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140AbZGXPHL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 11:07:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbZGXPHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 11:07:10 -0400
Received: from smtp-out.google.com ([216.239.45.13]:8629 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbZGXPHJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 11:07:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=RxQL2FNpcruqCRfHLc4ZeDymyq2X8MiMAWFL9hhoUGLRKROZdv9f8RyzPI2IFkb1P
	nRyn3AXPhZ6AD7ID1nTbA==
MIME-Version: 1.0
In-Reply-To: <20090724120811.a581eea5.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090723152647.D9391722@kernel> <4A692444.2030303@cn.fujitsu.com>
	 <20090724120811.a581eea5.kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 24 Jul 2009 08:07:04 -0700
Message-ID: <6599ad830907240807k1c2cbf8cx97abdebddd42bfd3@mail.gmail.com>
Subject: Re: [RFC][PATCH] flexible array implementation v4
From: Paul Menage <menage@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
       akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, vda.linux@googlemail.com,
       mikew@google.com, xiyou.wangcong@gmail.com, hpa@zytor.com,
       bblum@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 23, 2009 at 8:08 PM, KAMEZAWA
Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Fri, 24 Jul 2009 11:02:28 +0800
> Li Zefan <lizf@cn.fujitsu.com> wrote:
>
>> Dave Hansen wrote:
>> > Remaining issues:
>> > - How should we deal with out-of-range indexes, especially
>> >   in flex_array_get() which returns void*?  ERR_PTR()?
>> >   BUG_ON()?  return NULL (current behavior)?
>> > - Should care be taken not to allow a flex_array_get() to
>> >   an index where no flex_array_put() was done?
>> > - Should we decay further than just packing things into the
>> >   'base' page?  Should we actually kmalloc() less than a
>> >   page at times when it will fit?
>> >
>>
>> I sugguest find some candidate users and see how this flex_array
>> fits them.
>>
> Hmm, can't we rewrite cgroup->tasks file using this ?
> I'll try some if I have time.

We could, but I've been leaning more towards Eric's suggestion of
avoiding allocating the array entirely - see

http://lkml.org/lkml/2009/7/15/226
http://lkml.org/lkml/2009/7/21/393

Paul
