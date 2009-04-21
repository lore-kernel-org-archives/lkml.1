Return-Path: <linux-kernel-owner+w=401wt.eu-S1756908AbZDUOFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908AbZDUOFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 10:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752780AbZDUOFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 10:05:41 -0400
Received: from cathcart.site5.com ([74.54.107.137]:44361 "EHLO
	cathcart.site5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283AbZDUOFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 10:05:41 -0400
Message-ID: <49EDD2A7.9090300@compulab.co.il>
Date: Tue, 21 Apr 2009 17:05:27 +0300
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.16 (X11/20080907)
MIME-Version: 1.0
To: James Kosin <jkosin@beta.intcomgrp.com>
CC: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [RFD] voltage/current regulator consumer interface
References: <ct38K-3Fq-11@gated-at.bofh.it> <49EC9709.8070002@support.intcomgrp.com> <49ED628A.4000505@compulab.co.il> <49EDC935.7080308@beta.intcomgrp.com>
In-Reply-To: <49EDC935.7080308@beta.intcomgrp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cathcart.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Kosin wrote:
> Mike Rapoport wrote:
>> James Kosin wrote:
>>> Mike Rapoport wrote:
>>>> Hi,
>>>>
>>>> Recently there was a brief discussion on linux-arm-kernel list [1] about
>>>> controlling voltage regulator state in cases when there is no consumer device
>>>> for a particular regulator.
>>>>
>>>> I have some thoughts but I'd like to know people opinion before I start
>>>> implementation.
>>>>
>>>> Problem
>>>> -------
>>>> The regulator framework API provides ability to control the state of
>>>> voltage/current regulators from within the kernel. Usually the regulator
>>>> supplies power to a device and device driver or some hooks to the platform code
>>>> from the device driver manipulate the regulator state. However, the regulator
>>>> framework does not have userspace ABI that allows regulator state modifications.
>>>> Lack of this ABI prevents fine-grained control for power consumption of devices
>>>> such as GPS trancievers and GSM modems. Moreover, in SoC based systems it is
>>>> possible to switch on/off power to entire subsystem when it is not used.
>>>>
>>> I'd also ask the question, Why?
>>> If exposing to user space it leaves the possibility of damaging hardware
>>> or completely frying a board.
>> Suppose you have a handheld device with GPS transceiver. You would like to give
>> user the ability to switch the transceiver on and off.
>>
> 
> Then the GPS drivers should be made aware and let the drivers handle the
> on/off interface.  If a user is allowed to turn interfaces on/off at
> will with this then drivers could suffer from (shock)...  ie: you could
> turn off your hard-drive in a middle of a write by the driver corrupting
> data, if handled in the driver it could finish the write before turning
> off the drive.  I know this is a far stretch from a GPS were the device
> is only READ only.

The point is there's no GPS driver... GPS transceivers are usually connected to
a serial line and the applications access the GPS data through ttySX. The case
when there is a kernel driver for device connected to a regulator is completely
different. It is then the driver responsibility to decide when to power on/off
the device.

> I do agree it could be useful, but we need to be careful on how much
> control the user has over the drivers and system.  To an extreme, a user
> could be able to turn off CPU cores outside of the drivers control
> causing serious pipeline hazards that would need to be handled at the
> driver level.  This would not be an issue for GPS were the data is read
> only and the missing data is really not that important to the system
> operation and continued use.
> 
> James
> 

-- 
Sincerely yours,
Mike.

