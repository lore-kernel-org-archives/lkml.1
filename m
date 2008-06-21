Return-Path: <linux-kernel-owner+w=401wt.eu-S1756193AbYFUBNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbYFUBNt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 21:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751083AbYFUBNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 21:13:42 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:48860 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbYFUBNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 21:13:41 -0400
Message-ID: <485C55E8.3090703@keyaccess.nl>
Date: Sat, 21 Jun 2008 03:14:16 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Stas Sergeev <stsp@aknet.ru>
CC: ALSA devel <alsa-devel@alsa-project.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.26-rc6 snd-pcsp: "Timer resolution is not sufficient"
References: <485AB878.5080101@keyaccess.nl> <485B2A92.4000801@aknet.ru>
In-Reply-To: <485B2A92.4000801@aknet.ru>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: 0.0 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20-06-08 05:57, Stas Sergeev wrote:

CCed onto linux-kernel to possibly help future googlers...

> Rene Herman wrote:

>> What's this? 2.6.26-rc6:
>> ===
>> input: PC Speaker as /class/input/input5
>> PCSP: Timer resolution is not sufficient (4000250nS)
>> PCSP: Make sure you have HPET and ACPI enabled.
>> PC-Speaker initialization failed.
>> pcspkr: probe of pcspkr failed with error -5
>> ===
>> A HPET I do not have, ACPI is enabled and the driver worked fine on a
>> previous -rc.
> 
> That means that the high-res timer > mode is not available. See
> cat /proc/timer_list
> It should contain the lines like
>   .resolution: 1 nsecs
> 1 nsecs means a high-res mode.
> Some large values (like 4000250)
> means low-res.
> Try adding the hrtimers people to
> CC if this is a problem.

In this case the problem was the ACPI PM-Timer (CONFIG_X86_PM_TIMER) got
disabled. Re-enabling it, snd-pcsp is working fine again.

It does seem a bit off that you needs something as (relatively) modern
as an ACPI timing source (or HPET, or ...) to drive something quite as
legacy as the PC speaker, but oh well.

Rene.


