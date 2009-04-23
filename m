Return-Path: <linux-kernel-owner+w=401wt.eu-S1756449AbZDWOaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449AbZDWOaV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 10:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbZDWOaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 10:30:05 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:44148 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbZDWOaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 10:30:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=cKOqn3IQgbDuFBm+ckT+RPmv7B9pPIsm3m6BuwCZzleE1bqPY4Vn74j7KQ2Y56Va2g
         78tFTqpbiQDdMlMepW3vHZXAXLlq4CHWcBAxrYGxxkvcI96T0jU9umHFAAsc8k7gpC/z
         h3OUDA/BWaDfrBNal47CKWrQuHMN6U/kM+05U=
Message-ID: <49F07B69.1020305@gmail.com>
Date: Thu, 23 Apr 2009 16:30:01 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-8.3 Thunderbird/3.0b2
MIME-Version: 1.0
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, e1000-devel@lists.sourceforge.net,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [E1000-devel] e1000: "eeprom checksum is not valid" after kexec
References: <49F06EEB.9060500@gmail.com> <20090423141026.GB4046@vespa.holoscopio.com>
In-Reply-To: <20090423141026.GB4046@vespa.holoscopio.com>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2009 04:10 PM, Thadeu Lima de Souza Cascardo wrote:
> On Thu, Apr 23, 2009 at 03:36:43PM +0200, Jiri Slaby wrote:
>> Hi,
>>
>> 4a865905f685eaefaedf6ade362323dc52aa703b
>> (PCI PM: Make pci_set_power_state() handle devices with no PM support)
>> breaks e1000 after being kexec'ed. These reverts fix the problem:
>>     Revert "PCI PM: Make pci_set_power_state() handle devices with no PM
>> support"
>>     Revert "PCI PM: Introduce __pci_[start|complete]_power_transition()
>> (rev. 2)"
>>
>> I reverted the second one just for an easy revert of the former one,
>> which is actually the culprit.
>>
>> The symptoms:
>> e1000 0000:02:01.0: enabling device (0000 -> 0003)
>> e1000 0000:02:01.0: PCI INT A -> Link[LNKA] -> GSI 11 (level, low) -> IRQ 11
>> e1000 0000:02:01.0: setting latency timer to 64
>> e1000: 0000:02:01.0: e1000_probe: The EEPROM Checksum Is Not Valid
>> Switched to high resolution mode on CPU 0
> 
> Have you tried b43fcd7dc7b, found in v2.6.30-rc3?

I've tried 2.6.30-rc3-next-20090423 without success.
