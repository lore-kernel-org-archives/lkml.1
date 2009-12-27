Return-Path: <linux-kernel-owner+w=401wt.eu-S1751446AbZL0WdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446AbZL0WdL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 17:33:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751253AbZL0WdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 17:33:10 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:40220 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206AbZL0WdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 17:33:09 -0500
Message-ID: <4B37E09B.10309@epsm.fr>
Date: Sun, 27 Dec 2009 23:32:59 +0100
From: Didier Spaier <didier.spaier@epsm.fr>
User-Agent: Thunderbird 2.0.0.23 (X11/20090820)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, len.brown@intel.com,
       ibm-acpi@hmh.eng.br, kernel list <linux-kernel@vger.kernel.org>,
       ibm-acpi-devel@lists.sourceforge.net
Subject: Re: [ibm-acpi-devel] 2.6.33-rc2: regression: gkrellm no longer shows
 all the temperatures on thinkpad x60
References: <20091227215722.GN11737@elf.ucw.cz> <4B37DE8F.1000806@epsm.fr> <20091227222659.GP11737@elf.ucw.cz>
In-Reply-To: <20091227222659.GP11737@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Sun 2009-12-27 23:24:15, Didier Spaier wrote:
>> Pavel Machek wrote:
>>> ...I'll have to find out where gkrell got that info. It worked in
>>> 2.6.32.
>>>
>>> 									Pavel
>> Only to make sure... What is the output of cat /proc/acpi/ibm/thermal?
>>
>> I ask that question because I noticed battery temperature 0° displayed  by conky after updating to 2.6.32.2.
>> Looking at my .conkyrc I saw I tried to display ${smapi_bat_temp 0}
> but I had forgotten to re-install the tp_smapi module.
> 
> Uhuh, there's no /proc/acpi/ibm:
> 
> ls /proc/acpi/ibm         
> ls: cannot access /proc/acpi/ibm: No such file or directory
> 
> . I guess that's the problem :-(. Config is:
> 
> CONFIG_THINKPAD_ACPI=y
> # CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
> # CONFIG_THINKPAD_ACPI_DEBUG is not set
> CONFIG_THINKPAD_ACPI_UNSAFE_LEDS=y
> CONFIG_THINKPAD_ACPI_VIDEO=y
> # CONFIG_THINKPAD_ACPI_HOTKEY_POLL is not set
> 
> ...so I do not see "enable legacy interface" option.
> 									Pavel
bash-3.1$ grep THINKPAD_ACPI /boot/config-2.6.32.2strip
CONFIG_THINKPAD_ACPI=m
CONFIG_THINKPAD_ACPI_DEBUGFACILITIES=y
CONFIG_THINKPAD_ACPI_DEBUG=y
CONFIG_THINKPAD_ACPI_UNSAFE_LEDS=y
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
bash-3.1$

I suggest you modularize THINKPAD_ACPI.
