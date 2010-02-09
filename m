Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496Ab0BIPCT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 10:02:19 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56674 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907Ab0BIPCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 10:02:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Uv9Cf05pb+jtIjLiJ0EKh3uQAUTplZImNnRivwhd6iXEDo7N0otnwDIxwou7hYPjj9
         FNQdr/i5HRGr8brjKnFFHVKRMyiyhoUi+nQCLP2bbBXOx28t018JEO0wuFMVMiPEoZBY
         /PGWNyzBih7AwSAIt16tsIYcd5sahCGABL0H8=
Message-ID: <4B71795A.7000000@gmail.com>
Date: Tue, 09 Feb 2010 07:03:54 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Bastien Nocera <hadess@hadess.net>
CC: Ed Tomlinson <edt@aei.ca>, Marcel Holtmann <marcel@holtmann.org>,
       Michael Poole <mdpoole@troilus.org>, Jiri Kosina <jkosina@suse.cz>,
       "Gunn, Brian" <bgunn@solekai.com>, Ping <pinglinux@gmail.com>,
       linux-kernel@vger.kernel.org,
       BlueZ development <linux-bluetooth@vger.kernel.org>
Subject: Re: [PATCH] Bluetooth: Keep a copy of each HID device's report  descriptor.
References: <alpine.LNX.2.00.1001291515560.356@pobox.suse.cz>	 <87vdebfvfk.fsf@troilus.org>	 <1265392303.31341.235.camel@localhost.localdomain>	 <201002082106.06301.edt@aei.ca>	 <dd18b0c31002082322m4238a4a6m73fc30752ba30447@mail.gmail.com> <1265710460.2383.5685.camel@localhost.localdomain>
In-Reply-To: <1265710460.2383.5685.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/10 02:14, Bastien Nocera wrote:
> On Mon, 2010-02-08 at 23:22 -0800, Justin Mattock wrote:
>>> TIA
>>> Ed Tomlinson
>>>
>>> On Friday 05 February 2010 12:51:43 Marcel Holtmann wrote:
>>>> Hi Michael,
>>>>
>>>>>> looks good to me. I just prefer that you do the allocation of the report
>>>>>> descriptor before the HID object:
>>>>>
>>>>> An updated patch is below.  Sorry for the delay -- inclement weather
>>>>> here got in the way of testing this as quickly as I would have liked.
>>>>>
>>>>>  From e245ef87247f5e257db40c412af7991c9af375ab Mon Sep 17 00:00:00 2001
>>>>> From: Michael Poole<mdpoole@troilus.org>
>>>>> Date: Fri, 5 Feb 2010 12:21:38 -0500
>>>>> Subject: [PATCH] Bluetooth: Keep a copy of each HID device's report descriptor.
>>>>>
>>>>> The report descriptor is read by user space (via the Service
>>>>> Discovery Protocol), so it is only available during the ioctl
>>>>> to connect.  However, the probe function that needs the
>>>>> descriptor might not be called until a specific module is
>>>>> loaded.  Keep a copy of the descriptor so it is available for
>>>>> later use.
>>>>
>>>> patch has been applied. Thanks.
>>>>
>>>> Regards
>>>>
>>>> Marcel
>>>>
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>>
>>> Hi,
>>>
>>> I have been trying to test Michael's magic mouse drivers against 32.7 (or .8-rc).   Is there a tree
>>> based on .32 with these patches?  If not would it be possible to post the patches to lkml?  I do not
>>> mind sorting out a few conflicts - this thread assume one knows a little more about the process being
>>> used here than is obvious.
>>>
>>
>>
>> just got one of those magic things as well.
>> I did apply the patchs to the current HEAD, but
>> am getting a lifeless result i.g. here's what I did:
>>
>> sudo /usr/bin/hcitool scan
>> sudo /usr/bin/simple-agent hci0 D4:9A:20:88:C7:48

pin was already done at this point i.g. after 0000 was able to use
the mouse(no scroll function), but was able to work.
>> sudo /usr/bin/dbus-send --system --dest=org.bluez --print-reply
>> /org/bluez/1897/hci0/dev_D4_9A_20_88_C7_48 org.bluez.Input.Connect
>> sudo /usr/bin/test-device trusted D4:9A:20:88:C7:48
>>

this is to verify that you want to trust this device.
after this you should always be connected even after a reboot.
in this case magic mouse was not functioning after a reboot.

>> the thing works after that(no scroll), fast cursor though.
>> then reboot
>> once up and running nothing.
>> cat /var/log/daemon.log (shows this)
>>
>> Feb  8 22:57:40 Linux-1 bluetoothd[1973]: link_key_request
>> (sba=00:25:00:C0:6C:4F, dba=D4:9A:20:88:C7:48)
>> Feb  8 22:58:21 Linux-1 bluetoothd[1973]: last message repeated 5 times
>> Feb  8 22:59:21 Linux-1 bluetoothd[1973]: last message repeated 3 times
>> Feb  8 23:03:10 Linux-1 bluetoothd[1973]: link_key_request
>> (sba=00:25:00:C0:6C:4F, dba=D4:9A:20:88:C7:48)
>
> That means that your computer and the mouse aren't paired. The pin code
> for Apple mice is usually "0000" (as opposed to most mice which don't
> need pairing, just a poke and setting as trusted).
>

I'll spend some time today(need a break from looking at another 
problem), to see if I can get this thing functioning.


>> (could be missing something though(don't use gnome/kde-bluetooth)although
>> mightymouse works).
>
> Cheers
>
>

Justin P. Mattock
