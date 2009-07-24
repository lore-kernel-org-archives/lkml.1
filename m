Return-Path: <linux-kernel-owner+w=401wt.eu-S1754702AbZGXVgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbZGXVgX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 17:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753846AbZGXVgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 17:36:23 -0400
Received: from smtp-out.google.com ([216.239.45.13]:56542 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbZGXVgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 17:36:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=Odg8Y68S2FCow1y8k9S0REAXWUffA51EtC2sk8UH9Y6FA+5DTelHAW2XMDkXuEbSU
	ULntowuS+GGT5cLMNJPow==
MIME-Version: 1.0
In-Reply-To: <20090724210657.GL5878@count0.beaverton.ibm.com>
References: <20090724032033.2463.79256.stgit@hastromil.mtv.corp.google.com>
	 <20090724032200.2463.82408.stgit@hastromil.mtv.corp.google.com>
	 <20090724155041.GF5878@count0.beaverton.ibm.com>
	 <6599ad830907240901w4fc02097k83d0c1012708e6ee@mail.gmail.com>
	 <20090724172320.GH5878@count0.beaverton.ibm.com>
	 <6599ad830907241047w9a9fff9q4dc68f26a9544398@mail.gmail.com>
	 <2f86c2480907241353l63818dfehb20c9d4918a3f069@mail.gmail.com>
	 <20090724210657.GL5878@count0.beaverton.ibm.com>
Date: Fri, 24 Jul 2009 14:36:18 -0700
Message-ID: <6599ad830907241436n7c004e01j349a473554236f65@mail.gmail.com>
Subject: Re: [PATCH 5/6] Makes procs file writable to move all threads by tgid 
	at once
From: Paul Menage <menage@google.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Benjamin Blum <bblum@google.com>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, akpm@linux-foundation.org,
       serue@us.ibm.com, lizf@cn.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 24, 2009 at 2:06 PM, Matt Helsley<matthltc@us.ibm.com> wrote:
>>
>> Global rwsem: only needs one lock, but prevents all forking when a
>> write is in progress. It should be quick enough, if it's just "iterate
>> down the threadgroup list in O(n)". In the good case, fork() slows
>> down by a cache miss when taking the lock in read mode.
>
> I noticed your point about only one process contending for write on
> the new semaphore since cgroup_mutex is also held on the write side.
> However won't there be cacheline bouncing as lots of readers contend not
> for the read side of the lock itself but the cacheline needed to take it?

Yes, that's the "cache miss when taking the lock in read mode"
referred to by Ben in the paragraph above yours.

Paul
