Return-Path: <linux-kernel-owner+w=401wt.eu-S1755720AbYB0PVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720AbYB0PVf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 10:21:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750766AbYB0PVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 10:21:25 -0500
Received: from senator.holtmann.net ([87.106.208.187]:40850 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbYB0PVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 10:21:24 -0500
Cc: Dave Young <hidave.darkstar@gmail.com>, linux-bluetooth@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>, bmidgley@gmail.com,
       David Miller <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>
Message-Id: <5D9353FF-6A69-4039-9033-C0EBD1CDA756@holtmann.org>
From: Marcel Holtmann <marcel@holtmann.org>
To: Louis JANG <louis@mizi.com>
In-Reply-To: <47C555E5.2000903@mizi.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: [Bluez-devel] forcing SCO connection patch
Date: Wed, 27 Feb 2008 16:21:14 +0100
References: <47666E1F.2000902@mizi.com>	 <a8e1da0802242330l765b8b1ava62b857baf8a5568@mail.gmail.com>	 <47C28A33.4070102@mizi.com> <a8e1da0802250155u1b7af481va203849f68d9106b@mail.gmail.com> <47C2A7FA.2060902@mizi.com> <70692DDF-93B7-447E-ABEE-3CDBD94F15F1@holtmann.org> <47C38D40.3040809@mizi.com> <B96BD3FE-F490-4AD5-9315-ECD42CE9C728@holtmann.org> <47C4C3D4.8010902@mizi.com> <2A7EF87C-1340-45D7-B457-F81799674B1E@holtmann.org> <47C555E5.2000903@mizi.com>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Louis,

> When bluez tried to connect SCO channel with  
> HCI_OP_SETUP_SYNC_CONN(ESCO_LINK),
> a real connection may be connected with SCO_LINK instead of  
> ESCO_LINK when
> peer device doesn't support eSCO.  however bluez try to find  
> connection handle
> by event's link type(SCO_LINK in above case) and the valid  
> connection handle
> for this event is waiting for ESCO_LINK. so bluez can't find  
> connection handle
> and discarded the event.

using HCI_OP_SETUP_SYNC_CONN doesn't mean eSCO. It is perfectly fine  
to request SCO links via that command. The difference here is  
Bluetooth 1.1 or 1.2 and later.

> This patch is to handle different type of synchronous link is  
> estabilished
> with its request.
>
> If bluez can't find connection handle, it try to find with different
> link type again. (For the above case, if bluez can't find connection
> handle with SCO_LINK, it try to find connection handle with  
> ESCO_LINK again.)
> and update link type of this connection handle with event's link type.

Inside the kernel it is not called BlueZ :) It simply is the Bluetooth  
subsystem and in case the HCI core.

Regards

Marcel

