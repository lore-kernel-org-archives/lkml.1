Return-Path: <linux-kernel-owner+w=401wt.eu-S1756150AbZCDOKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbZCDOKh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 09:10:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755000AbZCDOKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 09:10:06 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:35256 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282AbZCDOKB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 09:10:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OQCgMp8+mcrcoAv06RINwyYZXsv2JpgRAfM84Gaz5OrWkdogqCelLi65/7yLAAixhg
         HEnFcpBnxj0iTPenX/GDtOruC8cE1SUvg2YSZTmlbMhkKl0lMX6y0+lgHiyn11SSSdH1
         Tyxcl+uMrVdsYwlA3S0KaXzFA5DYNv8tzLlEw=
MIME-Version: 1.0
In-Reply-To: <1236135028.7883.44.camel@Maple>
References: <a5d9929e0903011636w6bff1032y28ab58c0ff8c8052@mail.gmail.com>
	 <20090301165729.8e08e1d7.akpm@linux-foundation.org>
	 <49AC28FF.1040102@gmail.com>
	 <a5d9929e0903031510r7f173f5cib7bd1a2426e92473@mail.gmail.com>
	 <1236135028.7883.44.camel@Maple>
Date: Wed, 4 Mar 2009 14:09:57 +0000
Message-ID: <a5d9929e0903040609x43dbeda9h26a882897a177400@mail.gmail.com>
Subject: Re: some tc commands fail on 2.6.29-rc6-git5, works on 2.6.28.7
From: Joao Correia <joaomiguelcorreia@gmail.com>
To: John Dykstra <john.dykstra1@gmail.com>
Cc: Jarek Poplawski <jarkao2@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

Just to confirm that i also have all traffic control/shaping (QoS,
connection limits, scheduling, etc) enabled on the config i use.

Its not just the specific version of tc i posted, i tried one from
last year (october, but i didnt note the exact build) with the same
result.

Cheers,
Joao Correia
Centro de Informatica
Universidade da Beira Interior
Portugal

On Wed, Mar 4, 2009 at 2:50 AM, John Dykstra <john.dykstra1@gmail.com> wrote:
> On Tue, 2009-03-03 at 23:10 +0000, Joao Correia wrote:
>> I have confirmed again that the exact same commands (as on the
>> original message), work flawlessly on 2.6.28.7 without a hitch, and,
>> AFAIK, work as intended. I have also tried the latest 2.6.29-rc6-git7
>> and it still fails like on git6.
>
> I have also reproduced this on Linus' latest 2.6.29-rc6 tree, using tc
> version iproute2-ss071016 and a kernel config with all traffic control
> features enabled.
>
> The error reported by tc comes from the kernel-level check added by:
>
>        commit c1b56878fb68e9c14070939ea4537ad4db79ffae
>        Author: Stephen Hemminger <shemminger@vyatta.com>
>        Date:   Tue Nov 25 21:14:06 2008 -0800
>
>        tc: policing requires a rate estimator
>
>    Found that while trying average rate policing, it was possible to
>    request average rate policing without a rate estimator. This results
>    in no policing which is harmless but incorrect.
>
>    Since policing could be setup in two steps, need to check
>    in the kernel.
>
>    Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
>    Signed-off-by: David S. Miller <davem@davemloft.net>
>
> I got the same error when using the tc version iproute2-ss090115 built
> this evening from the public git repository.
>
>  -- John
>
>
