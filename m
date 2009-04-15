Return-Path: <linux-kernel-owner+w=401wt.eu-S1756284AbZDOGx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284AbZDOGx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 02:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751082AbZDOGxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 02:53:46 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:41110 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbZDOGxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 02:53:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ib+yYpJL6uPny3jO1lHzaRHBDmspqCh/4TuAQ5ymdtb/Odl7U/9o73q5sRV/F8hbSv
         T9yIdfNBIVc6QKj+6jgOI7xiUevYKqjgLqK/7qIAdTQl4UKG2RtGVB/oRfgODGo+bldz
         bVP8h8KfDp/Q3C5Cb/YfbzNf61DAQr9fvcvk4=
Message-ID: <49E58460.1010402@gmail.com>
Date: Wed, 15 Apr 2009 08:53:20 +0200
From: Niel Lambrechts <niel.lambrechts@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090310)
MIME-Version: 1.0
To: Zhang Rui <rui.zhang@intel.com>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       "mjg59@srcf.ucam.org" <mjg59@srcf.ucam.org>,
       "Zhao, Yakui" <yakui.zhao@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux.kernel" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: 2.6.30-rc1 (latest git): thinkpad-acpi: cannot control	brightness
 with hotkeys (BISECTED)
References: <49E10684.5090101@gmail.com>	 <20090411150555.8b13ed18.akpm@linux-foundation.org>	 <20090412161448.GC26502@khazad-dum.debian.net> <49E234ED.5010105@gmail.com>	 <1239585695.5564.5.camel@localhost.localdomain> <49E3575A.60204@gmail.com>	 <20090413203450.GC16152@khazad-dum.debian.net> <49E5234E.5070303@gmail.com> <1239760242.7661.305.camel@rzhang-dt>
In-Reply-To: <1239760242.7661.305.camel@rzhang-dt>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2009 03:50 AM, Zhang Rui wrote:
> On Wed, 2009-04-15 at 07:59 +0800, Niel Lambrechts wrote:
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
>>     
>
> please set CONFIG_DRM_I915_KMS, reload the ACPI video driver after
> loading i915 and see if it helps.
>   
In all the kernels I've tried (up to 2.6.30-rc2), I get issues with KMS:

I boot with 'modeset=1 i915=1', console login is okay and 'modprobe i915
modeset=1' seems to work - the console resolution changes (very small
1920x1200).

When I do 'init 5' kdm loads (and display the logon screen) but after
entering my username/password it hangs at the KDE splash-screen (the
last icon, so some progress must have been made). Caps lock then won't
even work, but emergency sync seemed to do the trick.

/var/log/warnings:
Apr 15 07:55:11 linux-7vph nm-dispatcher.action: Script
'/etc/NetworkManager/dispatcher.d/autofs' exited with error status 1.
Apr 15 07:55:12 linux-7vph kernel: allocated 1920x1200 fb: 0x02020000,
bo f598acc0
Apr 15 07:55:12 linux-7vph kernel: Console: switching to colour frame
buffer device 240x75
Apr 15 07:55:13 linux-7vph nm-dispatcher.action: Script
'/etc/NetworkManager/dispatcher.d/nfs' exitedwith error status 6.
Apr 15 07:55:19 linux-7vph kdm_config[3234]: Multiple occurrences of key
'UseTheme' in section [X-*-Greeter] of /usr/share/kde4/config/kdm/kdmrc
Apr 15 07:55:22 linux-7vph kernel: CE: hpet increasing min_delta_ns to
15000 nsec
Apr 15 07:56:10 linux-7vph kernel: Emergency Sync complete
Apr 15 07:56:26 linux-7vph kernel: CE: hpet increasing min_delta_ns to
22500 nsec
Apr 15 07:56:27 linux-7vph kernel: Emergency Sync complete
Apr 15 07:56:49 linux-7vph kernel: Emergency Sync complete
Apr 15 07:56:55 linux-7vph kernel: CE: hpet increasing min_delta_ns to
33750 nsec
Apr 15 07:56:56 linux-7vph kernel: Emergency Sync complete

So while I'd love to use KMS, I have never been able to get X up using it.

Regards,
Niel


