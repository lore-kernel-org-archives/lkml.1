Return-Path: <linux-kernel-owner+w=401wt.eu-S1763069AbZLQGZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763069AbZLQGZX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 01:25:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762028AbZLQGZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 01:25:16 -0500
Received: from mail-gx0-f211.google.com ([209.85.217.211]:33983 "EHLO
	mail-gx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761806AbZLQGZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 01:25:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=kKY0uEskyED7oE8ckV17E+/eDwTTq8dllmrxqwz7QfbRLT6nG6FnhA6CuelX1iaYip
         XiEZABT/zfCbqZgA7yiZSdjUUWbJKanPIQ0VcnTJpDbZzXj0Z4Vwi4V2IVlnkMUCooGX
         IXAlRdXjoyaOikTZkokpqSR8+yhAzg9CFMdVI=
Message-ID: <4B29CEC6.5010705@pobox.com>
Date: Thu, 17 Dec 2009 01:25:10 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
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

On 12/14/2009 03:51 PM, Alexander Strakh wrote:
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

pointless null test removed...


