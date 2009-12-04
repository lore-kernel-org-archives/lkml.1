Return-Path: <linux-kernel-owner+w=401wt.eu-S1755081AbZLDADN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081AbZLDADN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 19:03:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754554AbZLDADM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 19:03:12 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38362
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753080AbZLDADL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 19:03:11 -0500
Date: Thu, 03 Dec 2009 16:03:18 -0800 (PST)
Message-Id: <20091203.160318.62214993.davem@davemloft.net>
To: Tristram.Ha@Micrel.Com
Cc: ben@simtec.co.uk, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.32 2/3] net: Fix ks8851 snl transmit problem
From: David Miller <davem@davemloft.net>
In-Reply-To: <14385191E87B904DBD836449AA30269D021A41@MORGANITE.micrel.com>
References: <14385191E87B904DBD836449AA30269D021A41@MORGANITE.micrel.com>
X-Mailer: Mew version 6.2 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ha, Tristram" <Tristram.Ha@Micrel.Com>
Date: Thu, 3 Dec 2009 13:17:48 -0800

> This fixes a transmit problem of the ks8851 snl network driver.  Under heavy TCP traffic the device will stop transmitting.  Turning off the transmit interrupt avoids this issue.  A new workqueue was implemented to replace the functionality of the transmit interrupt processing.
> 
> Signed-off-by: Tristram Ha <Tristram.Ha@micrel.com>

Please describe why the TX interrupt facility cannot be used.
You probably have a race condition or similar, have you tried
to see if there is some issue like that?

This workqueue is going to make performance terrible, at best.
