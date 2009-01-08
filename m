Return-Path: <linux-kernel-owner+w=401wt.eu-S1760658AbZAHTCH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760658AbZAHTCH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 14:02:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbZAHTBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 14:01:52 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:57046 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbZAHTBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 14:01:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=VCJWg5/j93I7zUlkT+ZKMHWVYmPimpoGGPZlDg+EjNY3Pbitx0YqjkYAiSBCDGDzXT
         MyJ8jlLANA2jXP8SeJWsDBYVZ0C7A13MYh9d60wx/f2RfOKbVB9g07YCv/V8fT8Qjgve
         1s/Oh8Cfw6rBz8kwiAnGZeWzvIGKbPgzsyGgk=
Message-ID: <8bd0f97a0901081101t6fdfa485rbd7ccc4e47691ddb@mail.gmail.com>
Date: Thu, 8 Jan 2009 14:01:49 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [PATCH 2/2] netdev: bfin_mac: enable VLAN support in Blackfin MAC driver
Cc: cooloney@kernel.org, jeff@garzik.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, graf.yang@analog.com
In-Reply-To: <20090108.105531.176161465.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1231344879-26069-1-git-send-email-cooloney@kernel.org>
	 <1231344879-26069-3-git-send-email-cooloney@kernel.org>
	 <20090108.105531.176161465.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 8, 2009 at 13:55, David Miller <davem@davemloft.net> wrote:
> From: Bryan Wu <cooloney@kernel.org>
>> +#define VLAN_ETHER_TYPE 0x8100
>
> Please use ETH_P_8021Q from linux/if_ether.h instead of inventing
> your own definition.

was a copy & paste due to not finding a better definition (3c59x.c)

>> +     /* The legal length of the frame is increased to 1538 bytes */
>> +     /*bfin_write_EMAC_VLAN2(VLAN_ETHER_TYPE);*/
>
> Please do not add code that is just going to be commented
> out and not used.
>
> Also, I disagree with the:
>
> +#if defined(CONFIG_VLAN_8021Q) || defined(CONFIG_VLAN_8021Q_MODULE)
>
> conditional.  Probably this part of the chip should be programmed
> unconditionally.

again, more of a copy & paste ... this is how a bunch of drivers are
doing it now ...

> We can get VLAN packets received and sent, using AF_PACKET
> sockets, for example.  The chip should still respect those
> even if VLAN proper is not being utilized.

any tips on doing that ?

thanks for reviewing!
-mike
