Return-Path: <linux-kernel-owner+w=401wt.eu-S1754970Ab0ARMS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970Ab0ARMS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 07:18:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754936Ab0ARMSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 07:18:24 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:27793 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592Ab0ARMSX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 07:18:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sqs5InzI6xhErDCyWZpoUr+mJ/dBUw7lvFJ/w1NM64OuT0n+E0NDamkt5CRNTR6Z4W
         hgUeCpd3YJYQM6qm2/K8n2KzP0t5rXw62QxPpDNGppjNpw0L/jiCapl37hiScbP5bTnO
         hOM+y4VdOQnuzqfBGSDzqQbFleRZZEhQNomvw=
MIME-Version: 1.0
In-Reply-To: <20100117094043.0483ee1a@infradead.org>
References: <af0693f01001170847r49083075hc538a42b6bcd65ab@mail.gmail.com>
	 <20100117094043.0483ee1a@infradead.org>
Date: Mon, 18 Jan 2010 14:18:22 +0200
Message-ID: <af0693f01001180418h6344e4b2v64f82e54ab3d9241@mail.gmail.com>
Subject: Re: /dev/mem implementation
From: Felix Rubinstein <felixru@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usecase is broadcom 10GbE switch driver which maps DMA memory to userspace.
I can find one more libe1000 which uses char driver to map DMA memory
to userspace too.
So, how can I implement userspace drivers in recent kernels which want
to map DMA memory to userspace if STRICT_DEVMEM or PAT (either of
them) are enabled.

The motivation to implement network drivers is not new and there are
here and there mini projects to bypass Linux networks stack to gain
better latency as stack has lots of locks around, buffer copying
(userspace to kernel and vice versa), etc... which only add latency.

Thanks,
Felix R.

On Sun, Jan 17, 2010 at 7:40 PM, Arjan van de Ven <arjan@infradead.org> wrote:
> On Sun, 17 Jan 2010 18:47:10 +0200
> Felix Rubinstein <felixru@gmail.com> wrote:
>
>> I see the motivation to limit the access to DRAM from root account
>> CONFIG_STRICT_DEVMEM by mmap'ing /dev/[k]mem but it's easily overruled
>> by simple char driver and implementing mmap of it's own totally
>> bypassing all limitations.
>>
>> What do you think about it guy?
>> Appreciate it.
>
> the reason PAT bans parts of /dev/mem is simple: it is illegal to have
> mapping aliases (different cachability) for the same physical page.
> Normal kernel APIs take care of this for the normal case, but /dev/mem
> would be a back door into that.
> This is a hardware imposed requirement, and violating the rule can have
> really nasty consequences... hence the PAT code just not allowing it.
>
> If you feel that you have a valid use case where you really want do
> muck with such memory, it might be a good idea to explain that
> usecase....
>
> --
> Arjan van de Ven        Intel Open Source Technology Centre
> For development, discussion and tips for power savings,
> visit http://www.lesswatts.org
>
