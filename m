Return-Path: <linux-kernel-owner+w=401wt.eu-S1757092AbZGGOSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757092AbZGGOSY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 10:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756618AbZGGOSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 10:18:15 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:45147 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756527AbZGGOSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 10:18:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=LniLE2A9r8bKv2HBGu2Nq4/LZQnaSTyDxBR3Ndo7UC0cpvNqwyiiC0FXWxo8hEh/Zz
         zchBNJzM8pBY5a0fVIUifRTmj9FdUHmmVeF7rZqJQz8JCskmxpOdpm0Z4D+uNuVfRfsi
         X9lAE7vR6a3Ip3WQFa9LzUySAm7Y5Sb4thzwU=
Message-ID: <4A535973.9090206@gmail.com>
Date: Tue, 07 Jul 2009 08:19:31 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Christof Warlich <christof@warlich.name>
CC: linux-kernel@vger.kernel.org, ide <linux-ide@vger.kernel.org>
Subject: Re: "EXT3-fs error" after resume from s2ram
References: <4A4771FD.1020207@warlich.name> <4A480859.5010206@gmail.com> <4A48C799.2010102@warlich.name> <4A495C2D.1040706@gmail.com> <4A49A49C.10104@warlich.name> <4A4C42E2.6030305@gmail.com> <4A51C929.5010909@warlich.name> <4A52931D.5070109@gmail.com> <4A52F39A.1030704@warlich.name> <4A5311C7.1020507@warlich.name>
In-Reply-To: <4A5311C7.1020507@warlich.name>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2009 03:13 AM, Christof Warlich wrote:
> Christof Warlich schrieb:
>> Do you think I can fix the issue and circumvent the BIOS by passing
>> the real geomerty of the drive as kernel boot parameters? This may
>> also have the nice side effect that I could utilize the full capacity
>> of the drive. I'll definitly do some experiments in this direction and
>> let you know immediately if I succeed. Please let me know if this may
>> be a waste of time or if you know an appropriate fix.
> I retried with the boot parameter hda=16383,16,63 according to the
> values that I got from fdisk, but without success. Anyway, I would have
> expected that the kernel may have had a way to set the LBA48 geometry
> instead of CHS, but it looks like I'm on the wrong track here...

That's an old IDE parameter, not a libata one, and 160GB is way too 
large to be settable using CHS. What you likely want to do is pass the 
ignore_hpa=1 option to libata when it's loaded - either 
libata.ignore_hpa=1 on kernel command line, or in /etc/modprobe.conf if 
it's a module (how exactly to do this depends on your distribution). 
That way the protected area on the disk will get disabled and you can 
use the full capacity.

You could also permanently remove the HPA using hdparm commands, but if 
the BIOS actually can't handle the full drive capacity that might not be 
a good idea.
