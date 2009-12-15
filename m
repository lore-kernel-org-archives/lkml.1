Return-Path: <linux-kernel-owner+w=401wt.eu-S1754065AbZLOBez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbZLOBez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 20:34:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbZLOBey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 20:34:54 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:58191 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbZLOBex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 20:34:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=wHOS3HwM/eeUTkuUEnBQ57I3Fspl9i4slkI82C0/vAnFjxR3Yhc9VfRwj3pLFuWpIk
         lx1EjbaAjvVFTCSrVFV2N9mTIZLjwj8yXCnOVrFp7gGyqZMgFmofXjL6K5BClbC7VCr7
         cBzG6ilUP8Mna95wIYrqSbVjl8bCmcyFqVByk=
Message-ID: <4B26E7B9.3070103@gmail.com>
Date: Mon, 14 Dec 2009 19:34:49 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Alexander Strakh <strakh@ispras.ru>
CC: Mark Lord <mlord@pobox.com>, linux-ide@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: BUG null dereference in drivers/ata/sata_mv.c
References: <200912142051.34029.strakh@ispras.ru>
In-Reply-To: <200912142051.34029.strakh@ispras.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2009 02:51 PM, Alexander Strakh wrote:
> 	KERNEL_VERSION: 2.6.32
> 	SUBJECT: null dereference in function mv_unexpected_intr
> 	DESCRIBE:
> 	In ./drivers/ata/sata_mv.c in function mv_port_intr
>
> 1. If ap == NULL in line 2778, then we goto line 2779.
> 2. In line 2779 function mv_unexpected_intr(ap, 0) is called.
> 3. In line 2538 null dereference: "ap->link.eh_info"
>
> 2773 static void mv_port_intr(struct ata_port *ap, u32 port_cause)
> 2774 {
> ...
> 2778         if (!ap || (ap->flags&  ATA_FLAG_DISABLED)) {
> 2779                 mv_unexpected_intr(ap, 0);
> 2780                 return;
> 2781         }
> ...
> 2809 }
>
> 2536 static void mv_unexpected_intr(struct ata_port *ap, int edma_was_enabled)
> 2537 {
> 2538         struct ata_eh_info *ehi =&ap->link.eh_info;
> ...
> 2555 }
>
> Found by Linux Device Drivers Verification Project (Svace Detector)

I don't think it should be possible for ap to be null at the point the 
check is made. The null check could likely be removed.
