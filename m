Return-Path: <linux-kernel-owner+w=401wt.eu-S1760394AbZGGA2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760394AbZGGA2G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 20:28:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757996AbZGGAL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 20:11:56 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:33585 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757997AbZGGALz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 20:11:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=WRvqXJWxei1rFWU6Ph1QXOTFocl8RltHJ1FebcHqV2e3P43TarrqejVGdMS8Xdngb3
         jNYtaMe4hQboVX1cAFVHdRcNefxQtK1aI0T0XMPjGwX4cuz8bbPCtGdX9KBoTF1o3WXJ
         N3QHayL+q5Oumc//f+Q0bTlb5FXZnvx4HgS50=
Message-ID: <4A52931D.5070109@gmail.com>
Date: Mon, 06 Jul 2009 18:13:17 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Christof Warlich <christof@warlich.name>
CC: linux-kernel@vger.kernel.org, ide <linux-ide@vger.kernel.org>
Subject: Re: "EXT3-fs error" after resume from s2ram
References: <4A4771FD.1020207@warlich.name> <4A480859.5010206@gmail.com> <4A48C799.2010102@warlich.name> <4A495C2D.1040706@gmail.com> <4A49A49C.10104@warlich.name> <4A4C42E2.6030305@gmail.com> <4A51C929.5010909@warlich.name>
In-Reply-To: <4A51C929.5010909@warlich.name>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(ccing linux-ide)

On 07/06/2009 03:51 AM, Christof Warlich wrote:
> Robert Hancock schrieb:
>> There should definitely be some libata messages from the
>> suspend/resume process, they might not end up in that file though. You
>> might want to try changing the console loglevel before suspend so that
>> all kernel messages get displayed..
>
> Ok, I got the suspend / resume process logged quite complete now, it
> took me some time though to save the data due to the inaccessibility of
> the root filesystem after resume. But (a modified version of) netcat
> finally was my friend :-).
>
> So below you'll find all messages from "kern.*" between the point when
> calling "s2ram -f -p" up to the point when the system is back. The
> requested libata messages are included. Please let me know if any
> additional data would help.
> Jul 6 09:15:40 fossie kernel: [ 314.072707] WARNING: at
> /home/kernel-ppa/mainline/build/kernel/smp.c:289
> smp_call_function_single+0xa9/0x100()
> Jul 6 09:15:40 fossie kernel: [ 314.072707] WARNING: at
> /home/kernel-ppa/mainline/build/kernel/smp.c:289
> smp_call_function_single+0xa9/0x100()

This WARN should likely be looked at by someone, but it doesn't seem to 
be the main culprit.

> Jul 6 09:15:41 fossie kernel: [ 316.648468] ata1.00: ACPI cmd
> ef/03:0c:00:00:00:a0 filtered out
> Jul 6 09:15:41 fossie kernel: [ 316.648468] ata1.00: ACPI cmd
> ef/03:0c:00:00:00:a0 filtered out
> Jul 6 09:15:41 fossie kernel: [ 316.648480] ata1.00: ACPI cmd
> ef/03:45:00:00:00:a0 filtered out
> Jul 6 09:15:41 fossie kernel: [ 316.648480] ata1.00: ACPI cmd
> ef/03:45:00:00:00:a0 filtered out
> Jul 6 09:15:41 fossie kernel: [ 316.659047] ata1.00: n_sectors mismatch
> 268435456 != 312581808
> Jul 6 09:15:41 fossie kernel: [ 316.659047] ata1.00: n_sectors mismatch
> 268435456 != 312581808
> Jul 6 09:15:41 fossie kernel: [ 316.659054] ata1.00: revalidation failed
> (errno=-19)

This is why the hard disk failed to resume, somehow the drive shows a 
capacity of 149GB after resume but only 128GB before. What's the actual 
capacity of the drive? I suspect the drive has a host protected area on 
it, and somehow the HPA isn't showing up after we resume.

Can you post the dmesg log from normal bootup?
