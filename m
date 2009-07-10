Return-Path: <linux-kernel-owner+w=401wt.eu-S1756719AbZGJTen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719AbZGJTen (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 15:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752563AbZGJTee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 15:34:34 -0400
Received: from mail-pz0-f197.google.com ([209.85.222.197]:43588 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbZGJTed convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 15:34:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=IHroLbpRXpei932McYlgNSasMHXG1uYjqyNZlhiK3enKz/bJCTGwNWMQUFK7dcP6od
         NX1z6PnW9Ogubns9rN6+JIObsAmvwJ3/qOMhaiXoxVUgr+ibg+3FRvOGvjwTexb/0qRg
         /4e2i4yN+Vg84Oi0PivCP5T5HJ3t5NVbQSeYw=
MIME-Version: 1.0
In-Reply-To: <507E3B9268%linux@youmustbejoking.demon.co.uk>
References: <4A5716AA.5000903@ph.tum.de>
	 <71cd59b00907100545v6f440a19xfc3668826eb1e509@mail.gmail.com>
	 <4A5743AB.6090303@ph.tum.de>
	 <71cd59b00907100646h5e0283fcyce5874cc4a19106b@mail.gmail.com>
	 <4A575119.9070505@ph.tum.de>
	 <507E3B9268%linux@youmustbejoking.demon.co.uk>
Date: Fri, 10 Jul 2009 21:34:32 +0200
Message-ID: <71cd59b00907101234w772dc141kff52c7393e698e17@mail.gmail.com>
Subject: Re: [2.6.31-rc2] Writing to /sys/class/rfkill/*/state fails
From: Corentin Chary <corentin.chary@gmail.com>
To: Thiemo Nagel <thiemo.nagel@ph.tum.de>,
       Corentin Chary <corentin.chary@gmail.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       debian-eeepc-devel@lists.alioth.debian.org,
       acpi4asus-user@lists.sourceforge.net, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 10, 2009 at 8:57 PM, Darren
Salt<linux@youmustbejoking.demon.co.uk> wrote:
> [full quoting for linux-{kernel,wireless} & the perpetrator]
>
> I demand that Thiemo Nagel may or may not have written...
>
>> Corentin Chary wrote:
>>> On Fri, Jul 10, 2009 at 3:35 PM, Thiemo Nagel<thiemo.nagel@ph.tum.de>
>>> wrote:
>>>> Corentin Chary wrote:
>>>>> On Fri, Jul 10, 2009 at 12:23 PM, Thiemo
>>>>> Nagel<thiemo.nagel@ph.tum.de> wrote:
>>>>>> I just tested the new GSM rfkill in 2.6.31-rc2 and I get the following
>>>>>> on my EeePC 1000HGO:
>>>>>>   eee:/# cat /sys/class/rfkill/rfkill2/name
>>>>>>   eeepc-wwan3g
>>>>>>   eee:/# echo 0 > /sys/class/rfkill/rfkill2/state
>>>>>>   bash: echo: write error: Operation not permitted
>>>>>> What could be the reason for that?
>>>>> Reading the kernel source I can find:
>>>>>         /*
>>>>>          * The intention was that userspace can only take control over
>>>>>          * a given device when/if rfkill-input doesn't control it due
>>>>>          * to user_claim. Since user_claim is currently unsupported,
>>>>>          * we never support changing the state from userspace -- this
>>>>>          * can be implemented again later.
>>>>>          */
>>>>> It seems that rfkill should be controlled by /dev/rfkill (cf
>>>>> Documentation/rfkill.txt).
>>>>> Maybe network-manager can control that .. But I'm not sure.
>>>>> Maybe you should CC the wireless mailing list.
>>>> Thanks for the quick reply.  The interesting thing is, that the direct
>>>> access works well for eeepc-wlan and eeepc-bluetooth rfkills.  I've CC'd
>>>> debian-eeepc-devel, maybe they know something.
>>> Are you sure that it works with newer kernels ?
>>> This commit should have broken it for all rfkill.
>>>   commit 19d337dff95cbf76edd3ad95c0cee2732c3e1ec5
>>>   Author: Johannes Berg <johannes@sipsolutions.net>
>>>   Date:   Tue Jun 2 13:01:37 2009 +0200
>
>> You're right, all rfkills work with 2.6.30, but none works with 2.6.31-rc2.
>
> This is the first that I've heard of this. I'd not noticed since I've not
> needed Bluetooth on my 901 recently.
>
>> For the debian-eeepc folks:  2.6.31-rc2 breaks bluetooth toggling using
>> eeepc-acpi-scripts, but WLAN toggling still works.
>
> FSVO "works" (http://bugzilla.kernel.org/show_bug.cgi?id=13390), but that's a
> different problem.
>
> I consider this a regression. It breaks an interface which, though flawed, is
> ideally suited for scripting use and which eeepc-acpi-scripts uses in shell
> scripts.
>
> /dev/rfkill is not useful in shell scripts.

Maybe it would be possible with an rfkill command line tool (in C) ?
Is there such a tool somewhere ?


-- 
Corentin Chary
http://xf.iksaif.net - http://uffs.org
