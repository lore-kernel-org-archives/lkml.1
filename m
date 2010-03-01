Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab0CASJu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 13:09:50 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46420 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751207Ab0CASJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 13:09:47 -0500
Date: Mon, 1 Mar 2010 18:13:01 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Govindraj.R" <govindraj.raja@ti.com>
Cc: "Greg KH" <greg@kroah.com>, linux-serial@vger.kernel.org,
       linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Kevin Hilman" <khilman@deeprootsystems.com>,
       "Tony Lindgren" <tony@atomide.com>, "Olof Johansson" <olof@lixom.net>
Subject: Re: [PATCH] serial: Add OMAP high-speed UART driver.
Message-ID: <20100301181301.08d67b03@lxorguk.ukuu.org.uk>
In-Reply-To: <41322.192.168.10.89.1267454612.squirrel@dbdmail.itg.ti.com>
References: <41322.192.168.10.89.1267454612.squirrel@dbdmail.itg.ti.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +		 213 = /dev/ttyO0		OMAP serial port 0
> +		 214 = /dev/ttyO1		OMAP serial port 1
> +		 215 = /dev/ttyO2		OMAP serial port 2
> +		 216 = /dev/ttyO3		OMAP serial port 3

I think it might be best to allocate a dynamic tty major nowdays

Other problem is that I don't see where you hold the port lock over all
uses of port->tty. That is an assumption of the serial layer and done in
the original 8250 driver correctly.

Rest looks good and I agree that OMAP is different enough from 8250 that
it makes sense not to further clutter the 8250 driver.

