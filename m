Return-Path: <linux-kernel-owner+w=401wt.eu-S1758104AbXK3WTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104AbXK3WTn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 17:19:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753043AbXK3WTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 17:19:36 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:47702 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806AbXK3WTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 17:19:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=NCLRiykdrUxNQ88Qn3lw6ccq2jQLmYN4n+9qk5b7yihybbLS0ESM3CKGeSTeYUo5wEs/LpyIakwriO0LHUtfFJyeJK9TcYeKUCOq1h4hUCJgX02vDviTk1qvJAujdPD7/EAXP7VXy+5dmti7UEKd0hll0XHJcMk0bpX+QCSV3Xc=
Message-ID: <47508C72.8050703@gmail.com>
Date: Fri, 30 Nov 2007 23:19:30 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH 1/1] HWMON: coretemp, suspend fix
References: <661416096128474967.slaby@pripojeni.net> <20071130231512.1111d558@hyperion.delvare>
In-Reply-To: <20071130231512.1111d558@hyperion.delvare>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2007 11:15 PM, Jean Delvare wrote:
> Hi Jiri,

Hi.

> On Fri, 30 Nov 2007 15:12:46 +0100, Jiri Slaby wrote:
>> Ok, I don't see it merged in the latest -mm (mmotm). Could you, Mark, Rafael,
>> sign off this version of the patch (Mark's + Rafael's fix)?
>>
>> --
>>
>> From: Mark M. Hoffman <mhoffman@lightlink.com>
>>
>> coretemp, suspend fix
>>
>> It's not permitted to unregister device/cpu if frozen and going to sleep.
>> It causes deadlock on systems, where coretemp hwmon is loaded. Do it only
>> in non-freezed states instead.
>>
>> Cc: Rafael J. Wysocki <rjw@sisk.pl> (frozen fix)
>> Cc: Mark M. Hoffman <mhoffman@lightlink.com>
>> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
>>
>> ---
>> commit 4f0e19b172ed18fb29e8006c4470fd37aa245a7a
>> tree bec1cc4f7a499efe94c5f9d2d208db325914f28e
>> parent 877dcc2ef6c7c17a64155cf201886c49622250e9
>> author Jiri Slaby <jirislaby@gmail.com> Tue, 27 Nov 2007 20:19:47 +0100
>> committer Jiri Slaby <ku@bellona.localdomain> Thu, 29 Nov 2007 23:41:11 +0100
>>
>>  drivers/hwmon/coretemp.c |    6 ++++--
>>  1 files changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
>> index 5c82ec7..ce7457d 100644
>> --- a/drivers/hwmon/coretemp.c
>> +++ b/drivers/hwmon/coretemp.c
>> @@ -338,11 +338,13 @@ static int coretemp_cpu_callback(struct notifier_block *nfb,
>>  	switch (action) {
>>  	case CPU_ONLINE:
>>  	case CPU_ONLINE_FROZEN:
>> +	case CPU_DOWN_FAILED:
>>  		coretemp_device_add(cpu);
>> +	case CPU_DOWN_FAILED_FROZEN:
>>  		break;
>> -	case CPU_DEAD:
>> -	case CPU_DEAD_FROZEN:
>> +	case CPU_DOWN_PREPARE:
>>  		coretemp_device_remove(cpu);
>> +	case CPU_DOWN_PREPARE_FROZEN:
>>  		break;
>>  	}
>>  	return NOTIFY_OK;
> 
> Should this change go to the stable tree(s) as well?

Sorry, I have no idea. Rafael?
