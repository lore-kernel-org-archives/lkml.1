Return-Path: <linux-kernel-owner+w=401wt.eu-S933231AbXCHUWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933231AbXCHUWm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 15:22:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933287AbXCHUWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 15:22:42 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:46045 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933231AbXCHUWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 15:22:40 -0500
X-IronPort-AV: i="4.14,264,1170651600"; 
   d="scan'208"; a="30473800:sNHT23970394"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Russell King" <rmk+lkml@arm.linux.org.uk>
Subject: Re: should RTS init in serial core be tied to CRTSCTS
Date: Thu, 8 Mar 2007 15:23:39 -0500
User-Agent: KMail/1.9.5
Cc: "Oleksiy Kebkal" <kebkal@gmail.com>, "Krzysztof Halasa" <khc@pm.waw.pl>,
       "Mike Frysinger" <vapier.adi@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-serial@vger.kernel.org
References: <8bd0f97a0703011603m794e00f5x875eb68ad0db05de@mail.gmail.com> <200703080844.32157.rgetz@blackfin.uclinux.org> <20070308134800.GA30023@flint.arm.linux.org.uk>
In-Reply-To: <20070308134800.GA30023@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703081523.39698.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 08 Mar 2007 20:22:38.0886 (UTC) FILETIME=[84412C60:01C761BF]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 8 Mar 2007 08:48, Russell King pondered:
> On Thu, Mar 08, 2007 at 08:44:31AM -0500, Robin Getz wrote:
> > That would let you change things are run time, but the problem is at
> > boot time. A default setting needs to be set, so when things initialize,
> > and proc does not exist yet, it is still set properly...
>
> I disagree.  "proc does not exist yet" - the only time that applies is
> long before userspace as active.

Right - We both agree - And setting console=/dev/null in the bootargs still 
does not help.

When the kernel initializes the UART Port, it asserts RTS - which confuses the 
host it is attached to (in this case, the Linux system is the serial 
peripheral).

How about adding a module_param to serial core, which the default is to assert 
RTS (as is today), and someone (like me) can override with serial_core.RTS=0

-Robin
