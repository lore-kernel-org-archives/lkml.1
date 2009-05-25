Return-Path: <linux-kernel-owner+w=401wt.eu-S1754561AbZEYXgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbZEYXgn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 19:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753151AbZEYXgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 19:36:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41427 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893AbZEYXge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 19:36:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Richard Atterer <richard@2009.atterer.net>
Subject: Re: [Bug #13371] s2disk hangs with kernel 2.6.29 and later, SATA, Gigabyte EG45M-DS2H - culprit found
Date: Tue, 26 May 2009 01:36:32 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       Auke Kok <auke-jan.h.kok@intel.com>
References: <GtY7d2eWpoK.A.ioC.MQcGKB@chimera> <20090525171305.GA5855@arbonne.lan> <20090525230259.GA5098@vilya>
In-Reply-To: <20090525230259.GA5098@vilya>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905260136.33724.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 May 2009, Richard Atterer wrote:
> Hello,
> 
> "Jerry" contacted me off-list with information about the root of the 
> problem - many thanks indeed!!!
> 
> It turns out that the e100 driver is responsible. (The motherboard actually 
> has a r8169 chip, but I added an old Intel PCI ethernet card I own.)
> 
> By rmmoding e100 before s2disk, the problem goes away. Jerry mentions that 
> he once saw a message about e100 failing to load its microcode - I never 
> saw such a message.
> 
> The most recent e100 commit ac7c992 by Thadeu Lima de Souza Cascardo (Apr 
> 28) made some changes to the behaviour in the case of shutdown vs. suspend, 
> maybe the problem is there? (But note that during bisecting, I tested 
> kernels older than that commit, and not all of them worked.) Before that, 
> f902283 (Mar 3 2008) mentions suspend in the log message.

OK, thanks for the information.  I'll have a look at the e100 suspend-resume
code, but I really don't think commit ac7c992 is at fault here.

Best,
Rafael
