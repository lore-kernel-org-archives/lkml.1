Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab0CBVeq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 16:34:46 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:48482 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab0CBVep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 16:34:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=q92ULJFxeNoNMG0G9AjLwDVqh1n9FiCOszVH0HvvwS6nBj/lrHeeM4pau6o8eOGPlC
         Jz3DlFG8l4xqQVZmOiXEtp399pyCjXHWSk+I8bFtu/jiaKqGT3JbQBz5ciuA+oKia+is
         h7czF9xkIUgCYnI6CloFaHk8zpQom0SS4mqyY=
Message-ID: <4B8D846F.3080400@garzik.org>
Date: Tue, 02 Mar 2010 16:34:39 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: avorontsov@ru.mvista.com
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 0/12] ahci: Add support for non-PCI devices
References: <20100302182850.GA32057@oksana.dev.rtsoft.ru>
In-Reply-To: <20100302182850.GA32057@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2010 01:28 PM, Anton Vorontsov wrote:
> Hi all,
>
> This patch set refactors AHCI code to make it more generic, plus
> adds a new platform driver to support AHCI interfaces integrated
> into System-On-Chip devices.
>
> The patches should apply on top of v2.6.33 (soon will be rebased
> on top of linux-next).
>
> I don't have any PCI AHCI handy (yet, but I plan to find one), so
> PCI AHCI was only compile-tested.

As demonstrated in libata-dev.git#libahci, I think the best route is to 
move generic code into libahci.  In #libahci you will see

	libahci -> common code
	ahci -> standard PCI driver, req's libahci
	mv-ahci -> Marvell AHCI driver, req's libahci
	acard-ahci -> ACard AHCI driver, req's libahci

and to this we could easily add

	platform-ahci -> platform AHCI driver, req's libahci

WARNING:  #libahci should not be used directly, it is meant for 
illustration purposes only.  It has not been properly updated for 
several recent ahci.c changes upstream, which implies that the 
trivial-and-obvious task of moving generic code from ahci.c to libahci.c 
must be redone.

	Jeff



P.S.  Please use the email addresses in MAINTAINERS,

	M:      Jeff Garzik <jgarzik@pobox.com>
	L:      linux-ide@vger.kernel.org

The redhat.com email address is only used for legal (sign-off) purposes, 
not normal use.

