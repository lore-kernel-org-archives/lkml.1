Return-Path: <linux-kernel-owner+w=401wt.eu-S1751262AbXCGMXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751262AbXCGMXn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 07:23:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233AbXCGMXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 07:23:43 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:9699 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbXCGMXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 07:23:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iOJZKPK1OH4OwkZ9eTs6CaPeMRunG6OBBH5TFc3U71c4VkE73HqWtlGd6HzggpcilQi0iQom6q5u00WG/84H3+dT+3KZkTHfgcH8u62S2APLZ4cPON/x/kgqD6kSy6lwSyfDBsIjbBml9BcG719nWIkI2yf6hlVZ61DV/fgGw0M=
Message-ID: <5767b9100703070423y194bf492wad28ddc66ab98775@mail.gmail.com>
Date: Wed, 7 Mar 2007 20:23:39 +0800
From: "Conke Hu" <conke.hu@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>, Alan <alan@lxorguk.ukuu.org.uk>,
       "Tejun Heo" <htejun@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] ATAPI command TEST_UNIT_READY never succeeds!
In-Reply-To: <5767b9100703070409o3e094420rf7ccffc436332184@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5767b9100703070409o3e094420rf7ccffc436332184@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/7/07, Conke Hu <conke.hu@gmail.com> wrote:
> Hi,
>     Do you ever noticed that the ATAPI command TEST_UNIT_READY always
> fails to execute !?
>     I debugged in the following environments:
>         piix + Intel ICH6/ICH7 PATA
>         atiixp + ATI SB600 PATA
>         libata + ata_piix + Intel ICH6/ICH7 PATA
>         libata + sata_sil24 + Silicon Image 3132
>         libata + ahci + ATI SB600 SATA
>         libata + ahci + Intel AHCI
>     but none of them can execute TEST_UNIT_READY command successfully.
>     For example, in ahci driver, ahci_interrupt() reads port status as
> 0x4000_0000, which indicates an taskfile error.
 ~~~~~~~~~~~~~~~~~~

0x4000_0001, not 0x4000_0000, sorry.

more precisely speaking, ahci_host_intr() reads PORT_IRQ_STAT as
0x4000_0001, not the  expected 0x0000_0001.

Conke
