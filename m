Return-Path: <linux-kernel-owner+w=401wt.eu-S1752830Ab0AUGtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab0AUGtF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 01:49:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750Ab0AUGtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 01:49:04 -0500
Received: from mail-yw0-f198.google.com ([209.85.211.198]:61209 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713Ab0AUGtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 01:49:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=HOAraQ8EcS6fLbjIzbnv54UUWRIzotnlBOufH6M/kx09k3FiYaQW6KHYWnnRzs0jZs
         /5sX4nghl7IIUbvIs3ReTuoy2iYXQfOCrokenkplSsGBC/+IR8ULkAFKnNETJ9l99P5I
         DMMvGxlPXxSgjLK7mUaSkcyGxymevl1ECZtMM=
Message-ID: <4B57F8D6.6080902@garzik.org>
Date: Thu, 21 Jan 2010 01:48:54 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Krzysztof Halasa <khc@pm.waw.pl>
CC: linux-ide@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: SATA_SIL on IXP425 workaround
References: <m33a4nfvva.fsf@intrepid.localdomain> <201001141659.19687.bzolnier@gmail.com> <4B57DEE9.8030604@garzik.org>
In-Reply-To: <4B57DEE9.8030604@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2010 11:58 PM, Jeff Garzik wrote:
> On 01/14/2010 10:59 AM, Bartlomiej Zolnierkiewicz wrote:
>> On Monday 09 November 2009 06:31:21 pm Krzysztof Halasa wrote:
>>> I'm trying to add a workaround for IXP4xx CPUs to SATA SIL driver. The
>>> problem is that IXP4xx CPUs (Intel's XScale (ARM) network-oriented
>>> processors) are unable to perform 8 and 16-bit read from PCI MMIO, they
>>> can only do a full 32-bit readl(); SIL chips respond to that with PCI
>>> abort. The workaround is to use 8 and 16-bit regular IO reads (inb/inw)
>>> instead (MMIO write is not a problem).
>>>
>>> For SIL3x12 the workaround is simple (attached) and it works on my 3512.
>>> I'm not sure about 3114 (the 4-port chip) - the PIO BARs have TF, CTL
>>> and BWDMA registers which are common to channels 0 and 2, and (the other
>>> set) to channels 1 and 3. Channel selection is done with bit 4 of
>>> device/head TF register, this is similar (same?) as PATA master/slave.
>>> Does that mean that I can simply treat channel 0 as PRI master, ch#2 as
>>> PRI slave, ch#1 as SEC master and ch#3 as SEC slave, and the SFF code
>>> will select the right device correctly? Does it need additional code?
>>> I don't have anything based on 3114.
>>>
>>> Note: the large PRD is not a problem here, the transfer can be started
>>> by MMIO write. Only reads are an issue.
>>
>> FWIW your patch is now in my atang tree (I'm aware that Jeff is working
>> on generic solution but in the meantime this non-intrusive patch allows
>> sata_sil to work on IXP425).
>
> I was asking an open question, is a generic solution possible?
>
> Something like the attached patch might work, due it is completely
> untested, and I did not verify that the BMDMA Status register is not
> stomped. Also, the additional ioread32() calls in bmdma start/stop are
> LIKELY to be unnecessary.

As I suspected, there is a W1C register in there.  But it does look 
possible to do all-32-bit accesses.

	Jeff



