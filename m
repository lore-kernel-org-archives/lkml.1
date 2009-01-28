Return-Path: <linux-kernel-owner+w=401wt.eu-S1753759AbZA1Lds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759AbZA1Lds (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 06:33:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbZA1Ldj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 06:33:39 -0500
Received: from mu-out-0910.google.com ([209.85.134.187]:47324 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbZA1Ldi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 06:33:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Sj6Dl7zdqUpFE+Pq/BhwmX7H69DbtvMfst+FLKK+Hl0IcWUNFjFsy6H1/8hOG1zQsg
         eKuls4uYfXx0e5vyvWsqqU8nVFwv57VdtUOzeJ84N6st8Ys/HoKyqRA8z6Dq8PldRhvR
         m+VZxQWvPVQQrJgH7VXr0hnfCzvf5811CiQdw=
MIME-Version: 1.0
In-Reply-To: <1233130539.10992.38.camel@laptop>
References: <20090128002714.GA5086@nowhere> <20090128030224.GA4867@redhat.com>
	 <1233130539.10992.38.camel@laptop>
Date: Wed, 28 Jan 2009 12:33:28 +0100
Message-ID: <c62985530901280333h5e67fa34oe1677a96e9af0834@mail.gmail.com>
Subject: Re: [RFC v2][PATCH] create workqueue threads only when needed
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Alasdair G Kergon <agk@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/28 Peter Zijlstra <a.p.zijlstra@chello.nl>:
> On Wed, 2009-01-28 at 04:02 +0100, Oleg Nesterov wrote:
>>
>> I must admit, I don't like this patch. Perhaps I am wrong, mostly I
>> dislike the complications it adds.
>>
>> Anybody else please vote for this change?
>
> Because you asked ;-)
>
> I too am not particularly fond of it, for much the same reasons you
> mentioned.
>
> While I think its good to reduce the number of random kernel threads,
> I'm afraid this isn't a good way to do so.
>
> Why does everybody and his pony create their own workqueue, is that
> really because it deadlocks with keventd, or are there other reasons, if
> so, which, and can we solve those?


Even with the approach of shadow workqueues, these call sites that
create pointless workqueues
are still a problem that should be fixed, since they consume memory
for their workqueue.

The reasons for these callsites are not easy to guess, they are not so
much commented and it's
hard to imagine if this is because of deadlocks with kevents, too long
work which can starve other
kevent work, or just funny workqueues....

Depending on the reason, I guess most of them can become threads
created and destroyed on the fly,
or async functions as Arjan suggested, or simple kevent works.
