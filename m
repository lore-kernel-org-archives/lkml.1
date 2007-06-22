Return-Path: <linux-kernel-owner+w=401wt.eu-S1758881AbXFVOrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758881AbXFVOrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 10:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756028AbXFVOq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 10:46:59 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:25571 "EHLO
	outbound7-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756432AbXFVOq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 10:46:58 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Date: Fri, 22 Jun 2007 16:47:50 +0200
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/12] acpi: select ACPI_EC for THINKPAD_ACPI
Message-ID: <20070622144750.GV5193@alberich.amd.com>
References: <20070619224836.GD5193@alberich.amd.com>
 <20070620005744.GA15080@khazad-dum.debian.net>
MIME-Version: 1.0
In-Reply-To: <20070620005744.GA15080@khazad-dum.debian.net>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 22 Jun 2007 14:46:41.0540 (UTC)
 FILETIME=[2553C440:01C7B4DC]
X-WSS-ID: 6A653F5E1S41145773-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2007 at 09:57:44PM -0300, Henrique de Moraes Holschuh wrote:
> On Wed, 20 Jun 2007, Andreas Herrmann wrote:
> > Fix kernel build problem:
> > 
> >  thinkpad_acpi.c:(.text+0x7486a): undefined reference to `ec_write'
> > 
> > (as THINKPAD_ACPI depends on ACPI_EC)
> > 
> > Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> > ---
> >  drivers/misc/Kconfig |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> > index 2f2fbff..72774c9 100644
> > --- a/drivers/misc/Kconfig
> > +++ b/drivers/misc/Kconfig
> > @@ -139,6 +139,7 @@ config SONYPI_COMPAT
> >  config THINKPAD_ACPI
> >  	tristate "ThinkPad ACPI Laptop Extras"
> >  	depends on X86 && ACPI
> > +	select ACPI_EC
> >  	select BACKLIGHT_CLASS_DEVICE
> >  	select HWMON
> >  	---help---
> 
> Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> 

Well, this one shouldn't be applied. The problem is better
fixed in arch/x86_64/Kconfig.

BTW, the above patch would lead to kconfig warnings on non
x86-architectures. A proper version would be to add
"select ACPI_EC if X86".


Regards,

Andreas

-- 
Operating | AMD Saxony Limited Liability Company & Co. KG,
  System  | Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 Research | Register Court Dresden: HRA 4896, General Partner authorized
  Center  | to represent: AMD Saxony LLC (Wilmington, Delaware, US)
  (OSRC)  | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy



