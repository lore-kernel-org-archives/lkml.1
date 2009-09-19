Return-Path: <linux-kernel-owner+w=401wt.eu-S1751475AbZISR40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475AbZISR40 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 13:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751310AbZISR40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 13:56:26 -0400
Received: from mail-ew0-f217.google.com ([209.85.219.217]:62319 "EHLO
	mail-ew0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbZISR4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 13:56:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=MHPsDb8ip1k7hjlDF8wzPDhLHyX3LrYFcsScgsgMzrxd+bHLGiBNB8ksZvzyP1wpEj
         10kl5jMNcSrm7nXekj1G84QJfUBZSNlUf0+6gFEYkI6/qULsZb6ItTlcOXwE8u7g+wQG
         A/R2EJ0jgMtPXj9R0wIwm6LHHdxEViHyXORAo=
MIME-Version: 1.0
In-Reply-To: <20090919165501.65d77294@infradead.org>
References: <6278d2220909190747n62f7036dj2e5231fcdc4730fb@mail.gmail.com>
	 <20090919165501.65d77294@infradead.org>
Date: Sat, 19 Sep 2009 18:50:13 +0100
Message-ID: <6278d2220909191050l19f2a446r5ccf1907fd963096@mail.gmail.com>
Subject: Re: tickless and HZ=1000 throughput advantage?
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 19, 2009 at 3:55 PM, Arjan van de Ven <arjan@infradead.org> wrote:
> On Sat, 19 Sep 2009 15:47:24 +0100
> Daniel J Blueman <daniel.blueman@gmail.com> wrote:
>
>> On tickless kernels, is the general consensus that for non-embedded
>> systems, selecting HZ=1000 gives slightly more throughput in
>> particular situations than HZ=100 or 250, due to finer timer
>> intervals/granularity?
>
> it's not about throughput. It's about latency for some things....
> although now that select/poll and co use hrtimers it's not as critical
> anymore.
>
> the HZ timers aren't used much for anything time-critical nowadays.

Agreed. Do you think there is still a small case for moving to HZ=1000
(given it's effectively free) in situations like:

jiffies_to_transmit = port->baud?(1 + charsleft * 10 * HZ / port->baud):0;

<applying plausible figures>
(gdb) p (1 + 10 * 10 * 1000 / 38400) * 1
$3 = 3
(gdb) p (1 + 10 * 10 * 250 / 38400) * 4
$5 = 4

-> HZ=250 causes a 33% longer sleep than expected

perhaps?
-- 
Daniel J Blueman
