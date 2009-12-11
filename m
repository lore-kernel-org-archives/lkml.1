Return-Path: <linux-kernel-owner+w=401wt.eu-S1762198AbZLKI1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762198AbZLKI1z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 03:27:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760854AbZLKI1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 03:27:51 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:32815 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760794AbZLKI1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 03:27:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=yH8SXOsKHk4NikyYReOosQ5vyigGvbabqk3+X2EL/HXfDjHzldB+YzPeN464aRJ2ql
         T6/xfNGPXN40LxqPmR9N78hRDNdMxlvHbFV/UFjDsrjXNQAJzy2CFbJUGLGGvsI5xd53
         HOYuGBiUT7kiQ4PodS6F8FzKJf9irXVz0dVYw=
MIME-Version: 1.0
In-Reply-To: <20091209145919.GH9018@sirena.org.uk>
References: <f9f38a550912090647q5af6cb14w84ea8d9223d82bd9@mail.gmail.com>
	 <20091209145919.GH9018@sirena.org.uk>
Date: Fri, 11 Dec 2009 16:27:55 +0800
Message-ID: <f9f38a550912110027r70710867k3a08c6d5913ce13@mail.gmail.com>
Subject: Re: Questions about Watch Dog Timer under Linux.
From: Cypher Wu <cypher.w@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems WATCHDOG_NOWAYOUT is a software mechanism? If it is defined
as 1 then the WDT can't be stopped if it has been started whether bye
closing the device file or writing the magic character 'V'.

On Wed, Dec 9, 2009 at 10:59 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Wed, Dec 09, 2009 at 10:47:28PM +0800, Cypher Wu wrote:
>> I'm used to work on embedded systems, the Watch Dog Timer in our
>> products is usually a seperate chip on the board wich will start to
>> work after power reset and will time out in 2 seconds. The system has
>> to start dog clearing from the very beginning and there have no way to
>> disable WDT.
>
>> Now I want to use WDT under Linux, while I read
>> Documentation/watchdog/watchdog-api.txt and then look though some
>> drivers of WDT under Linux, it seems WDT under Linux has to be able to
>> be disabled, and it will be disabled from the beginning, and starting
>> to work after the application open the special driver file?  The
>> sample code under Linux use a very bigger time span than our embedded
>> system:
>
> You don't *have* to be able to disable the watchdog - the API supports
> it but you can always fail to do so (and even where you can Linux
> watchdogs support a non-disabling mode, look for WATCHDOG_NOWAYOUT in
> existing drivers).  Similarly, there's no problem with having the
> watchdog be live at system startup - if the watchdog is already enabled
> when the driver is opened then the driver just needs to handle that
> gracefully.
>
>>       while (1) {
>>               ret = write(fd, "\0", 1);
>
> ...
>
>>               sleep(10);
>>       }
>>
>
>> Is this the pattern we have to follow to use WDT under Linux? We have
>
> You're free to update the watchdog as often as you like, the 10s is
> just a number that was picked which is suitable for that application.
>
>> to choose a chip as WDT, and it seems the chip we've familiar under
>> embedded systems can't be used under Linux?
>
> Nothing about your watchdog sounds particularly unusual for Linux.
>
