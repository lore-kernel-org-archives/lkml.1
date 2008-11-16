Return-Path: <linux-kernel-owner+w=401wt.eu-S1754798AbYKPGLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbYKPGLX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 01:11:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbYKPGLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 01:11:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:43350 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbYKPGLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 01:11:14 -0500
Message-ID: <491FB988.50601@kernel.org>
Date: Sun, 16 Nov 2008 15:11:20 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?=22J=2EA=2E_Magall=F3n=22?= <jamagallon@ono.com>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-IDE <linux-ide@vger.kernel.org>,
       Mdv Cooker <cooker@mandrivalinux.org>
Subject: Re: sata-nv and 790i
References: <20081115004722.5158e125@werewolf.home>
In-Reply-To: <20081115004722.5158e125@werewolf.home>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 16 Nov 2008 06:11:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J.A. Magallón wrote:
> Hi all...
> 
> I recently put my hands on a system with an ASUS P5N64 WS Pro mobo:
> 
> http://www.asus.com/products.aspx?l1=3&l2=11&l3=653&l4=0&model=2182&modelmenu=1
> 
> It has a nForce 790i Ultra SLI chipset, the part for the SATA controller
> is MCP55.
> 
> The problem is that linux seems to fail to read the hard drive on boot.
> I will explain.
> 
> I have tried to install both CentOS 5.2 and Mandriva 2009.0.
> For CentOS (has a 2.6.18 kernel), the install seems ok, but when I reboot
> into the just intalled system the kernel hangs just after printing
> the name of the initrd. Mandriva (2.6.27-rc8) just hungs half the install process.
> Live versions of both hang on boot saying they can not find the root
> device.
> 
> I have found some messages in the net about the MCP55 in that board not
> being completeley suppported as AHCI in sata_nv, and that some other
> boards work puttin the SATA controller in 'compatible' mode (with
> loss of performance).
> But I can't find any setting in the P5N64 to put SATA in Compat mode.
> 
> Can I do this via some kernel parameters ?
> Somabody has this board working ? Do current kernels have better support
> for this chipset ?

All three flavors of sata_nv's - generic (yours), nf2/3 and ck804 - had
various detection problems from 2.6.27-rc1.  The problem was that their
hardresets all worked differently.  2.6.27-rc1 started to favor
hardresets over softresets and exposed this problem.  While trying to
fix the problem, because all three flavors unexpectedly showed different
hardreset behaviors, there were some mistakes.  A proper fix is included
in upstream and is queued for -stable.  Sorry about the mess.

Thanks.

-- 
tejun
