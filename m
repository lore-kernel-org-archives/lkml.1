Return-Path: <linux-kernel-owner+w=401wt.eu-S1754346AbZCJKZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbZCJKZ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 06:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754032AbZCJKZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 06:25:12 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:61961 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013AbZCJKZL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 06:25:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FlrCEKTRnYJCMZD0zb9SpFYlj9D5S1wTUi7gmRfTM1+bm+EPLTphc51o50QDFmbIY6
         adG9xvBJbBCgvkXdFKiBOucYS9gyO6LkZahaTEKAKe4C/Sh/YrYNLSlmv3CF5G6RYzHg
         MhCzUAaimyqHc0QxF4DCSbs6IWMKTrMnqP/JY=
MIME-Version: 1.0
In-Reply-To: <1236679631.5183.72.camel@dy>
References: <1236321780-28718-1-git-send-email-cooloney@kernel.org>
	 <1236321780-28718-3-git-send-email-cooloney@kernel.org>
	 <20090306143756.738db0ee.akpm@linux-foundation.org>
	 <1236679631.5183.72.camel@dy>
Date: Tue, 10 Mar 2009 06:25:08 -0400
Message-ID: <8bd0f97a0903100325k6cbcf73ek8e5f3723b2c4bb0a@mail.gmail.com>
Subject: Re: [PATCH 02/18] Blackfin Serial Driver: use barrier instead of 
	cpu_relax for Blackfin SMP like patch
From: Mike Frysinger <vapier.adi@gmail.com>
To: gyang <graf.yang@analog.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Bryan Wu <cooloney@kernel.org>,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 10, 2009 at 06:07, gyang wrote:
> On Fri, 2009-03-06 at 14:37 -0800, Andrew Morton wrote:
>> On Fri,  6 Mar 2009 14:42:44 +0800
>> Bryan Wu <cooloney@kernel.org> wrote:
>>
>> > From: Graf Yang <graf.yang@analog.com>
>> >
>> > We are making a SMP like patch to blackfin, cpu_relax() is replaced by a
>> > data cache flush function which will count it to a per-cpu counter.
>> > If this serial function is called too early, the per-cpu data area have
>> > not been initialized, this call will cause crash.
>>
>> That's a bug in blackfin architecture support.  The kernel should be
>> able to call cpu_relax() at any time, surely.  It's a very low-level
>> and simple thing.
>>
>> > So we'd like to use barrier() instead of cpu_relax().
>> >
>>
>> barrier() is purely a compiler concept.  We might as well just remove
>> the cpu_relax() altogether.
>
> Do you mean remove cpu_relax(), and either not add barrier() here?

afaik, early printk all runs before SMP is setup, so having it be a
100% busy wait is fine
-mike
