Return-Path: <linux-kernel-owner+w=401wt.eu-S1751918AbYJ0G5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918AbYJ0G5z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 02:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbYJ0G5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 02:57:46 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:53720 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbYJ0G5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 02:57:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=T0jLWkVDFPPxhE92D/JwUfnLpGvbGkZQyi8XvkqyGZta/kCaw2Jl5cpzzKQohSIILb
         rzn1Fz0jL/W90DFnZbQtXRP6iZRB0tF0+hqERvRHP0MN57Oei9RTjWVadaWlGLd3UWmW
         /2VQ1eS1ebB39MaqXU3oJwpyCoFkwCn2aVzP0=
Message-ID: <661de9470810262357y6c560facl87dcaea3ce35e3ac@mail.gmail.com>
Date: Mon, 27 Oct 2008 12:27:44 +0530
From: "Balbir Singh" <balbir@linux.vnet.ibm.com>
To: bharata@linux.vnet.ibm.com
Subject: Re: [PATCH] Add hierarchical accounting to cpu accounting controller
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Paul Menage" <menage@google.com>, linux-kernel@vger.kernel.org,
       "Srivatsa Vaddagiri" <vatsa@linux.vnet.ibm.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <20081027044319.GA4386@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081023054335.GC3280@in.ibm.com>
	 <6599ad830810230849x71961a0asd7f00d3baa2f2271@mail.gmail.com>
	 <20081024050830.GA4387@in.ibm.com>
	 <6599ad830810241037h575ec17bgb43f750d99bd1518@mail.gmail.com>
	 <20081025060157.GA4614@in.ibm.com>
	 <6599ad830810250838q3f96644bm6dfee8ba9f35dfa3@mail.gmail.com>
	 <20081027101703.e954071d.kamezawa.hiroyu@jp.fujitsu.com>
	 <20081027044319.GA4386@in.ibm.com>
X-Google-Sender-Auth: 207d58808ba1b5c7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2008 at 10:13 AM, Bharata B Rao
<bharata@linux.vnet.ibm.com> wrote:
> On Mon, Oct 27, 2008 at 10:17:03AM +0900, KAMEZAWA Hiroyuki wrote:
>> On Sat, 25 Oct 2008 08:38:52 -0700
>> "Paul Menage" <menage@google.com> wrote:
>>
>> > On Fri, Oct 24, 2008 at 11:01 PM, Bharata B Rao
>> > <bharata@linux.vnet.ibm.com> wrote:
>> > >
>> > > Reported-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
>> > > Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
>> >
>> > Reviewed-by: Paul Menage <menage@google.com>
>
> Thanks Paul.
>
>> >
>> > So in technical terms this patch looks fine now. There's still the
>> > question of whether it's OK to change the existing API, since it's
>> > been in the kernel in its currently (non-hierarchical) form for
>> > several releases now.
>
> Hmm... Can we consider this as an API change ? Currently cpuacct.usage
> readers of a parent accounting group are missing the usage contributions
> from its children groups. I would consider this patch as fixing the
> above problem by correctly reflecting the cpu usage for every accounting
> group.
>

If a particular application desires to derive the usage of its
immediate tasks and does not care about subcgroups, it is a simple
iteration (after this fix)

cpuacct - sigma(cpuacct_child)

and currently if we cared about child accounting, we could do

cpuacct + recursively(sigma(cpuacct_child))

In that sense this fix makes more sense, but like Paul said we need to
figure out if it is an API change. My take is that it is a BUG fix,
since we do care about child subgroups in accounting.


>> >
>> Hmm..how about having 2 params as "aggregated usage" and "private usage" ?
>>
>>  cpuacct.usage.
>>  cpuacct.all_subtree_usage.
>
> Is there really a need to differentiate between aggregated and private
> usage other than to maintain the current behaviour ?
>

That might be useful to have, but as above it can always be derived.

Balbir
