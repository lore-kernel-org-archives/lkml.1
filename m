Return-Path: <linux-kernel-owner+w=401wt.eu-S1754391AbZFWJnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391AbZFWJnv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 05:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbZFWJno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 05:43:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64275 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbZFWJnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 05:43:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: liqin.chen@sunplusct.com
Subject: Re: S+core architecture (arch/score/) support files
Date: Tue, 23 Jun 2009 11:43:22 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-9-generic; KDE/4.2.90; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <OF318304AE.9C3DA8BC-ON482575DE.002B7553-482575DE.002FC96B@sunplusct.com>
In-Reply-To: <OF318304AE.9C3DA8BC-ON482575DE.002B7553-482575DE.002FC96B@sunplusct.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906231143.22985.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/y12HKYfpOZJpNDHAGaBNzfh19OACp71RJLFr
 3XsjwtgRqrhOuPJc1uPS3Jemg58wqhkBs3YBCVJqnKB+/MsqBL
 nNFJPH2ACHBwLl9FDsBVO3FoegAafa2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 June 2009, liqin.chen@sunplusct.com wrote:
> Hi Linus,
> 
> This repository contains Linux support for S+core CPU.
> 
> Please pull
> git://git.kernel.org/pub/scm/linux/kernel/git/arnd/asm-generic.git score

I've helped Liquin getting this into a state for inclusion,
so I'll share my observations about the submission.

The code looks very clean for a new architecture support, with the
exception of a few misformatted comments and similar minor issues.
By using the asm-generic headers that are now in 2.6.31, the amount
of copy-paste programming was reduced to a minimum, the total amount
of code added is much less than any other architecture (200kb score,
290kb h8300, 570kb microblaze are the smallest ones).
Fixes for any issues noted during review usually came in quickly.

S+core is now the first architecture to use the ABI defined in
asm-generic, which means it can serve as an example for other
architectures that want to merge their code in the future.

Unfortunately, I don't think that the score glibc has been fully
ported to support this, so it also means that the version that is
being submitted has undergone any run-time testing. I did check
that it compiles fine but could not do more in lack of hardware
or even just a user space distro.

Another small negative is that Liquin is still unexperienced with
the procedures we use in Linux. I've helped out by providing
my git tree, but am not planning to do that beyond 2.6.31.
Given that he has also been upstream gcc maintainer for S+core
for well over 2 years, I believe merging it now will work out well.

	Arnd <><
