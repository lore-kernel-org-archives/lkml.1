Return-Path: <linux-kernel-owner+w=401wt.eu-S1753866AbYKFXsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbYKFXsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 18:48:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbYKFXr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 18:47:56 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42624
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750978AbYKFXrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 18:47:55 -0500
Date: Thu, 06 Nov 2008 15:47:54 -0800 (PST)
Message-Id: <20081106.154754.02648408.davem@davemloft.net>
To: khc@pm.waw.pl
Cc: linux-kernel@vger.kernel.org, khali@linux-fr.org,
       linux-i2c@vger.kernel.org
Subject: Re: I2C from interrupt context?
From: David Miller <davem@davemloft.net>
In-Reply-To: <m3bpws8ln3.fsf@maximus.localdomain>
References: <m3bpws8ln3.fsf@maximus.localdomain>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Fri, 07 Nov 2008 00:44:48 +0100

[ Fixed i2c list address, it's now hosted at vger ]

> I'm updating my EEPROM console logger and have encountered a problem
> - the logger (as any console) can be called with hardware interrupts
> disabled and/or from interrupt context. It needs to write to I^2C
> (using ARM (Xscale) GPIO) and possibly SMBUS-only EEPROM chip. Is it
> at all supposed to be possible?

Not really.  The I2C operations need to be able to sleep and that's
not allowed in interrupt context.

