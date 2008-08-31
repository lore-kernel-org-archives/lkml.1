Return-Path: <linux-kernel-owner+w=401wt.eu-S1755529AbYHaXOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbYHaXOc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 19:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbYHaXOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 19:14:23 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:5944 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751091AbYHaXOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 19:14:23 -0400
Date: Mon, 1 Sep 2008 03:14:19 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power-supply: Add function to return system-wide power
	state
Message-ID: <20080831231419.GA31902@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080826200849.GA26114@srcf.ucam.org> <20080826200959.GB26114@srcf.ucam.org> <20080826202542.GA10090@oksana.dev.rtsoft.ru> <20080826203327.GA26691@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20080826203327.GA26691@srcf.ucam.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 09:33:27PM +0100, Matthew Garrett wrote:
> Something like this?

I just applied it to battery-2.6.git with the following changes:

[...]
> +int power_supply_is_system_supplied()

-()
+(void)

[...]
> +#ifdef CONFIG_POWER_SUPPLY

Added || defined(CONFIG_POWER_SUPPLY_MODULE)

> +extern int power_supply_is_system_supplied(void);
> +#else
> +static int power_supply_is_system_supplied(void) { return -ENOSYS; }

Added inline keyword, otherwise gcc might warn about defined but
not used function.


Please test battery-2.6.git tree (or simply next `-next` tree ;-)
if everything is okay.

Thanks again!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
