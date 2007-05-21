Return-Path: <linux-kernel-owner+w=401wt.eu-S1762317AbXEURuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762317AbXEURuz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 13:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756561AbXEURus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 13:50:48 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:13279 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756329AbXEURur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 13:50:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=sCIDCPRH2ECZ3K1pTtKznMNUEbcCzVKn7sH/aA3FAgo5KIvazSdvfrUAb6I7ozzXqRHoosz2H70L90nx3JD+nqSdcACszIdjawyrZIqir8vHAxgkVjZEYn6cCYP0XhZjFZCez2tlTHTs5Kb7BxnU4iodu4+ThT2VFe1tfugZUB8=
Message-ID: <3ae72650705211050p6b6cefbdya70dd4e0a27e2d1b@mail.gmail.com>
Date: Mon, 21 May 2007 19:50:46 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Pierre Ossman" <drzeus-list@drzeus.cx>
Subject: Re: Race free attributes in sysfs
Cc: "Greg KH" <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <46502A8B.70803@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46502A8B.70803@drzeus.cx>
X-Google-Sender-Auth: 39889c36f30d573b
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/20/07, Pierre Ossman <drzeus-list@drzeus.cx> wrote:
> I'm reworking the sysfs stuff in the MMC layer to be a bit more flexible, but
> there is one thing that has me baffled; how do you add attributes to an object
> in a race free manner when you have a dynamic set of attributes.
>
> I've looked at other parts of the kernel and they all use:
>
> 1. Add object.
> 2. Add attributes.
>
> To me, it seems like there's a window between 1 and 2 where the object is in
> /sys but doesn't have the proper attributes. Life for user space gets very
> annoying if it has to add artificial delays to avoid this window.
>
> So how do I do this properly? Something like this would, from my point of view,
> be the sane method:
>
> 1. Add hidden object.
> 2. Add attributes.
> 3. Show object.

Do you have a fixed set of attribute names, where you just want to
create a subset from that matches the individual device, or do you
need some sort of free naming for the attributes?

Kay
