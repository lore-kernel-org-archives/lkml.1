Return-Path: <linux-kernel-owner+w=401wt.eu-S1762065AbZLJWzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762065AbZLJWzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 17:55:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762048AbZLJWzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 17:55:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45345 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762005AbZLJWzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 17:55:20 -0500
Message-ID: <4B217C0E.9040801@zytor.com>
Date: Thu, 10 Dec 2009 14:54:06 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: Bisected regression (Was Re: current -git fails to boot on	nehalem-ex)
References: <20091210091040.GG8742@kernel.dk> <20091210103945.GI8742@kernel.dk> <20091210160640.GB27794@elte.hu> <67EA4830-231F-45C9-A1A6-CE1C6CD9493D@kernel.org> <20091210180727.GK8742@kernel.dk> <4B213F1F.2020305@kernel.org> <4B2140F8.3020201@kernel.org> <20091210184506.GP8742@kernel.dk> <20091210190742.GS8742@kernel.dk> <4B2149B4.9060900@kernel.org> <20091210192659.GV8742@kernel.dk> <4B21630A.6000308@kernel.org> <4B21789F.4030707@zytor.com> <4B2179FC.6090305@kernel.org>
In-Reply-To: <4B2179FC.6090305@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2009 02:45 PM, Yinghai Lu wrote:
> H. Peter Anvin wrote:
>> On 12/10/2009 01:07 PM, Yinghai Lu wrote:
>>> it turns out BIOS is using first 64k for mptable without reserve it.
>>>
>>> so try to find good range for it instead of hard code it.
>>> in case some bios try to use that range for sth.
>>>
>>
>> Is this an EFI BIOS?  Otherwise, the first 64K would be clobbered anyway
>> by the boot loader, so it is invalid anyway...  If it is EFI, it is
>> theoretically possible.
> 
> Jens said acpi=off works with 2.6.32.
> 
> can you specify the exact byte position that boot loader could touched?
> 

A legacy-BIOS boot loader will typically clobber all memory from 0x600
(in theory 0x501) up to the FBM point; a pointer to the FBM mark is
given by (*(uint16_t *)0x413) << 10.

	-hpa

