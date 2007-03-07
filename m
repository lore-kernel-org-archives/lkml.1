Return-Path: <linux-kernel-owner+w=401wt.eu-S1750979AbXCGF0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750979AbXCGF0z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 00:26:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751494AbXCGF0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 00:26:55 -0500
Received: from smtp109.sbc.mail.mud.yahoo.com ([68.142.198.208]:25583 "HELO
	smtp109.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750979AbXCGF0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 00:26:54 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=FgeIW2uDPYEhmVAupbn4EtGCMCr8Kx688HFwVf9LcVLqdd0rpg1Xqd/KyMfgiLasVgM7GijxcjfnwSvDbPcIhJwMne+iucvR9MS08Ls/EYFcJWaznpjwYbf7sGnUMIOUWzUnm7DC84kd1EaebM8iRQDgpnhEyVrIqFPLhM/OeNo=  ;
X-YMail-OSG: SIF8x.wVM1kXazY7OhBIWx22Ipy2QAqj3XSbffDOpmGSLNfsU6vQJOVw3ucObsOIT8ZbtW1ueOdAN9bd5GX0rtmPZW00v_YOHimciDvMoGrr5x_E.rh2OORk0vAWnlUiQQKgwutsoqHh4ms-
From: David Brownell <david-b@pacbell.net>
To: rol@as2917.net
Subject: Re: 2.6.21-rc2 : Oops in rtc_cmos...
Date: Tue, 6 Mar 2007 21:26:50 -0800
User-Agent: KMail/1.7.1
Cc: "'Adrian Bunk'" <bunk@stusta.de>, linux-kernel@vger.kernel.org,
       a.zummo@towertech.it, rtc-linux@googlegroups.com
References: <051e01c76072$fcdae290$4b00a8c0@donald>
In-Reply-To: <051e01c76072$fcdae290$4b00a8c0@donald>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703062126.52136.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 March 2007 8:42 pm, Paul Rolland wrote:

> It seems to me that the DRV_RTC_CMOS and the "standard" CONFIG_RTC
> shouldn't be used at the same time... Am I correct on that ? 

Yes.  I recall not forcing that because I couldn't be sure the new code
was functionally identical to the legacy driver ... and in areas like
HPET, knew it was not.  Of course, since then I see that someone has
kicked in a patch making Linux stop using HPET in legacy-replacement
mode, so that particular issue now seems moot.

Another area it's not functionally identical is CONFIG_SND_RTCTIMER,
where the ALSA code doesn't know how to use the new RTC framework.
(Or, probably, cope with the fact that not all RTCs can give periodic
IRQs at the rates it wants ...)

So it wasn't clear to me that distros might not need to have both
options, to help cope with strange hardware.  Phasing out legacy code
tends to be done a bit cautiously.

On the other hand, the distro vendors have been slow to look at this
issue, and haven't even upgraded their copies of "hwclock" to be
able to recognize /dev/rtc0, so I'm not holding my breath there.


> Wouldn't it be better to have this dependancy enforced ?

Feel free to submit a patch updating the Kconfig for both drivers.

Merging it might complicate distro efforts to move away from that
legacy driver (by preventing systems that can run with either one),
but I don't see that happening very quickly anyway.

- Dave
