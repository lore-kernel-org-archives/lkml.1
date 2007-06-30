Return-Path: <linux-kernel-owner+w=401wt.eu-S1755051AbXF3Xd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051AbXF3Xd5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 19:33:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823AbXF3Xdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 19:33:47 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:6290 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbXF3Xdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 19:33:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=uNGWepBwWas45Trl+52dxKz9U2jR0CeUHH48laqOSClP42HUyHKj77ZQknZTRB13ctqwrR+0CY6nRevdBQvmxoOKEJROdB/vdjpPpenhXwHhBYqQkDUJugvEhUAz+JT8vUg3+k4idmS22cMAJDsWODSW6/3XES6ANjs7hAYP3Vc=
Message-ID: <4686E83A.4040301@googlemail.com>
Date: Sun, 01 Jul 2007 01:33:14 +0200
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@mail.ru>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, michal.k.k.piotrowski@gmail.com,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [possible regression] 2.6.22 reiserfs/libata sporadically hangs
 on resume from hibernation
References: <200706300859.47133.arvidjaar@mail.ru> <200706302237.50567.rjw@sisk.pl> <200707010134.30843.arvidjaar@mail.ru>
In-Reply-To: <200707010134.30843.arvidjaar@mail.ru>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Borzenkov pisze:
> On Sunday 01 July 2007, Rafael J. Wysocki wrote:
>> On Saturday, 30 June 2007 06:59, Andrey Borzenkov wrote:
>>> Since 2.6.18 I do not have suspend to RAM; now I am starting to lose
>>> suspend to disk :)
>>>
>>> Environment - vanilla kernel (2.6.22-rc6 currently + squashfs + single
>>> pata_ali patch to switch off DMA on CD-ROM), single root on reiserfs,
>>> libata with pata_ali driver.
>>>
>>> Until 2.6.22-rc I never had problems with hibernation. With 2.6.22-rc
>>> system hung at least once in every rcX. Up to rc6 those lockups were
>>> absolutely silent (black screen without reaction to any key). In rc6 I
>>> just got something different. After resume I got on screem:
>>>
>>> swsusp: Marking nosave pages: 000000000009f000-0000000000100000
>>> swsusp: Basic memory bitmaps created
>>> swsusp: Basic memory bitmaps freed
>>>
>>> After that it just sits there doing nothing. Ther was brief sound of HDD
>>> but I suspect it was related more to power-on. System was responding to
>>> power-on button press:
>>>
>>> ACPI Error (event-0305): No installed handler for fixed event [00000002
>>> 20070125]
>>>
>>> And SysRq was functioning.
>> That probably means that there's a deadlock somewhere in there.
>>
>>> Unfortunately I do not have serial console so I
>>> copy manually stacks from several last screens of output; I have tried to
>>> make a photo but right now my kbluetooth is refusing to work at all so I
>>> cannot transfer them :( (but I suspect quality would be too bad anyway)
>>>
>>> laptop_mode D
>>> 	io_schedule+0xe/0x20
>> Looks suspicious to me.  Can you identify what line of code this points to?
>>
> 
> If you could explain how to ...

gdb vmlinux

(gdb) l *io_schedule+0xe

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
