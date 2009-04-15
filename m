Return-Path: <linux-kernel-owner+w=401wt.eu-S1757955AbZDOFwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955AbZDOFwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 01:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753888AbZDOFwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 01:52:11 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:50864 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbZDOFwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 01:52:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=BuRTpZQDSEUmP3CwKd7qnKxhjgyWQoMlwa8zzkGnW1bJzanWYA7XxASlntk9r19vCw
         vxUmKmZbTrdOlye4DDLOmWBt7OW6x/lDVFhKTzP5rK/xHqyFMMJhmHx1uC3DaITTTW+6
         MNptGstjux64tmQt4xXgoK/Dpb7tDtv2jPKjc=
Message-ID: <49E575ED.8010306@gmail.com>
Date: Wed, 15 Apr 2009 07:51:41 +0200
From: Niel Lambrechts <niel.lambrechts@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090310)
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, mjg59@srcf.ucam.org,
       yakui_zhao <yakui.zhao@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux.kernel" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: 2.6.30-rc1 (latest git): thinkpad-acpi: cannot control brightness
 with hotkeys (BISECTED)
References: <49E10684.5090101@gmail.com>	 <20090411150555.8b13ed18.akpm@linux-foundation.org>	 <20090412161448.GC26502@khazad-dum.debian.net> <49E234ED.5010105@gmail.com>	 <1239585695.5564.5.camel@localhost.localdomain> <49E3575A.60204@gmail.com>	 <20090413203450.GC16152@khazad-dum.debian.net> <49E5234E.5070303@gmail.com> <1239756088.8954.5.camel@maxim-laptop>
In-Reply-To: <1239756088.8954.5.camel@maxim-laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2009 02:41 AM, Maxim Levitsky wrote:
> On Wed, 2009-04-15 at 01:59 +0200, Niel Lambrechts wrote:
>   
>> On 04/13/2009 10:34 PM, Henrique de Moraes Holschuh wrote:
>>     
>>> On Mon, 13 Apr 2009, Niel Lambrechts wrote:
>>>   
>>>       
>>>>>> In 2.6.29.1:
>>>>>> lrwxrwxrwx 1 root root 0 Apr 12 20:01 /sys/class/backlight/acpi_video0
>>>>>> -> ../../devices/virtual/backlight/acpi_video0
>>>>>>         
>>>>>>             
>>> Well, that at least confirms that thinkpad-acpi doesn't have anything to
>>> do with your troubles, you were using acpi video.
>>>   
>>>       
>> Okay, I've bisected it to:
>>
>> 74a365b3f354fafc537efa5867deb7a9fadbfe27 is first bad commit
>> commit 74a365b3f354fafc537efa5867deb7a9fadbfe27
>> Author: Matthew Garrett <mjg59@srcf.ucam.org>
>> Date:   Thu Mar 19 21:35:39 2009 +0000
>>
>>     ACPI: Populate DIDL before registering ACPI video device on Intel
>>
>> ---
>>
>> Matthew, can you help?
>>
>> Regards,
>> Niel
>>     
>
>
> Just to note,
>
> I have nvidia, and yet have the same bug.
> I reverted this commit - didn't help.
>   
While you may have _some_ of the same symptoms, you clearly don't have
the same bug.

I reverted the commit as well, and my laptop is working fine under
2.6.30-rc2 now.

> I get lots of 
> ACPI: Failed to switch the brightnes
> when I press hardware keys that change brightness
> (even these sometimes don't work)
>   
Mine consistently did not work, and I had no messages.

I understand you could try to do a limited bisect using something like
git bisect start -- drivers/acpi drivers/video

Perhaps you can do a bisect as well?

Regards,
Niel

