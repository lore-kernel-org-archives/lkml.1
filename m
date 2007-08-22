Return-Path: <linux-kernel-owner+w=401wt.eu-S964815AbXHVWh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964815AbXHVWh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 18:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932453AbXHVWhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 18:37:14 -0400
Received: from web38904.mail.mud.yahoo.com ([209.191.125.110]:45607 "HELO
	web38904.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1763434AbXHVWhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 18:37:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=G8SBtyzPB+AajtuT8s+l0tveAXd7trQT7BuhqkWyaYrDLbFHrqnngMs+eNWdN3sUZzdUEkbM2Fr3e0fMwSTyHL0uDVHqbcChJ8Ucv/I45tXM2j5ii88wK/s/ARXTC6EGwznj7apT6Ix/RmaoOF8nKQqRAKFS24ZtFNJlGRXfR+E=;
X-YMail-OSG: Cz.JAccVM1nK5w68zJWAr4HBG8Uxf.9DC5vrkXqQztaniq.bQpuyNHNof0zrmA8Y.UJEleFhTX71pfBARy9tQbx1xC0QH4Im0A_dzyRXHl0mJWF2i1Q-
Date: Wed, 22 Aug 2007 15:37:09 -0700 (PDT)
From: Kevin E <kevin360@yahoo.com>
Subject: Re: [RFT] sky2: yukon-ec-u phy power problems
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <20070821100713.2867dce3@freepuppy.rosehill.hemminger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <314260.5533.qm@web38904.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Stephen Hemminger
<shemminger@linux-foundation.org> wrote:

> The sky2 driver clears some bits in the PHY control
> register, that cause
> the PHY interface to get changed.  Some of these
> deal with voltage and power
> savings as well. This may explain some of the
> failures on Gigabyte DS-3 motherboard.
> 
> The clue to possible problem was looking at why
> loading/unloading sky2 would
> break vendor sk98lin driver (ie what registers
> changed).
> 
> 
> --- a/drivers/net/sky2.c	2007-08-21
> 09:53:41.000000000 -0700
> +++ b/drivers/net/sky2.c	2007-08-21
> 09:53:43.000000000 -0700
> @@ -696,8 +696,8 @@ static void sky2_mac_init(struct
> sky2_hw
>  	int i;
>  	const u8 *addr = hw->dev[port]->dev_addr;
>  
> -	sky2_write32(hw, SK_REG(port, GPHY_CTRL),
> GPC_RST_SET);
> -	sky2_write32(hw, SK_REG(port, GPHY_CTRL),
> GPC_RST_CLR);
> +	sky2_write8(hw, SK_REG(port, GPHY_CTRL),
> GPC_RST_SET);
> +	sky2_write8(hw, SK_REG(port, GPHY_CTRL),
> GPC_RST_CLR);
>  
>  	sky2_write8(hw, SK_REG(port, GMAC_CTRL),
> GMC_RST_CLR);
>  

This appears to have fixed the problem!  I made the
change to the kernel on the broken MB and the link
stayed up.  So I went ahead and made the change to the
kernel on the working one too.   Right now I'm using
netcat to saturate the link and make sure it stays up.
 So far it's looking good, if I have any problems I'll
let you know.

Thanks,
Kevin



       
____________________________________________________________________________________
Building a website is a piece of cake. Yahoo! Small Business gives you all the tools to get online.
http://smallbusiness.yahoo.com/webhosting 
