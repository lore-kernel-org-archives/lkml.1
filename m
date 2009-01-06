Return-Path: <linux-kernel-owner+w=401wt.eu-S1755204AbZAFXkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204AbZAFXkR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 18:40:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754042AbZAFXj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 18:39:59 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:60449 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418AbZAFXj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 18:39:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references
         :in-reply-to:content-type:content-transfer-encoding:from;
        b=ffQnHsDmy/VLcvN4WXhyX1O3KTEN4P+JJWAGmHX1WxZSGRO+ym9yv6vsa8OzUcvAr5
         9u3eXSwBap00EFk1iQWaaLnSOn2aQ6N+91CXjfuJ/FXRiHLhXsw2xfKB7PAK8C2dveq2
         ss61gufye/IqdaeEAHhYLQKL8f8WyrvUb5qog=
Message-ID: <4963EBD0.2080907@gmail.com>
Date: Tue, 06 Jan 2009 23:40:00 +0000
User-Agent: Thunderbird 2.0.0.19 (X11/20090104)
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@mail.ru>
CC: orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.28: warn_slowpath in orinoco receive path
References: <200901052005.12428.arvidjaar@mail.ru> <200901061251.41628.arvidjaar@mail.ru> <4963B8BE.9000204@gmail.com> <200901070007.52508.arvidjaar@mail.ru>
In-Reply-To: <200901070007.52508.arvidjaar@mail.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Dave <kilroyd@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Borzenkov wrote:
> On 06 January 2009 23:02:06 Dave wrote:
> 
>> Since we have to use spinlock we should introduce an rx_lock
>> specifically to protect the list so the tasklet is not held up by
>> anything else the driver is doing. I'll put something together if you
>> don't get round to it first.
>>
> 
> You mean something like attached patch? Not sure if it worth it frankly.

That's what I meant. I forgot we took orinoco_lock in orinoco_interrupt
though, and that highlights the fact that I've neglected to ensure
orinoco_lock is held when orinoco_rx is called from the tasklet.

So the locking gets simpler and fixes more problems than the one you
noticed. But there's some extra cleanup to do. I'll submit a patch in a
second.

I'm surprised my wireless hasn't misbehaved in the last year.


Dave.
