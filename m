Return-Path: <linux-kernel-owner+w=401wt.eu-S1753226AbZHPRCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbZHPRCy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 13:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbZHPRCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 13:02:53 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:53326 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbZHPRCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 13:02:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=nwMVOZHixLKMzUyMyzciRMemtNSIwaj0KWhdhG0jjaZ6pG+whEc/P5DcjQomuKdA55
         FCvIywaNAZod6SUtLKdbnCz51FG0+prlDXPYGUuM8O1ow+9vD8OUegZNkC9EuSsnYOsl
         bRrSNz8QosAosdclcxheaSS3hIcEgvZbGfCJY=
Message-ID: <4A883A1A.9040009@gmail.com>
Date: Sun, 16 Aug 2009 10:55:54 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: "Subbrathnam, Swaminathan" <swami.iyer@ti.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: sata AHCI controller over non-PCI bus
References: <FCCFB4CDC6E5564B9182F639FC35608702F5989152@dbde02.ent.ti.com> <4A7FE245.8020002@ru.mvista.com> <FCCFB4CDC6E5564B9182F639FC35608702F59891CB@dbde02.ent.ti.com> <4A88014D.9060309@garzik.org>
In-Reply-To: <4A88014D.9060309@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2009 06:53 AM, Jeff Garzik wrote:
> Subbrathnam, Swaminathan wrote:
>> Jeff,
>> From the below link (from Sergei) it seems that you have already
>> re-factored the AHCI implementation dependency on PCI. I would like to
>> add support for the OMAPL138 SATA on top of your changes. That would
>> be the ideal way forward for me.
>>
>> Have the ahci re-factoring changes queued for mainline merge already?
>> I just joined the list and hence do not know the status.
>>
>> Sergei,
>> Appreciate the response.
>
> I store the refactoring in git, on the "libahci" branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
>
> Unfortunately, I am having second thoughts about an element of the
> current design. With current Linux distributions, they do not appear to
> deal well with the multi-module dependency libata -> libahci -> ahci. If
> I had to guess, I would say that mkinitrd creation tools only look at
> one tree level's worth of kernel module dependencies.
>
> Thus, ahci would wind up -not- in initrd, in a libahci solution.
>
> I am thinking that I will just add Marvell and ATP support to ahci.c,
> and let someone else deal with libahci separation -- which is still needed.
>
> At this point, I would rather get Marvell/ATP support into users' hands,
> rather than wait for distros to catch up to modern technology.

If that's the case it seems clearly a mkinitrd bug. What distribution 
were you seeing this behavior on?
