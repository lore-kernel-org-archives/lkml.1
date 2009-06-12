Return-Path: <linux-kernel-owner+w=401wt.eu-S1758044AbZFLRZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044AbZFLRZq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 13:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751089AbZFLRZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 13:25:38 -0400
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:50336 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750749AbZFLRZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 13:25:37 -0400
From: Frans Pop <elendil@planet.nl>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [BUG][2.6.30] Niced processes do not raise CPU frequency with ondemand
Date: Fri, 12 Jun 2009 19:25:37 +0200
User-Agent: KMail/1.9.9
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
References: <200906121844.02004.elendil@planet.nl> <1244825317.4534.1342.camel@localhost.localdomain>
In-Reply-To: <1244825317.4534.1342.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906121925.38693.elendil@planet.nl>
X-OriginalArrivalTime: 12 Jun 2009 17:25:39.0353 (UTC) FILETIME=[CE244890:01C9EB82]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the quick reply Venki.

On Friday 12 June 2009, Pallipadi, Venkatesh wrote:
> What does ignore_nice under cpufreq/ondemand say?

Right, that's 1 (was not aware that existed :-P)
And changing it to 0 solves the problem.

Next question is: how and why does it get set?
As userland has not changed (AFAIK), my first suspect remains the kernel.

# grep . /sys/devices/system/cpu/cpu*/cpufreq/ondemand/*
/sys/devices/system/cpu/cpu0/cpufreq/ondemand/ignore_nice_load:1
/sys/devices/system/cpu/cpu0/cpufreq/ondemand/powersave_bias:0
/sys/devices/system/cpu/cpu0/cpufreq/ondemand/sampling_rate:80000
/sys/devices/system/cpu/cpu0/cpufreq/ondemand/sampling_rate_max:40000000
/sys/devices/system/cpu/cpu0/cpufreq/ondemand/sampling_rate_min:40000
/sys/devices/system/cpu/cpu0/cpufreq/ondemand/up_threshold:90
/sys/devices/system/cpu/cpu1/cpufreq/ondemand/ignore_nice_load:1
/sys/devices/system/cpu/cpu1/cpufreq/ondemand/powersave_bias:0
/sys/devices/system/cpu/cpu1/cpufreq/ondemand/sampling_rate:80000
/sys/devices/system/cpu/cpu1/cpufreq/ondemand/sampling_rate_max:40000000
/sys/devices/system/cpu/cpu1/cpufreq/ondemand/sampling_rate_min:40000
/sys/devices/system/cpu/cpu1/cpufreq/ondemand/up_threshold:90
