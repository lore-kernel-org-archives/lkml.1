Return-Path: <linux-kernel-owner+w=401wt.eu-S1759174AbZKFNe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759174AbZKFNe6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 08:34:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757632AbZKFNe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 08:34:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757033AbZKFNe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 08:34:57 -0500
Message-ID: <4AF42672.7040501@redhat.com>
Date: Fri, 06 Nov 2009 14:36:50 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Jean Delvare <khali@linux-fr.org>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [patch 1/5] hwmon: Convert fschmd to unlocked_ioctl
References: <20091015202722.372890083@linutronix.de> <20091015202758.400949170@linutronix.de> <20091106141542.12404c5c@hyperion.delvare> <200911061422.49596.arnd@arndb.de>
In-Reply-To: <200911061422.49596.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 11/06/2009 02:22 PM, Arnd Bergmann wrote:
> On Friday 06 November 2009, Jean Delvare wrote:
>> I'm not sure why we need to hold the mutex here? My understanding is
>> that watchdog_data_mutex protects watchdog_data_list and each
>> watchdog's kref. And the above code doesn't touch either.
>>
>> What I am more worried about is why ident is declared static. This
>> looks like a bug to me. Instead of abusing watchdog_data_mutex to
>> workaround this, I'd rather remove the "static". I guess that the
>> current code happens to work because neither data->revision nor
>> nowayout can change over time, but this looks needlessly fragile.
>>
>> Hans, any comment?
>
> The data copied into the watchdog_info data structure is completely
> static. To make that clearer, I'd suggest moving it outside of
> the ioctl function, and initializing it from fschmd_init.
> Then it becomes obvious that the mutex is not needed to protect it.
>

Moving the ident struct to the data structure would have it needlessly
using RAM all the time, the best and simplest fix for this is to simply
stop declaring ident static inside the ioctl function.

Regards,

Hans
