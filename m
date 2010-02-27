Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968147Ab0B0Jxd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 04:53:33 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38624
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968133Ab0B0Jxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 04:53:32 -0500
Date: Sat, 27 Feb 2010 01:53:50 -0800 (PST)
Message-Id: <20100227.015350.71138134.davem@davemloft.net>
To: hancockrwd@gmail.com
Cc: bzolnier@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [RFC PATCH] fix problems with NETIF_F_HIGHDMA in networking
 drivers
From: David Miller <davem@davemloft.net>
In-Reply-To: <51f3faa71002261908y7cfa62eeicb3e56d5c920887a@mail.gmail.com>
References: <51f3faa71002260646r705891e8tdbab1f6faeeb4b81@mail.gmail.com>
	<201002261625.24523.bzolnier@gmail.com>
	<51f3faa71002261908y7cfa62eeicb3e56d5c920887a@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Hancock <hancockrwd@gmail.com>
Date: Fri, 26 Feb 2010 21:08:04 -0600

> That seems like a reasonable approach to me. Only question is how to
> implement the check for DMA_64BIT. Can we just check page_to_phys on
> each of the pages in the skb to see if it's > 0xffffffff ? Are there
> any architectures where it's more complicated than that?

On almost every platform it's "more complicated than that".

This is the whole issue.  What matters is the final DMA address and
since we have IOMMUs and the like, it is absolutely not tenable to
solve this by checking physical address attributes.
