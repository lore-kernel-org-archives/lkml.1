Return-Path: <linux-kernel-owner+w=401wt.eu-S1756766AbYJQUcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766AbYJQUcW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 16:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753449AbYJQUbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 16:31:49 -0400
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:34635 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752974AbYJQUbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 16:31:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=XaASzenMsOFcwUElC2eR/R4vZHS0gvkriF0WdjQ64pL/5k9VwW04Vxkv6Ga3DbS4AkPM2K23narpV+KhJibdoPIojATIeZO9TvFw9D6zvivsdGB2SYuOqYITzeNR06GhI5rodjTd4rwbKWMt8jpgGGQ0tQfulvr9uhreeLznk1E=  ;
X-YMail-OSG: VpupvSQVM1mcE92J2E062FUuK9CqqITV1NwamlVol8qbDX_9uHN4JazzX3AKQ.aLVH69JoS.VA8_YHcBBWPPLlYVY_KJXfd.gMQSRouCdxlwEN7Tq8cxtt_Y3MJX64JY8W.jexcerwVfvLnP8SCOOCN5tAeHlOEAIQo4XNw-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [PATCH 5/7] of/gpio: implement of_dev_gpiochip_{add,remove} calls
Date: Fri, 17 Oct 2008 13:25:01 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       "Steven A. Falco" <sfalco@harris.com>,
       Grant Likely <grant.likely@secretlab.ca>,
       Jean Delvare <khali@linux-fr.org>, David Miller <davem@davemloft.net>,
       i2c@lm-sensors.org, linuxppc-dev@ozlabs.org
References: <20081016171222.GA24812@oksana.dev.rtsoft.ru> <20081016171303.GE5515@oksana.dev.rtsoft.ru>
In-Reply-To: <20081016171303.GE5515@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200810171325.01729.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 October 2008, Anton Vorontsov wrote:
> +       if (of_gc->chip)
> +               return of_gc->chip;
> +       return &of_gc->gc;

presumably there's a reason not to

	of_gc->chip = &of_gc->gc;

when this gets set up, so this can always be a simple

	return of_gc->chip;

(and inlined)?  Needlessly complex...


