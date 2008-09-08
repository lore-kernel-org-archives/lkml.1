Return-Path: <linux-kernel-owner+w=401wt.eu-S1755095AbYIHWGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095AbYIHWGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 18:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbYIHWGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 18:06:09 -0400
Received: from smtp-out.google.com ([216.239.33.17]:21481 "EHLO
	smtp-out3.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752066AbYIHWGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 18:06:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=SEBQ/HNiBcC5jLxOP22r8IR9IwnITwKeWUy5SlL3gM3QfEu+EIXBFZuaHw1OfeLis
	WJbSBUQEaat3N9Ibx71Pg==
Message-ID: <6599ad830809081505p7012a869w92a12b3b5b011179@mail.gmail.com>
Date: Mon, 8 Sep 2008 15:05:53 -0700
From: "Paul Menage" <menage@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] cgroup(fix critical bug): new handling for tasks file
Cc: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
In-Reply-To: <20080908141635.3ce77adc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48B360CE.2010501@cn.fujitsu.com>
	 <6599ad830808251929p10dfc9d2ub11e4db0cd4f9f3@mail.gmail.com>
	 <48B39319.7070403@cn.fujitsu.com>
	 <6599ad830808261544w308a850m865ac0c0a1552c77@mail.gmail.com>
	 <48B4D81D.2040200@cn.fujitsu.com>
	 <6599ad830808270536i353e1807kaac4e9fb74301bb0@mail.gmail.com>
	 <48B69582.4000208@cn.fujitsu.com> <48C0C4F7.2080702@google.com>
	 <20080908141635.3ce77adc.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 8, 2008 at 2:16 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 04 Sep 2008 22:34:47 -0700
> Paul Menage <menage@google.com> wrote:
>
>>       npids = cgroup_task_count(cgrp);
>> +     pidarray = kmalloc(npids * sizeof(pid_t), GFP_KERNEL);
>
> kmalloc becomes more unreliable above 32 kbytes and 100% unreliable
> above MAX_ORDER.

Agreed, but that's something to be fixed in a different patch - the
existing cgroups code (and cpusets originally) has had this kind of
kmalloc call in it.

I think it should be reasonably straightforward to replace it with an
array of page allocations.

Paul
