Return-Path: <linux-kernel-owner+w=401wt.eu-S1754913AbYIHX3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbYIHX3d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 19:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753969AbYIHX3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 19:29:24 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:43469 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753690AbYIHX3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 19:29:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=E34VziBirbUdfzR7r3BMcksEBz58pQmPkIp5OPXVRSGVRXHLRI+Ixb6bgvE7ZaZztg3v8ICZatdbw566/up9bV2KozJVcv/excqveeAbm3TgId4rlqlMhxYVIOYDwZ8aoddWRldy0ABC7PKQ3ifNZTJ02KCnpbnUxhFp/R8jg5E=  ;
X-YMail-OSG: 6v3TjwkVM1lpStIiIzebNC7iFc6hoZMj4BHmM.MwqaQ4uUoaLm7kavT0IyiG5IVEknYousuY20Niu710VP9O77zUF2Uvr5fO9gvcV2u_StBDhu.QiiMzVHu10Ho36UI70c8-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] fix RTC_CLASS regression with PARISC
Date: Mon, 8 Sep 2008 16:29:20 -0700
User-Agent: KMail/1.9.9
Cc: James.Bottomley@hansenpartnership.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-parisc@vger.kernel.org,
       Alessandro Zummo <alessandro.zummo@towertech.it>
References: <200809081429.57805.david-b@pacbell.net> <1220914847.8074.81.camel@localhost.localdomain> <20080908.160441.124972717.davem@davemloft.net>
In-Reply-To: <20080908.160441.124972717.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809081629.21125.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 September 2008, David Miller wrote:
> I think the powerpc folks did the wrong thing and should just register
> generic platform_device objects in their platform code, and let the
> RTC layer drive the individual devices in response.

I kind of thought that was a migration aid ... 


> All the powerpc folks are doing is providing a dummy shim into the
> RTC layer using their machine description vector, and not really using
> the RTC layer drivers at all.

I basically agree.  There's functional overlap between those
machine descriptions and the RTC framework, and it should be
removed (by shrinking those descriptions).  The shim gets
/dev/rtcN support, and thus hwclock; also /sys/class/rtc/*
stuff.  But no wake alarms...


That said, there's a bit of unresolved stuff around NTP hooks
in the kernel.  Some patches are pending to let thtem work with
the RTC framework -- where writing an RTC may need to sleep,
for example because the RTC is on an I2C or SPI bus.  And
then there's the discussion of whether that shouldn't all be
handled by NTPD anyway, no special kernel support desired.
Alessandro has opinions there.  ;)

ISTR that was a factor in the powerpc taking that "sideways"
step.  Or if not powerpc, then some other arch.

- Dave

