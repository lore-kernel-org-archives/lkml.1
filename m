Return-Path: <linux-kernel-owner+w=401wt.eu-S1161058AbYHFQOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161058AbYHFQOF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 12:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755684AbYHFQNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 12:13:45 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:16457 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046AbYHFQNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 12:13:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=RDW2xdjmS3SxJSC8XdZ3/iYxIgvcH80Kt16fqhlnbpWDZ+9ayZ7gLUN4tkYRGC2uGf
         h8YwKJz7rLbO43xpgPCw3DwfDFUd9Vwv7U8vy4DmqbwQbrpZQj9h48xdHJ0ds657eapC
         WYSIYUJEVMNOE8fIuSneuPRtgVTOM4mBaBOPY=
Message-ID: <86802c440808060913p327da9dfr7a96ef6676cd0295@mail.gmail.com>
Date: Wed, 6 Aug 2008 09:13:43 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jeff Chua" <jeff.chua.linux@gmail.com>
Subject: Re: 2.6.27rc1 cannot boot more than 8CPUs
Cc: "David Miller" <davem@davemloft.net>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0808061908100.12476@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0808061908100.12476@boston.corp.fedex.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 6, 2008 at 4:09 AM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
>
> On Wed, Aug 6, 2008 at 5:42 PM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
>>>>
>>>> CONFIG_X86_GENERICARCH=y
>>>> CONFIG_X86_BIGSMP=y
>>>> 8 more cpu need bigsmp mode.
>
>> Just found it under " Subarchitecture Type (Generic architecture)",
>> and then it shows the CONFIG_X86_BIGSMP option.
>
> It works. Booted with 16CPUs. 32GB RAM.
>
> CPU0 L7345 1.86GHz  0C
> CPU1 L7345 1.86GHz  0C
> CPU2 L7345 1.86GHz  0C
> CPU3 L7345 1.86GHz  0C
> CPU4 L7345 1.86GHz  0C
> CPU5 L7345 1.86GHz  0C
> CPU6 L7345 1.86GHz  0C
> CPU7 L7345 1.86GHz  0C
> CPU8 L7345 1.86GHz  0C
> CPU9 L7345 1.86GHz  0C
> CPU10 L7345 1.86GHz  0C
> CPU11 L7345 1.86GHz  0C
> CPU12 L7345 1.86GHz  0C
> CPU13 L7345 1.86GHz  0C
> CPU14 L7345 1.86GHz  0C
> CPU15 L7345 1.86GHz  0C
>
>
> So, but setting the config not obvious. And should CONFIG_X86_PC be
> considered as well as CONFIG_X86_GENERICARCH?
>
> With CONFIG_X86_PC, I can set CONFIG_SPARSEMEM=y.
>
> With CONFIG_X86_GENERICARCH, CONFIG_SPARSEMEM depends on CONFIG_NUMA.
>
> I'm using the patch below to enable sparsemem instead of flatmem, but don't
> know what impact it has. System booted and running.
>
> It would be nice to automatically default CONFIG_X86_BIGSMP with CPUs > 8.
> But I don't know to do that.
>
>

actually x86_pc is one mode of genericarch..., genericarch already
could detect pc, bigsmp, and numaq, es7000, bigsmp, visew..

hope later we can change mach_default to default. but embed guys may
want to keep it as seperated one.

in the dmesg when booting x86_pc only, we already have warning to let
you set bigsmp if you have 8 more cpus.

YH
