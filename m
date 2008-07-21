Return-Path: <linux-kernel-owner+w=401wt.eu-S1760680AbYGUG3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760680AbYGUG3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 02:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbYGUG3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 02:29:06 -0400
Received: from metis.extern.pengutronix.de ([83.236.181.26]:40836 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754655AbYGUG3F convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 02:29:05 -0400
From: Juergen Beisert <jbe@pengutronix.de>
Organization: Pengutronix - Linux Solutions for Science and Industry
To: linux-kernel@vger.kernel.org
Date: Mon, 21 Jul 2008 08:28:55 +0200
User-Agent: KMail/1.9.9
Cc: Samuel Sieb <samuel@sieb.net>
References: <48841A92.4020301@sieb.net>
In-Reply-To: <48841A92.4020301@sieb.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200807210828.56821.jbe@pengutronix.de>
X-SA-Exim-Connect-IP: 83.236.181.29
X-SA-Exim-Mail-From: jbe@pengutronix.de
Subject: Re: kernel won't boot on a Cyrix MediaGXm (Geode )
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.extern.pengutronix.de)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Samuel,

On Montag, 21. Juli 2008, Samuel Sieb wrote:
> I have a computer here with a CPU that the BIOS identifies as:
> Cyrix MediaGXm/Cx5530 Unicorn Revision 1.19.3B
>
> kernel 2.6.14 identifies it as:
> vendor_id	: Geode by NSC
> cpu family	: 5
> model		: 9
> model name	: Geode(TM) Integrated Processor by National Semi
> stepping	: 1
>
> I can't boot any kernel later than 2.6.22 on it.  Anything later either
> hangs or gives random kernel panics while booting.  I tracked down the
> problem to a specific commit:
>
> commit f25f64ed5bd3c2932493681bdfdb483ea707da0a
> Author: Juergen Beisert <juergen@kreuzholzen.de>
> Date:   Sun Jul 22 11:12:38 2007 +0200
>
>      x86: Replace NSC/Cyrix specific chipset access macros by inlined
> functions.
>
> Reversing the patch (compensating for kernel changes) let me boot a
> 2.6.25 kernel.  I realize the patch is supposed to fix something that
> didn't work right, but I didn't have a problem before and I do now. :-)

Yes. My patch makes some chipset tweaks working as expected. Or at least it 
makes them work. It seems nobody ever tested them before. Remove the 
following line (or change it to meet your CPU clock frequency):

linux-2.6.25/arch/x86/kernel/cyrix.c, line 151. Disable this line or change 
the value 0x04 according to the speed of your CPU. This tweak helps others 
with random hangs of their system.

For this CX86_PCR0 register here some info from the datasheet:

/*
 * Setup the chipset specific Performance Control Incrementer
 *
 * The Performance Control Incrementer seems to be a delay line to control
 * data setup time for DRAM access or it controls its jitter. Its setting
 * depends on CPU and DRAM clock (CPU and DRAM clock are coupled through a
 * simple clock divider. For a 300 MHz CPU the divider is 3.0 to get a DRAM
 * clock of 100MHz)
 * There is an application note how to setup it:
 *  "AMD Geode GX1 Processor Memory Timings for Maximum Performance."
 * Values for various CPUs:
 * 1-0 for processor speed 200...266MHz
 * 1-1 for processor speed 300 and 333MHz
 *
 * Note: If your system runs unstable after setting new values here,
 * try with other values or leave the value as the BIOS setup it.
 * The setting depends also on physical layout!
 */

Regards
Juergen

-- 
Dipl.-Ing. Juergen Beisert | http://www.pengutronix.de
 Pengutronix - Linux Solutions for Science and Industry
    Handelsregister: Amtsgericht Hildesheim, HRA 2686
         Vertretung Sued/Muenchen, Germany
   Phone: +49-8766-939 228 |  Fax: +49-5121-206917-9
