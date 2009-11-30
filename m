Return-Path: <linux-kernel-owner+w=401wt.eu-S1753707AbZK3J0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707AbZK3J0K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 04:26:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753567AbZK3J0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 04:26:09 -0500
Received: from mail-qy0-f194.google.com ([209.85.221.194]:59979 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbZK3J0H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 04:26:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YRDMKpVwcieQdNp3r26wtP5AxEfPCipCf0+M6mCAMeA/vKN82mkPe67i2Db5NgX1mS
         bKyZWCFAEPa5suguB+p4fGPTMTd6sBZgMgIhIPSNGoSIN+j/UqdMxvZlyan4QOKKwwVC
         0z8EW7MwwNrf2pVKbCtowZSlw2uMKCir9cc1M=
MIME-Version: 1.0
In-Reply-To: <m1r5rga54f.fsf@fess.ebiederm.org>
References: <20091130164415.f418834b.sfr@canb.auug.org.au>
	 <2375c9f90911292151t2deb8530idd96ce50ced74d80@mail.gmail.com>
	 <m1r5rga54f.fsf@fess.ebiederm.org>
Date: Mon, 30 Nov 2009 17:26:12 +0800
Message-ID: <2375c9f90911300126t43bbe7cbh6d993a8af0e11b02@mail.gmail.com>
Subject: Re: linux-next: manual merge of the sysctl tree with the net tree
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Vlad Yasevich <vladislav.yasevich@hp.com>,
       "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 2:39 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Américo Wang <xiyou.wangcong@gmail.com> writes:
>
>> On Mon, Nov 30, 2009 at 1:44 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>> Hi Eric,
>>>
>>> Today's linux-next merge of the sysctl tree got a conflict in
>>> net/sctp/sysctl.c between commit 90f2f5318b3a5b0898fef0fec9b91376c7de7a2c
>>> ("sctp: Update SWS avaoidance receiver side algorithm") from the net tree
>>> and commit f8572d8f2a2ba75408b97dc24ef47c83671795d7 ("sysctl net: Remove
>>> unused binary sysctl code") from the sysctl tree.
>>>
>>> I fixed it up (see below) and can carry the fix as necessary.  I also
>>> removed the strategy member from the new added ctl_table entry.
>>> --
>>> Cheers,
>>> Stephen Rothwell                    sfr@canb.auug.org.au
>>>
>>> diff --cc net/sctp/sysctl.c
>>> index ae03ded,d50a042..0000000
>>> --- a/net/sctp/sysctl.c
>>> +++ b/net/sctp/sysctl.c
>>> @@@ -285,19 -241,7 +242,17 @@@ static ctl_table sctp_table[] =
>>>                .extra1         = &zero,
>>>                .extra2         = &addr_scope_max,
>>>        },
>>>  +      {
>>> -               .ctl_name       = CTL_UNNUMBERED,
>>>  +              .procname       = "rwnd_update_shift",
>>>  +              .data           = &sctp_rwnd_upd_shift,
>>>  +              .maxlen         = sizeof(int),
>>>  +              .mode           = 0644,
>>> -               .proc_handler   = &proc_dointvec_minmax,
>>> -               .strategy       = &sysctl_intvec,
>>> ++              .proc_handler   = proc_dointvec_minmax,
>>
>> Hey, what's this??
>
> The short version is I am running a git tree that holds all of
> the necessary cleanups to remove the support for binary sysctl handlers.
>
> The binary sysctl support continues to be provided in kernel/sysctl_binary.c
> with a compatibility wrapper.  This has been reviewed on linux-kernel
> and written up in lwn.

Yeah, I saw your patches, but didn't have a chance to look at them closely.

>
> In my tree .ctl_name and .strategy have been removed as they exist
> only to support binary sysctls and are not strictly needed today.
> .ctl_name = CTL_UNNUMBERED is equivalent to .ctl_name = 0, and setting
> .strategy on new sysctl table entries without a ctl_name is a harmless
> bug.  Since I was in there I also removed all of the unnecessary ampersands
> from in front of proc_dointvec_minmax.
>
> Since I have touched practically every sysctl table entry in the kernel
> new sysctl additions will almost inevitably cause a small by trivially
> to resolve conflict (due to the fact I have almost certainly changed
> the proceeding and succeeding sysctl table entries).
>
> Currently this only the second sysctl added this kernel cycle, and it
> looks like this work happened in parallel, with my changes, and somehow
> David missed this commit in his September pull, so the changes just
> showed up in net-next.
>
> It would seem to require talent to mess up the merge conflicts, and
> getting it wrong will result in a tree that won't compile so I am not
> going to worry about it until Linux pulls one of our trees.

Thanks for this explanation, I see...
