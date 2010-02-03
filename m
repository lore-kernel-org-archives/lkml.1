Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932604Ab0BCQ5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 11:57:40 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55144 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932559Ab0BCQ5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 11:57:38 -0500
Date: Wed, 3 Feb 2010 08:56:18 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Michael Breuer <mbreuer@majjas.com>
Cc: Jarek Poplawski <jarkao2@gmail.com>, David Miller <davem@davemloft.net>,
       akpm@linux-foundation.org, flyboy@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Michael Chan <mchan@broadcom.com>, Don Fry <pcnet32@verizon.net>,
       Francois Romieu <romieu@fr.zoreil.com>,
       Matt Carlson <mcarlson@broadcom.com>
Subject: Re: [PATCH] sky2:  receive dma mapping error handling
Message-ID: <20100203085618.6662cc6f@nehalam>
In-Reply-To: <4B69A897.7030408@majjas.com>
References: <20100128223447.GC3109@del.dom.local>
	<4B621316.8070308@majjas.com>
	<20100128225621.GD3109@del.dom.local>
	<4B6216B9.1010802@majjas.com>
	<20100128153643.0fca3c51@nehalam>
	<4B645EF4.4050701@majjas.com>
	<20100131003449.GA11935@del.dom.local>
	<4B650D53.2010607@majjas.com>
	<4B65D0F9.2020602@majjas.com>
	<4B65FD12.7090101@majjas.com>
	<20100131221835.GA3317@del.dom.local>
	<20100201102018.7b597992@nehalam>
	<4B68F664.6050007@majjas.com>
	<4B69A897.7030408@majjas.com>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Feb 2010 11:47:19 -0500
Michael Breuer <mbreuer@majjas.com> wrote:

> Tracked this down. The status being returned is 0x3c0080 - good flow 
> control packets. Nothing is actually being dropped (confirmed by packet 
> trace on switch compared with packet trace on server).
> 
> I whipped up a trivial patch to not count these as dropped packets and 
> will post to netdev.
> 
> I'm not really sure what the driver should be doing in this case, but 
> resubmit seems to work.

Looks like a flow control negotiation issue. You probably turned off
flow control on the Linux side, but the switch is still doing flow
control.

-- 
