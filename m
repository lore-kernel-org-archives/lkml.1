Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759116Ab0CMMuj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 07:50:39 -0500
Received: from mail-ew0-f216.google.com ([209.85.219.216]:53891 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690Ab0CMMuh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 07:50:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sL5lBjbGr2MROjdt83wr1YMkGAqmMqaZyAXM7rDpkeTGHr5ntbX5UNIuKyZzXSL+Rs
         kzWyb5NSjkzG0HFNrsq8b2EP2rLALADgB8moqrlxCuhdufyjmmfXXhrP2g83cmJz8siw
         3zEbiJScKditleg/xJTC2hYxmMPl87a92x7+Y=
MIME-Version: 1.0
In-Reply-To: <71cd59b01003130116h4265769v9e1dae95361629ce@mail.gmail.com>
References: <b637ec0b1003111328u5c1d7d7fw6c76c409740827c7@mail.gmail.com>
	 <71cd59b01003120049n1a9fbbf3qfd37f14f241a7f64@mail.gmail.com>
	 <b637ec0b1003121207g5d29ddb4k338f1768ed1c2759@mail.gmail.com>
	 <71cd59b01003130116h4265769v9e1dae95361629ce@mail.gmail.com>
Date: Sat, 13 Mar 2010 13:50:35 +0100
Message-ID: <b637ec0b1003130450n3293ee78wc58e08a9bbcefe17@mail.gmail.com>
Subject: Re: Possible bug in eeepc-laptop.c - EeePC 900
From: Fabio Comolli <fabio.comolli@gmail.com>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: ACPI mailing list <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, I'm confused.

I rebooted with the "vanilla" eeepc-laptop.c and I'm sorry to say that
the situation it's not like the one I described in the post I wrote 2
days ago. Actually the situation with the patch reverted is the same I
have with the patch applied.

What I mean is that if I boot on AC power /proc/cpuinfo always reports
900MHz and 1800 bogomips. It I boot on battery /proc/cpuinfo always
reports 630MHz and 1260 bogomips. Plugging / unplugging the AC does
not change the situation. Only reboot does.

But the cpufv interface does indeed seem to work, as glxgears and
stellarium show the frame rate change accordingly to the powersave /
performance selection.

So my question is: what does really the cpufv interface do? Is it
supposed to change the processor frequency? Or does it change
something else?

And if the answer to the latest question is affirmative, why
/proc/cpuinfo seems to ignore it?

Sorry for the confusion.
Regards,
Fabio





On Sat, Mar 13, 2010 at 10:16 AM, Corentin Chary
<corentin.chary@gmail.com> wrote:
> On Fri, Mar 12, 2010 at 9:07 PM, Fabio Comolli <fabio.comolli@gmail.com> wrote:
>> Hi
>>
>> On Fri, Mar 12, 2010 at 9:49 AM, Corentin Chary
>> <corentin.chary@gmail.com> wrote:
>>> On Thu, Mar 11, 2010 at 10:28 PM, Fabio Comolli <fabio.comolli@gmail.com> wrote:
>>>> Hi.
>>>>
>>>> On Tue, Mar 9, 2010 at 11:58 PM, Fabio Comolli <fabio.comolli@gmail.com> wrote:
>>>>> Hi.
>>>>> I have an EeePC 900 running 2.6.34-rc1.
>>>>>
>>>>> If I boot it on AC the cpu runs at full speed, 900MHz; if I boot it on
>>>>> battery it runs only at 630Mhz. Plugging / unplugging the AC does not
>>>>> change the cpu frequency. Only a reboot can change the situation.
>>>>>
>>>>> I already tried to echo 0 or 1 to the
>>>>> /sys/devices/platform/eeepc/cpufv file; no effects, even if the file
>>>>> changes its value.
>>>>>
>>>>> This is not a regression from 2.6.33: this behavior is also present in
>>>>> that version.
>>>>>
>>>>> Does this ring any bells? This is really annoying, especially when
>>>>> trying to watch a movie on battery. Also 3D apps show a 30%
>>>>> performance drop, as expected.
>>>>>
>>>>> Regards,
>>>>> Fabio
>>>>
>>>> Well, it turns out that this is indeed a regression, but I don't know
>>>> from which kernel version.
>>>> I reverted (not cleanly) this patch:
>>>>
>>>>        http://patchwork.kernel.org/patch/28591
>>>>
>>>> and now
>>>>
>>>>        echo 1 > /sys/devices/platform/eeepc/cpufv
>>>>
>>>> enables the powersave mode and
>>>>
>>>>        echo 0 > /sys/devices/platform/eeepc/cpufv
>>>>
>>>> enables the performance mode.
>>>>
>>>> Tested with the non-benchmark glxgears (275 frames/sec in powersave
>>>> mode and 405 in performance mode) and stellarium (14 frames and 20
>>>> frames).
>>>>
>>>> Regards,
>>>> Fabio
>>>>
>>>
>>> Thanks for the report,
>>> Could you try to add a quick printk to show the value stored in
>>> set_acpi(CM_ASL_CPUFV, value); ?
>>> And also, could you send the result of acpidump ?
>>> Thanks,
>>
>> After the revert there is no set_acpi(CM_ASL_CPUFV, value) anymore.
>> Please find the acpidump in attachment.
>>
>> Regards,
>> Fabio
>
> Yep, I know, but un-revert the patch, and add a printk :p
> Could you also send the result of:
> /* clean boot */
> cat cpufv
> echo 0 > cpufv
> cat cpufv
> echo 1 > cpufv
> cat cpufv
>
> Thanks,
>
> --
> Corentin Chary
> http://xf.iksaif.net
>
