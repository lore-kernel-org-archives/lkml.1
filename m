Return-Path: <linux-kernel-owner+w=401wt.eu-S934969AbZLKIdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934969AbZLKIdT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 03:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934847AbZLKIdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 03:33:17 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:50007 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934829AbZLKIdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 03:33:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=VALgHz8jab7aEJOy3InLFHHj4QPyEFVawlTGLDFdSfI1wtC5UzPAfdcPAcrUpk0ien
         EBUmeWw5RO6YbLIqKrTDA3J/wuLcUn31MmNzTdJ/Tpd+6+mVG+ewRBRnFAOpTgLuP8wJ
         INW1rjRRARVHd9k0aHG9Y7aEdj0bxc3UP30Dg=
MIME-Version: 1.0
In-Reply-To: <20091209162958.3b98c077@lxorguk.ukuu.org.uk>
References: <f9f38a550912090647q5af6cb14w84ea8d9223d82bd9@mail.gmail.com>
	 <20091209162958.3b98c077@lxorguk.ukuu.org.uk>
Date: Fri, 11 Dec 2009 16:33:23 +0800
Message-ID: <f9f38a550912110033n69e3a3cdncec253e3102e884e@mail.gmail.com>
Subject: Re: Questions about Watch Dog Timer under Linux.
From: Cypher Wu <cypher.w@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not sure if there is already a framework to cope with this
situation, or I've design it myself to use kernel thread to work with
the real WDT and interface to the user space application? And since
the WDT start to work just a very short interval after the system
power on, do I have to modify mboot  and Linux kernel to support dog
clearing from the very beginning?


On Thu, Dec 10, 2009 at 12:29 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> products is usually a seperate chip on the board wich will start to
>> work after power reset and will time out in 2 seconds. The system has
>> to start dog clearing from the very beginning and there have no way to
>> disable WDT.
>
> That will be fun as you will probably need to start some kind of kernel
> task refereshing it early in boot unless your boot is very quick.
>
> If it cannot be disabled then you don't need to support the disable
> option. The watchdog API is a range of features designed to cover all
> watchdogs. Many only have a few of the features. A large number of the
> supported watchdogs only support a single timeout rate.
>
>> Is this the pattern we have to follow to use WDT under Linux? We have
>> to choose a chip as WDT, and it seems the chip we've familiar under
>> embedded systems can't be used under Linux?
>
> There are two ways to handle this depending on your needs and what the
> applications require. The first is to provide the real hardware interface
> - 2 second fixed timeout, no disable. That's perfectly sufficient.
>
> The other (which some devices do) is to create a kernel thread that
> refreshes the watchdog each second but *only* if a user application has
> made a watchdog call within the last [whatever] seconds. That also allows
> you to provide a disableable watchdog. More flexible but extra work and
> if your embedded system doesn't need the extra facilities - why bother 8)
>
>
