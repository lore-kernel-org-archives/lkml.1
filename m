Return-Path: <linux-kernel-owner+w=401wt.eu-S1755559AbZJ0A2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559AbZJ0A2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 20:28:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755491AbZJ0A2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 20:28:08 -0400
Received: from mail-yw0-f202.google.com ([209.85.211.202]:46392 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457AbZJ0A2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 20:28:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=LZbLQVLz/hEqAaGl8+/Ddu5GuZbBGiYw8J48pqKG2T7traHVLy8xgjMZMBnDoeOwVw
         FJsdEiToW/4eZRoy/zmv6e+3h571qYXOi+PQFsca9ui/FRQDtjl/d5dRJ/GxclQTIoeH
         +iAxC2iKFlcxEumns+CzjGLRKrU3GNNKmORKA=
Message-ID: <4AE63E98.6040600@gmail.com>
Date: Mon, 26 Oct 2009 18:28:08 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: What are these ATA exceptions trying to tell me? [2.6.26] System
   Events]
References: <20091026082350.GA23992@piper.oerlikon.madduck.net>
In-Reply-To: <20091026082350.GA23992@piper.oerlikon.madduck.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2009 02:23 AM, martin f krafft wrote:
> Dear folks,
>
> I have a quality and high performance, new rack-mounted system, but
> every now and then, the kernel spews a slew of messages like the
> following to syslog:
>
>    ata3: EH in SWNCQ mode,QC:qc_active 0x7FFF sactive 0x7FFF
>    ata3: SWNCQ:qc_active 0x1 defer_bits 0x7FFE last_issue_tag 0x0
>    dhfis 0x1 dmafis 0x0 sdbfis 0x0
>    ata3: ATA_REG 0x40 ERR_REG 0x0
>    ata3: tag : dhfis dmafis sdbfis sacitve
>    ata3: tag 0x0: 1 0 0 1
>    ata3.00: exception Emask 0x0 SAct 0x7fff SErr 0x0 action 0x6 frozen
>    ata3.00: cmd 61/18:00:4f:22:b3/00:00:05:00:00/40 tag 0 ncq 12288 out
>            res 40/00:01:01:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
>    ata3.00: status: { DRDY }
>    [...]
>    ata3: hard resetting link
>    ata3: SRST failed (errno=-19)
>    ata3: SATA link down (SStatus 0 SControl 300)
>    ata3: failed to recover some devices, retrying in 5 secs
>    ata3: hard resetting link
>    ata3: link is slow to respond, please be patient (ready=-19)
>    ata3: SRST failed (errno=-16)
>    ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>    ata3.00: configured for UDMA/133
>    ata3: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
>    ata3: hot plug
>    ata3.00: configured for UDMA/133
>    sd 2:0:0:0: [sdc] 1953525168 512-byte hardware sectors (1000205 MB)
>    sd 2:0:0:0: [sdc] Write Protect is off
>    sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
>    sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>    sd 2:0:0:0: [sdc] 1953525168 512-byte hardware sectors (1000205 MB)
>    sd 2:0:0:0: [sdc] Write Protect is off
>    sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
>    sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>
> This happens for ata[34], but never for ata[12].

The "SATA link down" part is really quite abnormal, it seems like the 
drive dropped off the SATA link. Rather suspicious of some kind of 
hardware problem..

Are the two sets of disks the same model?

>
> At the time of these messages, the the machine was not loaded. In
> particular, there was no SMART self-test running. I mention this
> because i have set smartd to short tests daily and extended tests
> weekly, and those only rarely complete:
>
>    # 1  Extended offline    Interrupted (host reset)      00%      4812         -
>    # 2  Short offline       Interrupted (host reset)      00%      4684         -
>
> while they run fine for ata[12].
>
> The chipset is nVidia MCP55. Am I dealing with a broken controller?
>
> Cheers,
>

