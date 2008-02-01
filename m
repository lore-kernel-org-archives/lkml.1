Return-Path: <linux-kernel-owner+w=401wt.eu-S1765022AbYBABzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765022AbYBABzw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 20:55:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbYBABzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 20:55:41 -0500
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:31381 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761921AbYBABzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 20:55:40 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=MnzRGmUL4JMN3vUdnX+NAVKVEucBFPI0BGV3kpzMTOq/fuBmIxbFCKh/p4GGHpLn48J8/DJ/8JIcH0PaQLlM651Me6O9hhwUE+qyEJJ8/5PYTJNRb/JyPBikS+YOqjTgJu1bOAPAYUN9FxcQR0G3Ljny26uNpixvReTdCHTlz6U=  ;
X-YMail-OSG: Ph1BHT4VM1kAXk.MC3zQjW6u6OF5f8qFozSg6c0yExP1Um5C6SACITbr4gL6eLMJlBBn9kAy2A--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [linux-pm] sleepy linux self-test
Date: Thu, 31 Jan 2008 17:55:33 -0800
User-Agent: KMail/1.9.6
Cc: linux-pm@lists.linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       kernel list <linux-kernel@vger.kernel.org>
References: <20080130131748.GA3796@elf.ucw.cz>
In-Reply-To: <20080130131748.GA3796@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801311755.33899.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 January 2008, Pavel Machek wrote:

> --- a/drivers/rtc/rtc-cmos.c
> +++ b/drivers/rtc/rtc-cmos.c
> @@ -78,7 +78,7 @@ static inline int is_intr(u8 rtc_intr)
>  
>  /*----------------------------------------------------------------*/
>  
> -static int cmos_read_time(struct device *dev, struct rtc_time *t)
> +int cmos_read_time(struct device *dev, struct rtc_time *t)
>  {
>
>	... etc ...

You should be using the standard RTC library calls, exported
from drivers/rtc/interface.c ... and making sure this mechanism
will work with any wakeup-capable RTC.  Otherwise you'll end
being needlessly x86-specific, or reinventing those calls.

Plus, the way you're doing it now is violating the locking
protocol used by that driver.

- Dave
