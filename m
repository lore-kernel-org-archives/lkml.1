Return-Path: <linux-kernel-owner+w=401wt.eu-S1754754AbZDUHjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbZDUHjU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 03:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751777AbZDUHjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 03:39:09 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:58984 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751056AbZDUHjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 03:39:08 -0400
X-Sasl-enc: zMEqsUekMUyp0wumrBthtioaeGm7lTuuS77IpwVqBnxS 1240299545
Message-ID: <49ED781F.2000802@ladisch.de>
Date: Tue, 21 Apr 2009 09:39:11 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] go7007: Convert to the new i2c device binding model
References: <20090420194237.52630423@hyperion.delvare>
In-Reply-To: <20090420194237.52630423@hyperion.delvare>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> I am puzzled by the s2250 I2C address, 0x86 really doesn't fit in
> 7 bits, there must be something wrong.

> -				.addr	= 0x34,
> +				.addr	= 0x86,	/* ?? */

> -#define S2250_VIDDEC        0x86

Many I2C controllers use an 8-bit address register, with the lowest bit
being the read/write bit (because this is the order in which the bits
are transmitted over the bus).  So it looks as if the actual address
_is_ 0x34; the S2250_VIDDEC symbol is probably a relict of the old
driver that programmed the I2C controller directly.


Best regards,
Clemens
