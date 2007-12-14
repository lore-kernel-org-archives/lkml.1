Return-Path: <linux-kernel-owner+w=401wt.eu-S932213AbXLNLo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213AbXLNLo1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 06:44:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbXLNLoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 06:44:20 -0500
Received: from berligate.hmw-consulting.de ([83.236.178.202]:49135 "EHLO
	sunbeam.de.gnumonks.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751459AbXLNLoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 06:44:19 -0500
X-Greylist: delayed 2448 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Dec 2007 06:44:18 EST
Message-ID: <476262FC.9090007@gnumonks.org>
Date: Fri, 14 Dec 2007 12:03:24 +0100
From: Harald Welte <laforge@gnumonks.org>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: CIJOML <cijoml@volny.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: HTC TyTN || (P4550) violates GPL?? Or maybe Qualcomm itself with
 MSM7200???
References: <200712080115.05608.cijoml@volny.cz>
In-Reply-To: <200712080115.05608.cijoml@volny.cz>
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, this is Harald from gpl-violations.org. Given my involvement with 
projects like OpenEZX and OpenMoko, I was obviosuly very interested in 
investigating this issue.

CIJOML wrote:
> Hi there,
> 
> it looks like there is running linux somewhere inside in the radio part of the 
> firmware...
> 
> http://forum.xda-developers.com/archive/index.php/t-326419.html
> 
> $ strings kaiser_radio_0x301.nb |grep -i linux
>  M6500C L4/Linux
>  L4 Linux
>  NICTNICTA::Pistachio - built on Jan 23 2007 18:10:22 by dpandian@l4linux15 
> using gcc version 3.4.1
>  start_linux_cmd
>  vmlinux != NULL
>  vmlinux
>  vmlinux igms_name=ramdisk root=/dev/igms0
>  start_linux
> 
> Can anybody else confirm this and contact those companies for source codes?

I have confirmed that the abovementioned strings are present in the 
radio firmware of the device.

However, after a detailed analysis (spent the better part of yesterday 
looking at the various L4 sources and the firmware binary) it seems 
evident that the strings are part of the linux loader, i.e. the part of 
L4 that can execute a specially-modified linux kernel (called wombat).

The lua startup script of the radio firmware does not execute the 
start_linux function but rather only the start_server function to start 
a number of proprietary servers on top of the microkernel.

So at least up to this level of analysis, I cannot find any reason to 
believe there is Linux in the radio firmware.  However, this obviously 
is also no hard proof.

If anyone still has reason to believe Linux is used in the radio 
firmware of the Qualcomm MSM7200 chipset, please let me know.  I'm happy 
to investigate in case new evidence comes up.

As a side note, it would be the most stupid thing to do for a GSM 
chipset vendor.  In all existing smartphone chipsets you have two CPU 
cores (an ARM9 for baseband and ARM11 for the UI/apps in the MSM7200) to 
  avoid any licensing and regulatory issues arising from running the GSM 
stack in the more-or-less open OS on the application side (Windows 
Mobile, Linux, ...)

Cheers,

- Harald Welte <laforge@gnumonks.org>                   http://gnumonks.org/
============================================================================
We all know Linux is great...it does infinite loops in 5 seconds. -- Linus

