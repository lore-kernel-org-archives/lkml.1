Return-Path: <linux-kernel-owner+w=401wt.eu-S1752432AbYJVVGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432AbYJVVGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 17:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758411AbYJVVE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 17:04:57 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:42545 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758864AbYJVVEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 17:04:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ZRroEtRQDDXXh8SQpr2oV9oogLNhG9o+I2/XbhPN4h7nXNIN1Dcv8tryDedD0xtqHBfj/DkjTGy2jnBu/sOhUI+vxVBYQ5JhVT5MuMJEpXkEae5k7kbncc1T2zrKOAp8qGnxaH3RDAXWZPQ5PNfbLfIo61fSZXzHx/SQNCNDJKw=  ;
X-YMail-OSG: YEDn0UgVM1mLvvdXPdrkFFn35WNMXasBZT0C4MbagnoRiGUPViYJkBP8JlcwEPf.4i6fpwSo89tRDXO_DZC64q2qW83mQrNvWIBgdkJQoyLevhMUBc86ro3sh6DXbEFa.RA-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: avorontsov@ru.mvista.com
Subject: Re: [PATCH 4/7] gpiolib: implement dev_gpiochip_{add,remove} calls
Date: Wed, 22 Oct 2008 14:04:52 -0700
User-Agent: KMail/1.9.10
Cc: benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, i2c@lm-sensors.org,
       Jean Delvare <khali@linux-fr.org>, David Miller <davem@davemloft.net>
References: <20081016171222.GA24812@oksana.dev.rtsoft.ru> <20081022104606.GA510@oksana.dev.rtsoft.ru> <20081022183218.GA19025@oksana.dev.rtsoft.ru>
In-Reply-To: <20081022183218.GA19025@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810221404.52798.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 October 2008, Anton Vorontsov wrote:
> 
> > > The board info has another problem though. We can't remove it, thus
> > > we can't implement module_exit() for the 'OF glue'.

That's not a problem.  Why would you want to remove it?


> > And try to solve this problem... maybe then things will begin to
> > move forward.
> 
> There is another problem: board infos are scanned at the controller
> registration time only.

Right.  Such board description data should be made available
early in boot.  As a rule:  before arch_initcall() finishes,
so that subsys_initcall() code can use the associated GPIOs.

(It's fairly well acknowledged that init dependency handling
has a lot of problems.  Until that's fixed ... for GPIOs, the
general advice is to make sure everything is available by
subsys_initcall time,  so the subsystems which rely on GPIOs
to initialize -- power switches, resets, etc -- can initialize.
That can require i2c adapter drivers to use subsys_initcall,
for example.)


> So if we register the board infos after 
> the controller registered, then nobody will probe the board infos.

See above.  If you're doing it right, there's no problem.
That is, scan the OF tables early.  Just like PNP tables
get scanned early, for example.

- Dave



