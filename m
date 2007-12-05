Return-Path: <linux-kernel-owner+w=401wt.eu-S1752753AbXLELl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753AbXLELl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 06:41:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751361AbXLELlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 06:41:52 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:38753 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbXLELlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 06:41:51 -0500
Date: Wed, 5 Dec 2007 12:41:50 +0100
From: Jan Kara <jack@suse.cz>
To: Daniel Drake <dsd@gentoo.org>
Cc: linux-kernel@vger.kernel.org, avuton@gmail.com, hancockr@shaw.ca,
       alan@lxorguk.ukuu.org.uk, andi@firstfloor.org, mrmacman_g4@mac.com,
       dean@arctic.org, argggh@dolphinics.no, jengelh@computergmbh.de,
       shdl@zakalwe.fi, vlobanov@speakeasy.net, drzeus-list@drzeus.cx,
       strange@nsk.no-ip.org, dm.n9107@gmail.com, johannes@sipsolutions.net
Subject: Re: [RFC v2] Documentation about unaligned memory access
Message-ID: <20071205114150.GA13654@atrey.karlin.mff.cuni.cz>
References: <20071129161523.E0C349D4B52@zog.reactivated.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071129161523.E0C349D4B52@zog.reactivated.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  A minor typo:

... 
> Avoiding unaligned accesses
> ===========================
> 
> The easiest way to avoid unaligned access is to use the get_unaligned() and
> put_unaligned() macros provided by the <asm/unaligned.h> header file.
> 
> Going back to an earlier example of code that potentially causes unaligned
> access:
> 
> 	void myfunc(u8 *data, u32 value)
> 	{
> 		[...]
> 		*((u32 *) data) = cpu_to_le32(value);
> 		[...]
> 	}
> 
> To avoid the unaligned memory access, you would rewrite it as follows:
> 
> 	void myfunc(u8 *data, u32 value)
> 	{
> 		[...]
> 		value = cpu_to_le32(value);
> 		put_unaligned(value, data);
> 		[...]
> 	}
> 
> The get_unaligned() macro works similarly. Assuming 'data' is a pointer to
> memory and you wish to avoid unaligned access, its usage is as follows:
> 
> 	u32 value = get_unaligned(data);
> 
> These macros work work for memory accesses of any length (not just 32 bits as
               ^^^^^^^^^
remove one of them :)

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
