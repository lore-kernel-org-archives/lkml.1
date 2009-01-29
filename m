Return-Path: <linux-kernel-owner+w=401wt.eu-S1756185AbZA2UrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbZA2UrU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 15:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751754AbZA2UrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 15:47:11 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:44842 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbZA2UrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 15:47:09 -0500
Message-ID: <498215C9.6090208@felter.org>
Date: Thu, 29 Jan 2009 14:47:05 -0600
From: Wes Felter <wesley@felter.org>
User-Agent: Thunderbird 2.0.0.18 (Macintosh/20081105)
MIME-Version: 1.0
To: dingxn@ymail.com
CC: linux-kernel@vger.kernel.org
Subject: Re: a question about p4_clockmod module on Xeon quad core processors
References: <765076.76058.qm@web59913.mail.ac4.yahoo.com>
In-Reply-To: <765076.76058.qm@web59913.mail.ac4.yahoo.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will give you an effective speed of 250 MHz:

for cpu in 0 1 2 3; do
	cpufreq-set -c $cpu -g userspace
	cpufreq-set -c $cpu -u 2.0GHz
	wrmsr -p $cpu 0x19A 0x12
done

0x19A is the IA32_CLOCK_MODULATION MSR and 0x12 is calculated from the 
Intel 64 and IA-32 Architectures Software Developer’s Manual section 
13.5.3. Legal MSR values are 0x12 (12.5% duty cycle) - 0x1E (87.5%) or 
0x00 for 100%. I tested it on a quad-core Xeon and it works.

This is somewhat reckless, so use it with caution.

Wes Felter - wesley@felter.org
