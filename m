Return-Path: <linux-kernel-owner+w=401wt.eu-S1755588AbZHLCPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588AbZHLCPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 22:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755532AbZHLCPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 22:15:49 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:58085 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523AbZHLCPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 22:15:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:references:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:message-id;
        b=bxMqXYRHqhR6X/+mzPcg9sJbw85S5OwrY1B9wOPcSyqvoWtJYiw7ApUKPARg4ilpUm
         fNPNwyz58vUpYmYEVVBG2hte24V6YnUZN2VhMcKYTOR4Re9rWIOR9AyDUJ23DW7MUwkw
         T3lt2npScaV5HWn/5e/XgiQ9pLrwMIF2Crvgg=
Date: Tue, 11 Aug 2009 19:15:45 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Xiangfu Liu <xiangfu@qi-hardware.com>
Cc: "Hard- and Software Development, Kernel, Distribution, Roadmap" 
	<developer@lists.qi-hardware.com>,
       linux-kernel@vger.kernel.org
Subject: Re: qi_lb60_keypad driver question?
References: <4A819D39.2040006@qi-hardware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A819D39.2040006@qi-hardware.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Message-Id: <20090812024620.E4E10526EC9@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Aug 12, 2009 at 12:32:57AM +0800, Xiangfu Liu wrote:
> Hi there
> I have try to write the keypad driver,
> but I don't know if this is the right direction.

These kind of questions are better suited for teh linux-input mailing
list.

> attach is the patch for the openwrt[1] .25 kernel.
> 

Which is not telling most of the people anything. For example I have no
idea whta .25 kernel is.

> diff --git a/drivers/input/keyboard/matrix_keypad.c b/drivers/input/keyboard/matrix_keypad.c
> new file mode 100644
> index 0000000..a51273e
> --- /dev/null
> +++ b/drivers/input/keyboard/matrix_keypad.c
> @@ -0,0 +1,347 @@
> +/*
> + * drivers/input/keyboard/matrix_keypad.c
> + *
> + *  GPIO driven matrix keyboard driver
> + *

There is already an updated version of matrix_keypad driver in mainline,
you don't need to repost it.

> diff --git a/drivers/input/keyboard/qi_lb60_keypad.c b/drivers/input/keyboard/qi_lb60_keypad.c
> new file mode 100644
> index 0000000..0b2e548
> --- /dev/null
> +++ b/drivers/input/keyboard/qi_lb60_keypad.c

This should go into arch specific board setup code, not in drivers/input

> +
> +static struct platform_device qi_lb60_device = {
> +	.name		= "qi_lb60-keyboard",
> +	.name		= "matrix-keypad",

You are setting .name twice. Also, statically allocated platform devices
may not be unregistered. Just create this device once in your board init
code instead of having a separate unloadable module.

-- 
Dmitry
