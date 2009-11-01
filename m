Return-Path: <linux-kernel-owner+w=401wt.eu-S1752302AbZKAMhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302AbZKAMhd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 07:37:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752232AbZKAMhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 07:37:31 -0500
Received: from mail-iw0-f180.google.com ([209.85.223.180]:37607 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbZKAMha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 07:37:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=bYj3FMdjUcFPlUTyocoHznswxe6icavTOB4AGNYkdnoi44h6f+/1esZ5fK8unDzivi
         GZuwDQr5bw7wHIgCpAVY33Pp495Ea1FrTil9chB3uZQWtH5RG2EJQnrqwP6Dz5gC3sEL
         DlVtIcCx9etvYO61Az4AG8A2NfHACM7u1zLjQ=
MIME-Version: 1.0
In-Reply-To: <20091101073527.GB32720@elf.ucw.cz>
References: <1256650833-15516-1-git-send-email-mel@csn.ul.ie>
	 <20091027130924.fa903f5a.akpm@linux-foundation.org>
	 <alpine.DEB.2.00.0910271411530.9183@chino.kir.corp.google.com>
	 <20091031184054.GB1475@ucw.cz>
	 <alpine.DEB.2.00.0910311248490.13829@chino.kir.corp.google.com>
	 <20091031201158.GB29536@elf.ucw.cz>
	 <alpine.DEB.2.00.0910311413160.25524@chino.kir.corp.google.com>
	 <20091031222905.GA32720@elf.ucw.cz> <4AECC04B.9060808@redhat.com>
	 <20091101073527.GB32720@elf.ucw.cz>
Date: Sun, 1 Nov 2009 21:37:35 +0900
X-Google-Sender-Auth: d1afb5aa3fbb6d45
Message-ID: <2f11576a0911010437l45b64f64webffa649763406b1@mail.gmail.com>
Subject: Re: [PATCH 2/3] page allocator: Do not allow interrupts to use 
	ALLOC_HARDER
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Rik van Riel <riel@redhat.com>, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       stable@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Frans Pop <elendil@planet.nl>, Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       kernel-testers@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/11/1 Pavel Machek <pavel@ucw.cz>:
>> > I believe it would be better to simply remove it.
>>
>> You are against trying to give the realtime tasks a best effort
>> advantage at memory allocation?
>
> Yes. Those memory reserves were for kernel, GPF_ATOMIC and stuff. Now
> realtime tasks are allowed to eat into them. That feels wrong.
>
> "realtime" tasks are not automatically "more important".
>
>> Realtime apps often *have* to allocate memory on the kernel side,
>> because they use network system calls, etc...
>
> So what? As soon as they do that, they lose any guarantees, anyway.

Then, your proposal makes regression to rt workload. any improve idea
is welcome.
but we don't hope to see any regression.
