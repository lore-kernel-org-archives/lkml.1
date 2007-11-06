Return-Path: <linux-kernel-owner+w=401wt.eu-S1755830AbXKFXz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830AbXKFXz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 18:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754307AbXKFXzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 18:55:14 -0500
Received: from stinky.trash.net ([213.144.137.162]:45196 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750AbXKFXzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 18:55:12 -0500
Message-ID: <4730FED5.20803@trash.net>
Date: Wed, 07 Nov 2007 00:55:01 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: David Miller <davem@davemloft.net>,
       djohnson+linux-kernel@sw.starentnetworks.com, jes@trained-monkey.org,
       mchan@broadcom.com, ram.vepa@neterion.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, bguo@sw.starentnetworks.com
Subject: Re: [PATCH 1/2] NET: Re-add VLAN tag for devices incapable of keeping
 it
References: <472A6089.7020104@hp.com>	<18223.22291.622615.129374@zeus.sw.starentnetworks.com>	<472F5A33.20906@trash.net>	<20071105.151544.175839612.davem@davemloft.net>	<472FB375.1020802@trash.net> <m3y7db45ga.fsf@maximus.localdomain>
In-Reply-To: <m3y7db45ga.fsf@maximus.localdomain>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> Patrick McHardy <kaber@trash.net> writes:
> 
>> I think there is one more case that matters, which is briding
>> from a device with VLAN stripping for a VLAN not configured
>> locally. The tag will be stripped and will be lost for forwarded
>> packets.
> 
> I think we should drop such packets on RX. Anyway we shouldn't
> forward them.

I believe you misunderstand the configuration I was thinking about:

eth0.1000        br0
     |             |
eth0 with VLAN stripping

Its slightly different that I thought though, __vlan_hwaccel_rx
drops packets for unknown vids, so as soon as you configure a VLAN
locally on the same device that is used for a bridge, no VLAN
packets will be forwarded at all.

Slightly inconsistent with how other layered devices work, but
can be avoided by adding the VLAN to br0.

