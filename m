Return-Path: <linux-kernel-owner+w=401wt.eu-S1762114AbXKMXrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762114AbXKMXrK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 18:47:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760145AbXKMXqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 18:46:47 -0500
Received: from az33egw01.freescale.net ([192.88.158.102]:48713 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759821AbXKMXqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 18:46:46 -0500
Message-ID: <473A3760.2090807@freescale.com>
Date: Tue, 13 Nov 2007 17:46:40 -0600
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: Jochen Friedrich <jochen@scram.de>
CC: "linuxppc-embedded@ozlabs.org" <linuxppc-embedded@ozlabs.org>,
       linux-kernel@vger.kernel.org, paulus@samba.org
Subject: Re: [PATCH] powerpc: Add support for PORTA and PORTB odr registers
References: <4739ECDA.4010200@scram.de>
In-Reply-To: <4739ECDA.4010200@scram.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jochen Friedrich wrote:
> @@ -474,6 +481,12 @@ static void cpm1_set_pin16(int port, int pin, int 
> flags)
>     else
>         clrbits16(&iop->par, pin);
> 
> +    if (port == CPM_PORTA) {
> +        if (flags & CPM_PIN_OPENDRAIN)
> +            setbits16(&iop->odr, pin);
> +        else
> +            clrbits16(&iop->odr, pin);
> +    }
>     if (port == CPM_PORTC) {
>         if (flags & CPM_PIN_SECONDARY)
>             setbits16(&iop->sor, pin);

Where is the odr field of cpm_ioport16 defined?  It's the same position 
as sor, so maybe call it odr_sor or something.

Also, please add an extra newline after the closing brace.

-Scott
