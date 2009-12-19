Return-Path: <linux-kernel-owner+w=401wt.eu-S1752369AbZLSH3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369AbZLSH3i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 02:29:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbZLSH3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 02:29:37 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:63433 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbZLSH3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 02:29:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=iI9rMp4Q/aW983T8UVfJW2fEMuDcE4d85aB/FmdlvwJOe2wKKZHS6MTJWBYcX4bNxj
         n4ZD+HamoDXXxskakOgUeC5o588UM3+vmwkUny1v4ZIUHtKa45Tn2PqbQnSMoJXHaRVY
         WWA0UN8FvT+t/Fvv7zgdVemPe4mtmolaxqB2s=
Message-ID: <4B2C80DD.9080005@garzik.org>
Date: Sat, 19 Dec 2009 02:29:33 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Mike Cui <cuicui@gmail.com>
CC: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.32 seemed to have broken nVidia MCP7A sata controller
References: <7c8826910912182213o2e0e8af7ic305f150c52e0618@mail.gmail.com>
In-Reply-To: <7c8826910912182213o2e0e8af7ic305f150c52e0618@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2009 01:13 AM, Mike Cui wrote:
> I have an nVidia MCP7A AHCI controller. I upgraded to 2.6.32.2 and my
> system deterministically freezes trying to mount file systems. Once in
> a while it will come back and finish booting after freezing for 1
> minute or 2. dmesg indicates that there were NCQ errors, but 2.6.31
> anb before has always worked flawlessly for me. What changed in
> 2.6.32? I will be more than happy to help track down this issue.

> ata1.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x6 frozen
> ata1.00: cmd 61/08:00:4f:ad:03/00:00:00:00:00/40 tag 0 ncq 4096 out
>           res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata1: hard resetting link
> ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata1.00: configured for UDMA/133
> ata1.00: device reported invalid CHS sector 0

Looks like things are timing out, and then go downhill from there.  This 
explanation of timeout gives some hints on possible causes: 
http://ata.wiki.kernel.org/index.php/Libata_error_messages#Error_classes

The ideal would be if you could bisect between 2.6.31 and 2.6.32, to see 
if it's a software change that is the cause.

Looking at drivers/ata/ahci.c history, the only thing that -might- cause 
problems is 388539f3ff0cf1de926b03f94e1eec112358f74d ('git show $commit' 
for full commit info and diff).

	Jeff


