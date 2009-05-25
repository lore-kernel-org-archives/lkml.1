Return-Path: <linux-kernel-owner+w=401wt.eu-S1755456AbZEYXWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbZEYXWZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 19:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754874AbZEYXWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 19:22:04 -0400
Received: from acheron.ifi.lmu.de ([129.187.214.135]:34124 "EHLO
	acheron.ifi.lmu.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575AbZEYXWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 19:22:03 -0400
X-Greylist: delayed 1143 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 May 2009 19:22:02 EDT
Date: Tue, 26 May 2009 01:03:00 +0200
From: Richard Atterer <richard@2009.atterer.net>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       Auke Kok <auke-jan.h.kok@intel.com>
Subject: Re: [Bug #13371] s2disk hangs with kernel 2.6.29 and later, SATA,
	Gigabyte EG45M-DS2H - culprit found
Message-ID: <20090525230259.GA5098@vilya>
Mail-Followup-To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
	Auke Kok <auke-jan.h.kok@intel.com>
References: <GtY7d2eWpoK.A.ioC.MQcGKB@chimera> <200905251448.40907.bzolnier@gmail.com> <20090525134522.GA7805@arbonne.lan> <200905251630.21781.bzolnier@gmail.com> <20090525171305.GA5855@arbonne.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090525171305.GA5855@arbonne.lan>
Mail-Copies-To: nobody
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

"Jerry" contacted me off-list with information about the root of the 
problem - many thanks indeed!!!

It turns out that the e100 driver is responsible. (The motherboard actually 
has a r8169 chip, but I added an old Intel PCI ethernet card I own.)

By rmmoding e100 before s2disk, the problem goes away. Jerry mentions that 
he once saw a message about e100 failing to load its microcode - I never 
saw such a message.

The most recent e100 commit ac7c992 by Thadeu Lima de Souza Cascardo (Apr 
28) made some changes to the behaviour in the case of shutdown vs. suspend, 
maybe the problem is there? (But note that during bisecting, I tested 
kernels older than that commit, and not all of them worked.) Before that, 
f902283 (Mar 3 2008) mentions suspend in the log message.

Cheers,

  Richard

-- 
  __   _
  |_) /|  Richard Atterer     |  GnuPG key: 888354F7
  | \/¯|  http://atterer.net  |  08A9 7B7D 3D13 3EF2 3D25  D157 79E6 F6DC 8883 54F7
  ¯ '` ¯
