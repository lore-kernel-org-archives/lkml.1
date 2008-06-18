Return-Path: <linux-kernel-owner+w=401wt.eu-S1760185AbYFRD1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760185AbYFRD1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 23:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759351AbYFRD0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 23:26:44 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:40566 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759329AbYFRD0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 23:26:42 -0400
Message-ID: <4858806D.3070009@garzik.org>
Date: Tue, 17 Jun 2008 23:26:37 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jay Cliburn <jacliburn@bellsouth.net>
CC: advantis@gmx.net, csnook@redhat.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RESEND] [PATCH] atl1: relax eeprom mac address error check
References: <20080612170454.3bc6f096@osprey.hogchain.net>
In-Reply-To: <20080612170454.3bc6f096@osprey.hogchain.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jay Cliburn wrote:
> From: Radu Cristescu <advantis@gmx.net>
> 
> The atl1 driver tries to determine the MAC address thusly:
> 
> 	- If an EEPROM exists, read the MAC address from EEPROM and
> 	  validate it.
> 	- If an EEPROM doesn't exist, try to read a MAC address from
> 	  SPI flash.
> 	- If that fails, try to read a MAC address directly from the
> 	  MAC Station Address register.
> 	- If that fails, assign a random MAC address provided by the
> 	  kernel.
> 
> We now have a report of a system fitted with an EEPROM containing all
> zeros where we expect the MAC address to be, and we currently handle
> this as an error condition.  Turns out, on this system the BIOS writes
> a valid MAC address to the NIC's MAC Station Address register, but we
> never try to read it because we return an error when we find the all-
> zeros address in EEPROM.
> 
> This patch relaxes the error check and continues looking for a MAC
> address even if it finds an illegal one in EEPROM.
> 
> Signed-off-by: Radu Cristescu <advantis@gmx.net>
> Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
> ---
>  drivers/net/atlx/atl1.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)

applied


