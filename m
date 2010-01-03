Return-Path: <linux-kernel-owner+w=401wt.eu-S1753148Ab0ACW61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148Ab0ACW61 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 17:58:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753123Ab0ACW61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 17:58:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:40555 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753068Ab0ACW60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 17:58:26 -0500
Message-ID: <4B41216F.4070906@kernel.org>
Date: Mon, 04 Jan 2010 07:59:59 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Johannes Stezenbach <js@sig21.net>
CC: Hans Werner <HWerner4@gmx.de>, linux-kernel@vger.kernel.org, trenn@suse.de,
       mmalygin@ked.de, hancockrwd@gmail.com, greg@kroah.com
Subject: Re: Samsung N130 ATA exception after 5min uptime -- Phoenix FailSafe
 issue?
References: <20091230120428.5780@gmx.net> <20100103221142.GA16783@sig21.net>
In-Reply-To: <20100103221142.GA16783@sig21.net>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 01/04/2010 07:11 AM, Johannes Stezenbach wrote:
> On Wed, Dec 30, 2009 at 01:04:28PM +0100, Hans Werner wrote:
>>
>> testing in the Arch Linux Forums has shown that if one applies
>> a patch which you posted to the linux-ide ML on 2008-11-21
>> then the problem is no longer seen. Instead the kernel log shows
>> that a spurious IRQ was cleared.
>>
>> [PATCH #upstraem-fixes] ata_piix: detect and clear spurious IRQs
>> http://marc.info/?l=linux-ide&m=122724081603679&w=2
>> http://bbs.archlinux.org/viewtopic.php?id=86454
>>
>> What's the current status of this patch? Is it safe to use?
>> What does it tell us about the Samsung N130/140?
> 
> FWIW, I just tested a current git kernel (v2.6.33-rc2-268-g45d28b0)
> with Tejun's patch applied on my N130.  The ATA exception and hang is
> indeed gone, just "ata1: clearing spurious IRQ" is logged.
> 
> I've see Tejun's comment in
> http://bugzilla.kernel.org/show_bug.cgi?id=14314
> and I would like to add that the ATA irq is not shared.
> 
>  14:      43885          0   IO-APIC-edge      ata_piix
>  15:          0          0   IO-APIC-edge      ata_piix

Can you please post that on bug#14314?  If the IRQ line indeed wasn't
shared, it might mean that the controller raised the IRQ line before
getting its internal state in order and the IRQ checking sequence
cleared the external IRQ status while leaving the internal pending bit
intact, which I've never heard of on piix and don't think is possible.
Hmmmm... given that the problem was dependent on BIOS on the other
model (is it the N130?), maybe the BIOS is doing something funny.  :-(
Anyways, please post full output of "cat /proc/interrupts" at the bz.

Thanks.

-- 
tejun
