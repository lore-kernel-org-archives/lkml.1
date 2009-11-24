Return-Path: <linux-kernel-owner+w=401wt.eu-S932289AbZKXIn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289AbZKXIn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 03:43:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932264AbZKXIn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 03:43:27 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:55770 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932249AbZKXIn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 03:43:26 -0500
X-Sasl-enc: m5FEchKpU5jBQXg9eoD5UQQgTCBMHzO1/bbbnt0P7iiR 1259052211
Message-ID: <4B0B9CB1.3090808@ladisch.de>
Date: Tue, 24 Nov 2009 09:43:29 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Serge Belyshev <belyshev@depni.sinp.msu.ru>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [PATCH v3] k10temp: temperature sensor for AMD Family 10h/11h
 CPUs
References: <4AF91F70.10106@ladisch.de>	<4B06501B.8080509@ladisch.de>	<87ws1l5wcl.fsf@depni.sinp.msu.ru>	<4B0673D7.5010006@ladisch.de>	<20091120123016.19d98ab4@hyperion.delvare>	<4B068402.7020606@ladisch.de>	<20091120131855.7f8f8722@hyperion.delvare>	<4B0A3DB6.9090703@ladisch.de>	<20091123145154.5b2b5735@hyperion.delvare>	<4B0AAA55.3040702@ladisch.de> <20091123200527.1114cbc2@hyperion.delvare>
In-Reply-To: <20091123200527.1114cbc2@hyperion.delvare>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> On Mon, 23 Nov 2009 16:29:25 +0100, Clemens Ladisch wrote:
> > Jean Delvare wrote:
> > > The name k10temp is a problem, as AMD insists that there is no such
> > > things as K10 and K11, but instead "family 10h" and "family 11h"
> > > processors.
> > 
> > K10 was AMD's internal code name, and is widely used in practice.
> > I'd like to keep this name since it is consistent with the older
> > k8temp driver.
> > 
> > What name would you propose instead?  "amdfam10temp"?
>  
> Not very readable, I admit. "amd10temp" would do, I guess. But I agree
> it doesn't matter that much, it's only a driver name after all.

In that case, I'll just keep it.  :)

> > > Don't we have additional information about the actual maximum Tcase
> > > value for the different supported models, as we have in coretemp?
> > 
> > For AMD, Tcase is the physical temperature.  Did you mean Tctl?
> 
> I meant the physical temperature when Tctl = 70. In other words, the
> offset between Tctl and the physical temperature.

The Power and Thermal datasheets have information like "Tcase Max:
55 °C to 71 °C".  So this seems to be different for individual
processors.

It might be possible to get that information through SB-TSI, but AMD
tries to keep that specification secret.

> > There still is the built-in diode to be read by the motherboard, but the
> > internal sensor was never intended to be an absolute measurement but
> > just as a means for controlling the cooling.
> 
> Still we use it for that purpose at the moment. Maybe we simply should
> not?

Well, the absolute measurements have essentially the same purpose, and
would not make much sense without comparing them to some absolute limit.

In any case, it might make more sense to show such values as something
like "20 °C below maximum".


Best regards,
Clemens
