Return-Path: <linux-kernel-owner+w=401wt.eu-S1752016AbZHGEJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbZHGEJE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 00:09:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751175AbZHGEJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 00:09:03 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:57763 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbZHGEJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 00:09:01 -0400
X-RZG-AUTH: :P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrT1q0ngWNsKR9Dbc7nsXJ75kzGpLGTzXI=
X-RZG-CLASS-ID: mo00
Message-ID: <4A7BA8DB.2030102@hartkopp.net>
Date: Fri, 07 Aug 2009 06:08:59 +0200
From: Oliver Hartkopp <socketcan@hartkopp.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Luotao Fu <l.fu@pengutronix.de>
CC: socketcan-users@lists.berlios.de,
       Michael Olbrich <m.olbrich@pengutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [Socketcan-users] [PATCH] CAN: make checking in can_rcv	less
 restrictive
References: <1249572295-7801-1-git-send-email-l.fu@pengutronix.de>	<4A7B0957.5020808@hartkopp.net>	<20090806201740.GA7067@pengutronix.de> <20090806210230.GA22418@pengutronix.de>
In-Reply-To: <20090806210230.GA22418@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luotao Fu wrote:
> Hi Oliver (again ;-)),
> 
> On Thu, Aug 06, 2009 at 10:17:40PM +0200, Luotao Fu wrote:
>> Hi Oliver,
>>
>> On Thu, Aug 06, 2009 at 06:48:23PM +0200, Oliver Hartkopp wrote:
> ....
>>> When this BUG() triggers, someone provided a definitely broken *CAN* network
>>> driver, and this needsfp to be fixed on that level. 
>> In our case a sender (a FPGA) generates correct can frames carrying
>> wrong dlc length. This way the can driver on our side runs into the bug
>> though the driver itself is allright. The opposite needed to be fixed,
>> not our side.  Though we do suffer a system crash only because the
>> sender sends trash into the can network. This is imo quite bad.
>>
> 
> /me answering myself
> had a closer look again. Seemed you are right. The can driver should
> have get the can_dlc right prior to passing the message a level higher.

Hi Luotao,

just one additional point i discovered after sending my last reply:

When can_dlc is not in the CAN conform value range from 0..8, you can really
get into trouble when accessing the CAN frames payload by using the can_dlc as
an index (a usual use-case):

        for (i = 0; i < frame.can_dlc; i++) {
                my_userdata[i] = frame.data[i];
                printf("%02X ", frame.data[i]);
        }

In this case you might access values outside the data[8] array.

And this is definitely a bad idea when you're writing to my_userdata[].

Best regards,
Oliver

