Return-Path: <linux-kernel-owner+w=401wt.eu-S1753586AbZLALld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbZLALld (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 06:41:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbZLALlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 06:41:32 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:45865 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbZLALlb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 06:41:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=GRgmCryXf+Cg5q974km2lniq9Eaw4qIMaCxAq6csKiBafGLd1E591UF5BcCXT/aQiE
         6SfZBx/lfz6YkCqcv60/koNkVVThLzxwpwI9kQnU98HX+I3l5Bcivet0MfNP0xcMW9+z
         eMtcuFFP4DbRvaGOk6Z/ls/Qhm1oQJkzLtj0w=
MIME-Version: 1.0
In-Reply-To: <1259665127.2076.363.camel@pasglop>
References: <1259663450-28790-1-git-send-email-leoli@freescale.com>
	 <1259665127.2076.363.camel@pasglop>
Date: Tue, 1 Dec 2009 19:34:01 +0800
X-Google-Sender-Auth: 5150a098bc616733
Message-ID: <2a27d3730912010334q24bf0e06g84839aae131475ec@mail.gmail.com>
Subject: Re: [PATCH] powerpc/mm: setting mmaped page cache property through 
	device tree
From: Li Yang <leoli@freescale.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: paulus@samba.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 1, 2009 at 6:58 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Tue, 2009-12-01 at 18:30 +0800, Li Yang wrote:
>> The patch adds the ability for powerpc architecture to set page cache
>> property of mmaped area through device tree.  This is useful for two
>> cases.  First, for memory shared with other OS'es to have the same cache
>> property to avoid cache paradoxes.  Second, enabling application to map
>> memory which is not managed by kernel as cacheable for better performance.
>
> But that doesn't solve the problem of those same pages being mapped
> cachable as part of the linear mapping does it ?

I think that it doesn't has this problem.  Only regions out of
lmb.memory are configurable through device tree.

>
> Can you tell us more about your precise usage scenario ? What are you

The scenario for the first case is that in a multicore system running
ASMP which means different OS runs on different cores.  They might
communicate through a shared memory region.  The region on every OS
need to be mapped with the same cache perperty to avoid cache paradox.

The scenario for the second case is to pre-allocate some memory to a
certain application or device (probably through mem=XXX kernel
parameter or limit through device tree).  The memory is not known to
kernel, but fully managed by the application/device.  We need being
able to map the region cachable for better performance.

> trying to achieve here ? We can find a solution though it might involve
> a specific driver to handle that memory.

Right, but what the user to kernel API should be used?  Is it ok to
use the O_SYNC flag as I previously proposed?

- Leo
