Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab0BAMz5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 07:55:57 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:44125 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab0BAMzz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 07:55:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZoQHyTANoLLMITiRGb+G+gaARMJPSPDvTv+kUZFnH6KEk3oouZP4RnEQkBq1Vpkd+q
         v6WM86dYJKwB39okQTqILFJGfpTa4MPJMH5fVMTamoQw2Fhya/e2bcvcuq0I02/Hmwa0
         utt/8Rzd1try56T8dfdDbQCYoUQLdM0hIhzf4=
MIME-Version: 1.0
In-Reply-To: <20100129234145.GC5177@ldl.fc.hp.com>
References: <20100129214039.17745.38679.stgit@bob.kio>
	 <adar5p8ldxv.fsf@roland-alpha.cisco.com>
	 <20100129234145.GC5177@ldl.fc.hp.com>
Date: Mon, 1 Feb 2010 07:55:54 -0500
Message-ID: <f0e08f231002010455w432bf496xec6b747faabda838@mail.gmail.com>
Subject: Re: [PATCH 0/7] Increase maximum Infiniband HCAs per-system
From: Hal Rosenstock <hal.rosenstock@gmail.com>
To: Alex Chiang <achiang@hp.com>
Cc: Roland Dreier <rdreier@cisco.com>, linux-rdma@vger.kernel.org,
       justin.chen@hp.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 29, 2010 at 6:41 PM, Alex Chiang <achiang@hp.com> wrote:
> * Roland Dreier <rdreier@cisco.com>:
>>
>> Have you considered drivers/infiniband/core/user_mad.c and ucm.c?
>
> Ah, darn. I had not considered those drivers. You're gonna make
> me learn a lot more about IB than I'd originally intended. ;)
>
>> I think user_mad.c is somewhat more important, as that is what
>> allows an adapter to be used for running the SM.  So I think
>> we're still left with some potential issues around lots of
>> adapters in one system.  (I think use of ucm by real apps is
>> minimal to nonexistent, but someday we should deal with that
>> too)
>
> Ok, a quick glance through those drivers shows:
>
>        enum {
>                IB_UMAD_MAX_PORTS  = 64,
>                IB_UMAD_MAX_AGENTS = 32,
>
>                IB_UMAD_MAJOR      = 231,
>                IB_UMAD_MINOR_BASE = 0
>        };
>
> and
>
>        enum {
>                IB_UCM_MAJOR = 231,
>                IB_UCM_BASE_MINOR = 224,
>                IB_UCM_MAX_DEVICES = 32
>        };
>
> They're all sharing the same major number, so they'll all have to
> get the same treatment as the uverbs driver wrt overflow (to
> prevent minor number overlap).
>
> What I'm a little unsure of is, does IB_UMAD_MAX_AGENTS need to
> double too? We don't export the agent id in the filesystem
> anywhere, but we do give it to the user via an ioctl. That's just
> used for book keeping purposes but...
>
> Currently, there are 2x as many ports as there are agents. Do we
> want to keep that ratio, or would it be ok to have 4x as many
> ports as there are agents?

I think it's 2x as many ports as devices (based on the common HCAs
being 2 ports max). This should be maintained as that is still the
case.

-- Hal

>
> Thanks (and sorry for the n00b questions).
>
> /ac
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
