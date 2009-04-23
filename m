Return-Path: <linux-kernel-owner+w=401wt.eu-S1756470AbZDWQbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470AbZDWQbM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 12:31:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750741AbZDWQbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 12:31:00 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:36324 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbZDWQa7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 12:30:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MWWSrplw9HHdn1p9NbylTCMFoOpoCueu4QqdKNY3nk8KMQCl4ky7C8VPOCszVYprYD
         3skakE4Jsk8n8jw/sOdaWgIzjrcMK/9ucytZqDjcyXNBHKueUwGSY9+j9BOb1IUhnnzo
         pJcpY02DYhZpGp5J3FD6gSLQScBVqN2C6vwuA=
MIME-Version: 1.0
In-Reply-To: <20090423173728.4fa010fa@i1501.lan.towertech.it>
References: <1239036633-10032-1-git-send-email-anemo@mba.ocn.ne.jp>
	 <20090409153921.04b6384c.akpm@linux-foundation.org>
	 <20090410005820.4fcfcc1f@i1501.lan.towertech.it>
	 <20090423.235141.61509229.anemo@mba.ocn.ne.jp>
	 <20090423170253.6b6dfd21@i1501.lan.towertech.it>
	 <8bd0f97a0904230807q6c40436wa561d7b26db26cef@mail.gmail.com>
	 <20090423173728.4fa010fa@i1501.lan.towertech.it>
Date: Thu, 23 Apr 2009 12:30:58 -0400
Message-ID: <8bd0f97a0904230930w7c9ffaa4x5110c59098ff475b@mail.gmail.com>
Subject: Re: [rtc-linux] Re: [PATCH] rtc: Make rtc_update_irq callable with 
	irqs enabled
From: Mike Frysinger <vapier.adi@gmail.com>
To: rtc-linux@googlegroups.com
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, hcegtvedt@atmel.com, vapier@gentoo.org,
       rongkai.zhan@windriver.com, balajirrao@openmoko.org,
       david-b@pacbell.net, broonie@opensource.wolfsonmicro.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 11:37, Alessandro Zummo wrote:
> On Thu, 23 Apr 2009 11:07:38 -0400 Mike Frysinger wrote:
>> we just removed the shared bit from the Blackfin rtc driver because it
>> didnt really make sense for us.  i need to test something else, so is
>> the only change you need is the one posted originally ?  that makes
>> more sense to me than forcing everyone to use IRQF_DISABLED.
>
>  for the blackfin you should just check if
>  you have locking issues in your irq routine

the Blackfin driver calls rtc_update_irq() from its IRQ handler and
the handler is not registered with IRQF_DISABLED.  it makes more sense
to me to fix rtc_update_irq() than require all RTC drivers to register
with IRQF_DISABLED.  especially in my case as the Blackfin driver
itself doesnt need any locks.
-mike
