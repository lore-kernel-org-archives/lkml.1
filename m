Return-Path: <linux-kernel-owner+w=401wt.eu-S1764508AbXGWQz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764508AbXGWQz3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 12:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756429AbXGWQzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 12:55:20 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:41738 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755764AbXGWQzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 12:55:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=An8uK2zTu3keoXxOfMXYJPbcTlGUdEaZVL9XxhiaYcw4/vgVTtWiSGjK/yPLHMN/dw+vgsc2ryMqMPlZMQMXDIvKQEz+GPY0u0HrQrFzIscCjogQox7B06BjdjgC9A363TTV+COr4XjxCSxs1IpqXyOiKSaBYOqqtIVfbjfuM2w=
Message-ID: <2c0942db0707230955l20f7aeeenfc481d89e5a80d4b@mail.gmail.com>
Date: Mon, 23 Jul 2007 09:55:16 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Michael Kerrisk" <mtk-manpages@gmx.net>
Subject: Re: Problems with timerfd()
Cc: "Andrew Morton" <akpm@osdl.org>, lkml <linux-kernel@vger.kernel.org>,
       "Linux Torvalds" <torvalds@osdl.org>,
       "Davide Libenzi" <davidel@xmailserver.org>, drepper@redhat.com
In-Reply-To: <46A44B7D.3030700@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46A44B7D.3030700@gmx.net>
X-Google-Sender-Auth: 495145793b7a3319
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hey there Michael, all,

On 7/22/07, Michael Kerrisk <mtk-manpages@gmx.net> wrote:
> Problem 1
> ---------
>
> The value returned by read(2)ing from a timerfd file descriptor is the
> number of timer overruns.  In 2.6.22, this value is 4 bytes, limiting the
> overrun count  to 2^32.  Consider an application where the timer frequency
> was 100 kHz (feasible in the not-too-distant future, I would guess), then
> the overrun counter would cycle after ~40000 seconds (~11 hours).
> Furthermore returning 4 bytes from the read() is inconsistent with eventfd
> file descriptors, which return 8 byte integers from a read().

I'm feeling slow, and think I'm missing something. Why is this an
issue? Wouldn't userspace just keep track of the last overrun count,
and subtract the two to get the overruns-since-last-read? That makes
it oblivious to rollovers, unless it can't manage to do a read once
every 11 hours.

(This is the same sort of thing we already have to deal with in
certain situations, such as network stat counters on 32 bit
platforms.)

Ray
