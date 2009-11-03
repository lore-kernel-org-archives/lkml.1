Return-Path: <linux-kernel-owner+w=401wt.eu-S1754129AbZKCTMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129AbZKCTMw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 14:12:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbZKCTMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 14:12:50 -0500
Received: from Cpsmtpm-eml106.kpnxchange.com ([195.121.3.10]:49416 "EHLO
	CPSMTPM-EML106.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751600AbZKCTMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 14:12:49 -0500
From: Frans Pop <elendil@planet.nl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: 2.6.32-rc5: unexpected thermal shutdown?
Date: Tue, 3 Nov 2009 20:12:52 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <20091103105717.GA2516@elf.ucw.cz> <200911031825.04169.elendil@planet.nl> <20091103183739.GA3312@elf.ucw.cz>
In-Reply-To: <20091103183739.GA3312@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911032012.53556.elendil@planet.nl>
X-OriginalArrivalTime: 03 Nov 2009 19:12:53.0709 (UTC) FILETIME=[A4CD17D0:01CA5CB9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 November 2009, you wrote:
> pavel@amd:~$ grep . /proc/acpi/thermal_zone/*/*
> /proc/acpi/thermal_zone/THM0/cooling_mode:<setting not supported>
> /proc/acpi/thermal_zone/THM0/polling_frequency:<polling disabled>
> /proc/acpi/thermal_zone/THM0/state:state:                   ok
> /proc/acpi/thermal_zone/THM0/temperature:temperature:           58 C
> /proc/acpi/thermal_zone/THM0/trip_points:critical (S5):         127 C

Right, so this zone does not have a passive trip point. If it reaches 
critical temp before THM1, it would cause exactly what you saw.

Try recreating the same situation while watching the temp for both thermal 
zones.

The solution would be to force a passive cooling point for this zone using 
for example (X could be either 0 or 1; depends on order in which zones are 
defined in BIOS):
    echo 95000 > /sys/class/thermal/thermal_zoneX/passive

Should work with current kernels, but Andrew has a patch set from me 
for .33 that has some improvements: http://lkml.org/lkml/2009/10/26/41.

> 128C means "slightly fake" temperature sensor. It seems that it just
> produces 128 in THM0 when temperature exceeds some other limit.

Hmm. If THM0 does not have *any* other values between 58 and 128 then the 
above will probably not work. If it makes a few jumps, you should adjust 
the trip value in my example accordingly. For my HP2510p the 2 zones that 
have no passive trip point in BIOS luckily do have a "real" sensor.

Cheers,
FJP
