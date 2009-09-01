Return-Path: <linux-kernel-owner+w=401wt.eu-S1755285AbZIAWWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbZIAWWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 18:22:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755236AbZIAWWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 18:22:14 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:44641 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbZIAWWN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 18:22:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Qpdg5fCLYf+yoUTQge4fHzzwhL/svifuidT5vkzBaJGgLOunMmkkrkSVyRf5+64mTr
         UHfoHEVQUY5JAB2cLTKpThvsTE35XD/zMG/63P/sUm1F698LpP63xoiXYU+jMkYhGzhK
         O8qoZsxdFycv62mB8FWpAs7KUTl/mUVQg6FQo=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0907301801240.17818@localhost.localdomain>
References: <alpine.LFD.2.00.0905211430220.4390@localhost.localdomain>
	 <alpine.LFD.2.00.0907301801240.17818@localhost.localdomain>
Date: Wed, 2 Sep 2009 00:22:14 +0200
Message-ID: <63386a3d0909011522m7a175d3eyb3bbe8a29a5fd104@mail.gmail.com>
Subject: Re: Montreal Linux Power Management Mini-Summit, July 13, 2009 - 
	Meeting Notes
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Linux Power Management List <linux-pm@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/31 Len Brown <lenb@kernel.org>:

> A Linux Power Management "mini-summit" was held on July 13th, 2009 -
> on the first day of the Montreal Linux Symposium.
> (...)

> SH running cpufreq on top of clock framework
>        cpufreq has notifiers, clock framework does not

Hm! Paul can you elaborate on what that was about.

I've felt a need for clock notifiers and we've cheated by using
CPUfreq because it so happens that the clocking in system-wide
and whenever the CPU freq change so may the other clocks.

But if I put code into a PrimeCell MMC/SPI/I2C driver or whatever and
use CPUfreq that's very unelegant, and for other platforms where
the CPU freq don't change when this particular device clk freq
change plain misleading.

A clk pre/postchange notifier pair would really help and would
make for elegant drivers that can handle clock freq transitions.

Has anyone poked at this?

Linus Walleij
