Return-Path: <linux-kernel-owner+w=401wt.eu-S1755003AbZFEEh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755003AbZFEEh3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 00:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750813AbZFEEhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 00:37:18 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:41158 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbZFEEhQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 00:37:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=iG6T4lkm/Ay1FF4oqOw55N8MNHk5MN/xzxpx4I/SJA57dgbJpZQgkb+B6TbUjgPpNu
         rzsLllOqikeRuI9UzjkZQjlFRSkiumlJySdaBrvc3JjjLt8+okFE9GUxe7ftljF6RVoC
         YtGswrxECeFuLZ7by37RcFO2qanpvR9ytQfAg=
MIME-Version: 1.0
In-Reply-To: <4A28921C.6010802@redhat.com>
References: <20090604053649.GA3701@in.ibm.com> <4A27BBCA.5020606@redhat.com>
	 <20090605030309.GA3872@in.ibm.com> <4A28921C.6010802@redhat.com>
Date: Fri, 5 Jun 2009 12:37:17 +0800
X-Google-Sender-Auth: bd7673979346291a
Message-ID: <661de9470906042137u603e2997n80c270bf7f6191ad@mail.gmail.com>
Subject: Re: [RFC] CPU hard limits
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: bharata@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>, kvm@vger.kernel.org,
       Linux Containers <containers@lists.linux-foundation.org>,
       Herbert Poetzl <herbert@13thfloor.at>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 5, 2009 at 11:33 AM, Avi Kivity <avi@redhat.com> wrote:
> Bharata B Rao wrote:
>>>
>>> Another way is to place the 8 groups in a container group, and limit
>>>  that to 80%. But that doesn't work if I want to provide guarantees to
>>>  several groups.
>>>
>>
>> Hmm why not ? Reduce the guarantee of the container group and provide
>> the same to additional groups ?
>>
>
> This method produces suboptimal results:
>
> $ cgroup-limits 10 10 0
> [50.0, 50.0, 40.0]
>
> I want to provide two 10% guaranteed groups and one best-effort group.
>  Using the limits method, no group can now use more than 50% of the
> resources.  However, having the first group use 90% of the resources does
> not violate any guarantees, but it not allowed by the solution.
>

How, it works out fine in my calculation

50 + 40 for G2 and G3, make sure that G1 gets 10%, since others are
limited to 90%
50 + 40 for G1 and G3, make sure that G2 gets 10%, since others are
limited to 90%
50 + 50 for G1 and G2, make sure that G3 gets 0%, since others are
limited to 100%

Now if we really have zeros, I would recommend using

cgroup-limits 10 10 and you'll see that you'll get 90, 90 as output.

Adding zeros to the calcuation is not recommended. Does that help?

Balbir
