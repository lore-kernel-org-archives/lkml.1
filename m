Return-Path: <linux-kernel-owner+w=401wt.eu-S964806AbXBNWIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964806AbXBNWIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 17:08:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964801AbXBNWIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 17:08:34 -0500
Received: from smtp111.sbc.mail.mud.yahoo.com ([68.142.198.210]:43886 "HELO
	smtp111.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S964805AbXBNWId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 17:08:33 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=fnDsfpngtHK7iPyssfPmVUQjOqkISn39xWGnQYe4HCHiyxu3e5cDOBA3d7lTYWf67kZcEOQ6PSSImGH4LAxCSeZdMXFMzFNQVxgpuBICElDr0KDpfb23OTyWX4ZTMfhvxOatauyuZ657YU3hrkg6Tz3upa2PWxboyOpZNvGrx6U=  ;
X-YMail-OSG: 6MxaMNMVM1nxvXLiRvaz8_sulNsDYEGhdl.a9iFJta9Aa07jy8yDdvg95gZZ514LAA356pcJCYTB.uCOBZOCJaK4rvWSIXcEGOFbFtjggEQD_XRIkMnrGJcDoCgZIFw6Q0RGRxVv98C0T2w-
From: David Brownell <david-b@pacbell.net>
To: Dave Jones <davej@redhat.com>
Subject: Re: loosen dependancy on rtc cmos
Date: Wed, 14 Feb 2007 11:55:33 -0800
User-Agent: KMail/1.7.1
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
References: <20070214180915.GA6412@redhat.com>
In-Reply-To: <20070214180915.GA6412@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702141155.33970.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 February 2007 10:09 am, Dave Jones wrote:
> This option is useful for all of the X86 subarchs afaik (and especially X86_GENERICARCH).

You're right ... _potentially_ useful, which is the same standard used
in most of the other cases.  The "X86_PC" is debris from an early version
of this patch, which limited the code to cases where it was known to work.
The X86_PC hardware standard does standardize on this particular RTC, but
non-PC platforms can use it too.

I still need to resubmit the patch, for X86_PC, which defines the platform
device in the (common) case where PNPACPI isn't defined.  Other X86 boards
would need something similar, based on what chips are wired to the CPU.


> Signed-off-by: Dave Jones <davej@redhat.com>

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>


> --- linux-2.6.20.noarch/drivers/rtc/Kconfig~	2007-02-14 13:07:07.000000000 -0500
> +++ linux-2.6.20.noarch/drivers/rtc/Kconfig	2007-02-14 13:07:13.000000000 -0500
> @@ -101,7 +101,7 @@ comment "RTC drivers"
>  
>  config RTC_DRV_CMOS
>  	tristate "PC-style 'CMOS' real time clock"
> -	depends on RTC_CLASS && (X86_PC || ALPHA || ARM26 || ARM \
> +	depends on RTC_CLASS && (X86 || ALPHA || ARM26 || ARM \
>  		|| M32R || ATARI || POWERPC)
>  	help
>  	  Say "yes" here to get direct support for the real time clock
> 
> -- 
> http://www.codemonkey.org.uk
> 
