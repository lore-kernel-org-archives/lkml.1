Return-Path: <linux-kernel-owner+w=401wt.eu-S1754497AbYHIOmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbYHIOmf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 10:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753015AbYHIOm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 10:42:27 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:54905 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977AbYHIOm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 10:42:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	b=JxvPa+5Bx6QoJUgc6rXS3gZDugE+aX3Ax1W6bJYpf3mH419NW1SI6d2SVVuISBMBqpASm8pqFzudegTW1apBYG1UO84yXb3BjXKKdeFRzSQRNwVBkhGhDVMfvbYRaRB0;
Message-ID: <489DACCE.7050000@simon.arlott.org.uk>
Date: Sat, 09 Aug 2008 15:42:22 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.16 (X11/20080726)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: linux-pm@lists.linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] Tyan S2923-E suspend to ram fails to resume
References: <48977AF7.2070300@simon.arlott.org.uk>	<20080808071430.GA10370@ucw.cz> <21f16315cade48d9ecdc87a25b769b9f310fa112@8b5064a13e22126c1b9329f0dc35b8915774b7c3.invalid>
In-Reply-To: <21f16315cade48d9ecdc87a25b769b9f310fa112@8b5064a13e22126c1b9329f0dc35b8915774b7c3.invalid>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/08 12:20, Simon Arlott wrote:
> On Fri, August 8, 2008 08:14, Pavel Machek wrote:
>> On Mon 2008-08-04 22:56:07, Simon Arlott wrote:
>>> My system (Tyan S2923-E, dmesg attached) suspends ok in
>>> all pm_test modes, but it won't resume with pm_test
>>> "none".
>>>
>>> [    6.423515] mem full: hash matches
>>>
>>> When I press the power button, the port 80 display shows:
>>> FF D0 23 01 D0 ... DE
>>> (and again each time I press it)
>>>
>>> If I force it to turn off, then on again:
>>> FF D0 23 01 D0 ... FF D0 23 01 D0 ... (D2?) D3 00 01 D5
>>> D6 <normal boot>
>>>
>>> Any ideas? (onboard SAS is disabled, watchdog is
>>> disabled, everything else is enabled, PCI-E graphics
>>> card)
>>
>> Try verifying if it reaches assembly code under realmode/ ...

I've tried acpi_sleep=s3_beep, and this:

diff --git a/arch/x86/kernel/acpi/realmode/wakeup.S b/arch/x86/kernel/acpi/realmode/wakeup.S
index 3355973..50e50df 100644
--- a/arch/x86/kernel/acpi/realmode/wakeup.S
+++ b/arch/x86/kernel/acpi/realmode/wakeup.S
@@ -37,6 +37,11 @@ signature:	.long	0x51ee1111
	.code16
wakeup_code:
_start:
+	movb $0xC1, %al
+	outb %al, $0x80
+	cli
+	hlt
+
	cli
	cld


Which doesn't work either.

-- 
Simon Arlott

