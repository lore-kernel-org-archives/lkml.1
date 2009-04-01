Return-Path: <linux-kernel-owner+w=401wt.eu-S1757860AbZDAF4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860AbZDAF4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 01:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbZDAF4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 01:56:31 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:40195 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbZDAF4a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 01:56:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=u+A1DO09r3qZQbFFofeYOX9PKCkETTW5p9qIeePTyJfcNTFlVxmAWdHEG502eZkVle
         7NZCbsePmDzDVt6/OAWuqbLjqwNnqTx3CLCURtatXxLFcelhOe9wUfvh1R96iFl3P1v5
         ooi2ZY3apyPI8McuOLi62LkP/FCLA+gh/PUZ8=
MIME-Version: 1.0
In-Reply-To: <20090331.223128.143365884.davem@davemloft.net>
References: <20090331.223128.143365884.davem@davemloft.net>
Date: Tue, 31 Mar 2009 22:56:28 -0700
X-Google-Sender-Auth: 2116798c0367d393
Message-ID: <86802c440903312256r6ddbaa22o5c23cf85d83a6662@mail.gmail.com>
Subject: Re: Inverted NUMA test in setup_pcpu_remap()?
From: Yinghai Lu <yinghai@kernel.org>
To: David Miller <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: tj@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 31, 2009 at 10:31 PM, David Miller <davem@davemloft.net> wrote:
>
> The test currently is:
>
>        if (!cpu_has_pse || pcpu_need_numa())
>                return -EINVAL;
>
> Don't we really mean "!pcpu_need_numa()"?
>
> The way I read the intent, setup_pcpu_remap() should be used in the
> NUMA case.  But that's not what's happening because of how this test
> is coded.
>
> In fact, the test here is identical to the one used in
> setup_pcpu_embed()
> --

you are right. on one 4 sockets system got

[    0.000000] PERCPU: Allocated 471 4k pages, static data 1925472 bytes

that is from setup_pcpu_4k...

YH
