Return-Path: <linux-kernel-owner+w=401wt.eu-S1758106AbZDWNg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106AbZDWNg7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 09:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbZDWNgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 09:36:49 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:55880 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbZDWNgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 09:36:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=jvHLzl8vQbTRGg7rQBB2A0QRH39iIxsvUsl0SzHxiMSdY5BBepkkYRQKIy23mquH4g
         Vs785E7I/Wn0GS0WSBSpaQzdxgGsw4Z1Ekc8kGNRCfe4S7A7cQfflQHbH4A7S8rZ2lSU
         MsnD0961c/HIhXAj4BdGdkN6SlFTC6NIdm6/g=
Message-ID: <49F06EEB.9060500@gmail.com>
Date: Thu, 23 Apr 2009 15:36:43 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-8.3 Thunderbird/3.0b2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: e1000-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: e1000: "eeprom checksum is not valid" after kexec
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

4a865905f685eaefaedf6ade362323dc52aa703b
(PCI PM: Make pci_set_power_state() handle devices with no PM support)
breaks e1000 after being kexec'ed. These reverts fix the problem:
    Revert "PCI PM: Make pci_set_power_state() handle devices with no PM
support"
    Revert "PCI PM: Introduce __pci_[start|complete]_power_transition()
(rev. 2)"

I reverted the second one just for an easy revert of the former one,
which is actually the culprit.

The symptoms:
e1000 0000:02:01.0: enabling device (0000 -> 0003)
e1000 0000:02:01.0: PCI INT A -> Link[LNKA] -> GSI 11 (level, low) -> IRQ 11
e1000 0000:02:01.0: setting latency timer to 64
e1000: 0000:02:01.0: e1000_probe: The EEPROM Checksum Is Not Valid
Switched to high resolution mode on CPU 0
/*********************/
Current EEPROM Checksum : 0xffff
Calculated              : 0xbaf9
Offset    Values
========  ======
00000000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
00000010: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
00000020: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
00000030: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
00000040: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
00000050: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
00000060: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
00000070: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Include this output when contacting your support provider.
This is not a software error! Something bad happened to your hardware or
EEPROM image. Ignoring this problem could result in further problems,
possibly loss of data, corruption or system hangs!
The MAC Address will be reset to 00:00:00:00:00:00, which is invalid
and requires you to set the proper MAC address manually before continuing
to enable this network device.
Please inspect the EEPROM dump and report the issue to your hardware vendor
or Intel Customer Support.
/*********************/
e1000: 0000:02:01.0: e1000_probe: Invalid MAC Address
e1000: 0000:02:01.0: e1000_probe: (PCI-X:33MHz:64-bit) 00:00:00:00:00:00
