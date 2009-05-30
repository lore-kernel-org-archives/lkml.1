Return-Path: <linux-kernel-owner+w=401wt.eu-S1753798AbZE3WQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbZE3WQU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 18:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbZE3WQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 18:16:14 -0400
Received: from cs20.apochromatic.org ([204.152.189.161]:60580 "EHLO
	cs20.apochromatic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbZE3WQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 18:16:13 -0400
Date: Sat, 30 May 2009 23:16:13 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Wolfgang =?iso-8859-1?Q?M=FCes?= <wolfgang.mues@auerswald.de>
Cc: Pierre Ossman <pierre@ossman.eu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc_spi: do propper retry managment in the block layer
	- 3rd try
Message-ID: <20090530221613.GA642@console-pimps.org>
References: <20090528091924.GB1860@console-pimps.org> <200905281152.26191.wolfgang.mues@auerswald.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200905281152.26191.wolfgang.mues@auerswald.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 11:52:26AM +0200, Wolfgang Mües wrote:
> 
> So somewhere I will need to have an error code filter based on the issued 
> command (class). Should this be in the driver(s)? Or should it be at the 
> location of the caller, in block.c?
> 

It should be in the function/file that makes the most sense.

> The advantages of putting it in block.c is that
> a) The command (class) is typically implicit given in the function, and no 
> need for a switch() statement.
> b) Only one handling for different drivers, not scattered through all(?) host 
> drivers.
> 

You know what, I was going to say that only block transaction stuff is
in block.c, but that's not true, there's loads of MMC protocol
knowledge in there too. I don't think there's a better place than
mmc/drivers/card/block.c, currently.

I would expect all this error handling and intimate knowledge of the
MMC/SD protocol to be in drivers/mmc/core, but that's not the
case. Which just seems strange to me.

> I must admit that I have difficulties to see a clear layering violation.
> There is no clear definition of which error codes should be reported to the 
> block layer. There is only a short list of codes with special meaning, but 
> not a full list of all used codes.
> 
> And some drivers are reporting codes like ENOMEM etc...
> 
> I see that Pierre wants to have a more smaller interface between drivers and 
> the upper layer, reporting only classes of errors, to have a more smaller and 
> cleaner code in the upper layer. But I think that this is a patch of its own, 
> and not in the context of the retry patch.
> 

I agree. That could be a separate patch.
