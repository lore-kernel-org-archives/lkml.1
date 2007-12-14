Return-Path: <linux-kernel-owner+w=401wt.eu-S1760747AbXLNVjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760747AbXLNVjY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 16:39:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756169AbXLNVjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 16:39:15 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:15208 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbXLNVjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 16:39:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=PVXudKMPhXxP3QWDfVnBURgYRhi+C4rK0u5pJT5vN5JEK9Nvg3jkpVHrZczfS1y+hswDieaVEqzrkm72AuLVhU+jI5EJv/jGPu+r13MeoU/Su3S1xgiAA8NnqiBIYi+VEAwSrMXFe2V2zAheS7hNO07ea4fQPICrP1Ag1fAZleM=
Message-ID: <2c0942db0712141339t4aa96045m1f6c57b53efb5f75@mail.gmail.com>
Date: Fri, 14 Dec 2007 13:39:10 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore to mutex
Cc: "Ingo Molnar" <mingo@elte.hu>, bcm43xx-dev@lists.berlios.de,
       "Daniel Walker" <dwalker@mvista.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux@bohmer.net, jonathan@jonmasters.org,
       matthias.kaehlcke@gmail.com, kjwinchester@gmail.com,
       "John Linville" <linville@tuxdriver.com>,
       "Larry Finger" <Larry.Finger@lwfinger.net>
In-Reply-To: <200712142113.09119.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071213003028.676998182@mvista.com>
	 <200712142038.58400.mb@bu3sch.de>
	 <2c0942db0712141155n40ba60agde79e436aa5cb8f2@mail.gmail.com>
	 <200712142113.09119.mb@bu3sch.de>
X-Google-Sender-Auth: d59678d66cca577d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 14, 2007 12:13 PM, Michael Buesch <mb@bu3sch.de> wrote:
> Ray, I _do_ want to understand what is going on in your machine.
> I _have_ to understand it. But I currently do not understand how the
> quoted patch could fix modprobe of b43 or rfkill. I'd simply call that
> impossible.

Then perhaps it is. Perhaps it's a race condition in my userspace
where something NetworkManager related is trying to up the interface,
I don't know. More below.

Regardless, I'm going to have to put off doing more debugging until
tomorrow. I've rebooted back into 2.6.23.0 as wireshark doesn't show
any packets using 2.6.24-rc3 (the version I've been testing), reported
elsewhere, and that's preventing me from doing actual work with my
system, as I'm in the middle of trying to enhance a network server for
a client.

Note, the wireshark issue is very much not a bcm43xx/b43 issue; I'm
not trying to lay that at your feet.

> So could you please try to reproduce the breakage by reverting that
> patch again? Just to make really sure it is this patch fixing the issue
> and not just some coincidence.

I don't have the patch applied, so that's at least part of the
misunderstanding here. All I have is my sequence of "load b43, ssb,
nothing happens, unload them, load rfkill, rfkill-input, ssb, b43 and
something happens." I could very well be wrong. But I'm at the limit
of what I care to know about the b43 driver, and this is where I'm
asking for your help.

Hopefully tomorrow, I'll be able to build current tip and try this all
again, and I'll also try to do it with NetworkManager killed in the
background in case it was trying to bring the interfaces up behind my
back.

> Thanks for your help.

Thanks for treating me like an adult.
