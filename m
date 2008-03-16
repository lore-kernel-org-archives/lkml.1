Return-Path: <linux-kernel-owner+w=401wt.eu-S1753733AbYCPWKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbYCPWKA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 18:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbYCPWJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 18:09:50 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:36833
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752550AbYCPWJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 18:09:50 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Greg KH <gregkh@suse.de>
Subject: 2.6.24.3 broke "make headers_install".
Date: Sun, 16 Mar 2008 17:09:51 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Samuel Masham <samuel.masham@gmail.com>, stable@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <93564eb70802241736l741e7406o29fab05a611c12c7@mail.gmail.com> <93564eb70803101913n2ede72d1i33279772440c9afa@mail.gmail.com> <20080311033306.GB9198@suse.de>
In-Reply-To: <20080311033306.GB9198@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803161709.52389.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 March 2008 22:33:06 Greg KH wrote:
> On Tue, Mar 11, 2008 at 11:13:02AM +0900, Samuel Masham wrote:
> > Hi Stable, Greg, all,
> >
> > Just a quick ping.
> >
> > Still not seeing these on the stable queue? Any issue or am i just
> > looking in the wrong place:-
> >
> > http://www.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
>
> You're looking in the right place, I'm just slow these days :)
>
> thanks,
>
> greg k-h

Speaking of the stable queue, I just tried 2.6.24.3 and "make headers_install" 
now dies with:

make[2]: *** No rule to make target 
`/home/landley/firmware/firmware/build/temp-i686/linux/include/linux/if_addrlabel.h', 
needed by 
`/home/landley/firmware/firmware/build/cross-compiler-i686/include/linux/if_addrlabel.h'.  
Stop.

I note that 2.6.24.2 didn't do that.

The problem seems t be this hunk:

diff -ru build.bak/sources/linux/include/linux/Kbuild 
build/sources/linux/includ
e/linux/Kbuild
--- build.bak/sources/linux/include/linux/Kbuild        2008-02-10 
23:51:11.0000
00000 -0600
+++ build/sources/linux/include/linux/Kbuild    2008-02-25 
18:20:20.000000000 -0
600
@@ -217,6 +217,7 @@
 unifdef-y += icmp.h
 unifdef-y += icmpv6.h
 unifdef-y += if_addr.h
+unifdef-y += if_addrlabel.h
 unifdef-y += if_arp.h
 unifdef-y += if_bridge.h
 unifdef-y += if_ec.h

The corresponding if_addrlabel.h file isn't in the 2.6.24.3 tarball, that I 
can find...

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
