Return-Path: <linux-kernel-owner+w=401wt.eu-S1756574AbZGNVag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574AbZGNVag (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 17:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755982AbZGNVaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 17:30:35 -0400
Received: from smtp-out.google.com ([216.239.33.17]:51955 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755981AbZGNVae convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 17:30:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=PMq8dfIg2bzDQpwZyVLdpSDgzWExHVC7dsjH2qmDetxONSwkB9bJQUFHGlQBqAYYO
	Os6q84beVyvfjaWo3KODQ==
MIME-Version: 1.0
In-Reply-To: <6599ad830907141050r1e9dde98l56afd37629f749e8@mail.gmail.com>
References: <20090710230043.16778.29656.stgit@hastromil.mtv.corp.google.com>
	 <2f86c2480907130827u7d2b062bw26bbb80a8e3de657@mail.gmail.com>
	 <20090714084950.2401d9a6.kamezawa.hiroyu@jp.fujitsu.com>
	 <6599ad830907132050n226aecb3ucab6746a4d0e81fa@mail.gmail.com>
	 <20090714125334.b476aa78.kamezawa.hiroyu@jp.fujitsu.com>
	 <6599ad830907132104o55d31ccexb15e5aa35c31416e@mail.gmail.com>
	 <20090714132538.ac0bc44a.kamezawa.hiroyu@jp.fujitsu.com>
	 <6599ad830907141028y50f36d63h8ea06f73ff369591@mail.gmail.com>
	 <1247593652.13426.15938.camel@nimitz>
	 <6599ad830907141050r1e9dde98l56afd37629f749e8@mail.gmail.com>
Date: Tue, 14 Jul 2009 14:30:28 -0700
Message-ID: <2f86c2480907141430u314f8987s857bdaa229d6e482@mail.gmail.com>
Subject: Re: [PATCH 3/3] Quick vmalloc vs kmalloc fix to the case where array 
	size is too large
From: Benjamin Blum <bblum@google.com>
To: Paul Menage <menage@google.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Indeed.

Alternatively, I could make it case on KMALLOC_MAX_SIZE as follows:

if (size > KMALLOC_MAX_SIZE) {
    /* use vmalloc directly */
} else {
    /* try kmalloc, and, expecting fragmentation, if that fails, use vmalloc */
}

As the free wrapper uses is_vmalloc_addr, it'd work fine and be able
to decide for a certain range of sizes whether kmalloc or vmalloc is
appropriate.

On Tue, Jul 14, 2009 at 10:50 AM, Paul Menage<menage@google.com> wrote:
> On Tue, Jul 14, 2009 at 10:47 AM, Dave Hansen<dave@linux.vnet.ibm.com> wrote:
>>
>> How big were those allocations that were failing?  The code made it
>> appear that order-2 (PAGE_SIZE*4) allocations were failing.  That's a
>> bit lower than I'd expect the page allocator to start failing.
>
> I think it depends on how much fragmentation you've got.
>
> We've seen it fail for cpusets with (I guess) hundreds or thousands of threads.
>
> Paul
>
