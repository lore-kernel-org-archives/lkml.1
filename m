Return-Path: <linux-kernel-owner+w=401wt.eu-S1757060AbZBFWwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060AbZBFWwt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 17:52:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbZBFWwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 17:52:38 -0500
Received: from wf-out-1314.google.com ([209.85.200.174]:17982 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbZBFWwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 17:52:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=sV8IAy3VgEIXUjYaQRhT5W45idss7np/WJai1TCnzwkicRrbIf+T3KuMNwoWx4bJxg
         g3+UwZLqunZ7a3co6MoeAk0RuCErPUcHDQMUjhCX0a69S+IWgu9JYj1FzE3ndr8Ri2tp
         WEHnB7pJtuXbxTA6nJ/puQU83Qho/uoV/LR8Y=
MIME-Version: 1.0
In-Reply-To: <20090206.140912.40800913.davem@davemloft.net>
References: <1233936169-5243-1-git-send-email-anemo@mba.ocn.ne.jp>
	 <e9c3a7c20902061315n7184c55ck7fcaa2c519a035d4@mail.gmail.com>
	 <20090206.140912.40800913.davem@davemloft.net>
Date: Fri, 6 Feb 2009 15:52:35 -0700
X-Google-Sender-Auth: 0bbcf475b0f06eaa
Message-ID: <e9c3a7c20902061452r40a97fa2p1fccfa78e3905458@mail.gmail.com>
Subject: Re: [PATCH] net_dma: call dmaengine_get only if NET_DMA enabled
From: Dan Williams <dan.j.williams@intel.com>
To: David Miller <davem@davemloft.net>
Cc: anemo@mba.ocn.ne.jp, maciej.sosnowski@intel.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 6, 2009 at 3:09 PM, David Miller <davem@davemloft.net> wrote:
> From: Dan Williams <dan.j.williams@intel.com>
> Date: Fri, 6 Feb 2009 14:15:02 -0700
>
>> [ please cc netdev on net_dma patches ]
>>
>> On Fri, Feb 6, 2009 at 9:02 AM, Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
>> > The commit 649274d993212e7c23c0cb734572c2311c200872 ("net_dma:
>> > acquire/release dma channels on ifup/ifdown") added unconditional call
>> > of dmaengine_get() to net_dma.  The API should be called only if
>> > NET_DMA was enabled.
>> >
>> > Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
>>
>> Acked-by: Dan Williams <dan.j.williams@intel.com>
>>
>> I was looking to avoid ifdefs in this path by making
>> dmaengine_{get,put} a nop in the DMAENGINE=n case.  However, the
>> current code with DMAENGINE=y NET_DMA=n will pin channels even though
>> the network stack is not using them.
>
> I don't want to apply this patch at all.
>
> What is the purpose of keeping the ugly ifdefs in dmaengine.h if we're
> just going to pollute the networking code with the ifdefs anyways?
>
> Make the NOP versions in linux/dmaengine.h actually work.
>
> The NET_DMA stuff is the one thing which is polluting up the networking
> stack with ugly ifdefs, I'm not adding new ones.

Yes, it has been on the todo list for a while, but I eventually want
the net case to look more like the raid case.  I.e. have one code path
that picks async versus sync at runtime, with the option to compile
out async support with header file ifdefs only.
