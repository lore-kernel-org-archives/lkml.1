Return-Path: <linux-kernel-owner+w=401wt.eu-S1754080AbYKVTTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbYKVTTq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 14:19:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751093AbYKVTTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 14:19:36 -0500
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:29473 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751004AbYKVTTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 14:19:35 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=6meAS3M8BH8gy2U/k+qVJNPBhYIvvlweIpLSdVQI0M33S25Hkjuc9Av3m9vLLpCmuGJn70060wuCuqBaSWr3N4NhO0wZJz8F+sHerU+xy+o2mKB+rvtsdshtv+BISCn7w2Z43D2bkjUVy+QCAcjP+jDP2jss5pKtbcXdgSK/68Y=  ;
X-YMail-OSG: bWRAqdAVM1nXOg.gDdcbyHXHZH_JeLupuqGK7A3LalhpI7LsJK5GzLjimQgg7yGql0pID8hxNWXuex9k47Ue4Is2rcnJjG0oHUwFuHTibGX7wnd.Bvm06ebEhtvmp_WV4So-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Daniel Ribeiro <drwyrm@gmail.com>
Subject: Re: [spi-devel-general] [patch 05/14] mfd: PCAP2 driver
Date: Sat, 22 Nov 2008 11:19:27 -0800
User-Agent: KMail/1.9.10
Cc: spi-devel-general@lists.sourceforge.net, stefan@datenfreihafen.org,
       eric.y.miao@gmail.com, sameo@openedhand.com,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
References: <20081121160403.073751031@dodger.lab.datenfreihafen.org> <200811212125.49068.david-b@pacbell.net> <1227373948.19591.66.camel@brutus>
In-Reply-To: <1227373948.19591.66.camel@brutus>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200811221119.27981.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 22 November 2008, Daniel Ribeiro wrote:
> Above comments are integrated on the attached patch. 

Not exactly:

> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -153,6 +153,13 @@ config MFD_WM8350_I2C
>           I2C as the control interface.  Additional options must be
>           selected to enable support for the functionality of the chip.
>  
> +config EZX_PCAP
> +       bool "PCAP Support"
> +       depends on PXA_EZX

It only builds on one platform.  Now, that may make sense if it's
an ASIC currently used only on that platform; it's a "hardware"
dependency.  But it's not a necessary "software" dependency, no
code here seems to rely on PXA hardware, or EZX hardware.

One of the goals of getting drivers into mainline is to get rid
of needless dependencies ... and thereby open the code up to
many more developers.  Some may do nothing more than cleanup;
others will be doing API overhauls, which can be a PITA if you
place needless build dependencies on your code.

Strike that dependency, and depend instead on SPI_MASTER since
that's the only dependency truly required by the build system.

Or tell me I'm wrong, and there's really a reason this code must
not even *build* on x86 systems.


> +       help
> +         This enables the PCAP ASIC present on EZX Phones. This is
> +         needed for MMC, TouchScreen, Sound, USB, etc..
> +
>  endmenu
>  


