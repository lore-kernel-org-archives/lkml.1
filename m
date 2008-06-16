Return-Path: <linux-kernel-owner+w=401wt.eu-S1757002AbYFPSpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757002AbYFPSpb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 14:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbYFPSpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 14:45:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39828 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380AbYFPSpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 14:45:19 -0400
Message-ID: <4856ADF1.3040707@zytor.com>
Date: Mon, 16 Jun 2008 11:16:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Sean Young <sean@mess.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: Regression: boot failure on AMD Elan TS-5500
References: <20080616121138.GA51097@atlantis.8hz.com> <200806162327.34912.rusty@rustcorp.com.au> <48566C88.6000702@goop.org> <20080616161944.GA53539@atlantis.8hz.com> <48569D96.1090904@zytor.com> <20080616175833.GA54900@atlantis.8hz.com>
In-Reply-To: <20080616175833.GA54900@atlantis.8hz.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sean Young wrote:
> 
> The thinking was that syslinux sets the boot parameters which are being read 
> in head_32.S. I've used syslinux 3.53 but have just moved to 3.63.
> 
> That was the theory at least. I'm not sure what's going on now. I'll spend
> some more time on this.
> 

Most of the boot parameters actually come from the real-mode boot code 
(arch/x86/boot).  A few of them come from the bootloader.

With a version of Syslinux that recent there shouldn't be any issues, 
especially since Syslinux is, for somewhat obvious reasons, my reference 
bootloader.  You may want to experiment with using the optional 
linux.c32 module just to see if it changes the behaviour:

boot: linux.c32 kernel options...

Or, in the configuration file:

label blah
	kernel linux.c32
	append kernel options...

	-hpa
