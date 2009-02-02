Return-Path: <linux-kernel-owner+w=401wt.eu-S1756791AbZBBC3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791AbZBBC3T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 21:29:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbZBBC3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 21:29:07 -0500
Received: from mail-bw0-f12.google.com ([209.85.218.12]:49318 "EHLO
	mail-bw0-f12.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbZBBC3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 21:29:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MCMGPimTv7Yo3aME35jr+3CtyCXAwGQECPNOv4O6R6+yPkxbsKH6a6FjssiPKrT/1+
         ASAy/EKUYq/0qI++eeT88oGVysnhInuASlc7K9l1DextWvn3itmUvi/FOPygWBkqm9tc
         JPGNV0atoxdNnnNx9F3LvNe78VIgjHP6BUCNM=
MIME-Version: 1.0
In-Reply-To: <4983DF0A.6030402@gmail.com>
References: <77887e110901301623u746535f2q7dcc37cd40d2cc56@mail.gmail.com>
	 <4983A446.5080809@shaw.ca>
	 <77887e110901301725p64f5ab4fk341a9bfaf6715a7b@mail.gmail.com>
	 <4983DF0A.6030402@gmail.com>
Date: Mon, 2 Feb 2009 03:29:03 +0100
Message-ID: <77887e110902011829g374dd368x67ef57a3a710c147@mail.gmail.com>
Subject: Re: libata - anomaly performance with NCQ
From: Bartosz SKOWRON <getxsick@gmail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 31, 2009 at 6:18 AM, Robert Hancock <hancockrwd@gmail.com> wrote:

> bonnie++ is one I've used, I'm sure there are others.. Of course, what do
> you compare the results to..

Hmmm more tests == more confusions ;-)

NCQ ENABLED:

Version 1.03b       ------Sequential Output------ --Sequential Input- --Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
banan            6G 32681  99 81220  35 37915  31 32675  99 88157  28 286.0   0
                    ------Sequential Create------ --------Random Create--------
                    -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
                 16  3115  32 +++++ +++  3774  38  3321  38 +++++ +++  1004  10

NCQ DISABLED:
Version 1.03b       ------Sequential Output------ --Sequential Input- --Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
banan            6G 32617  99 84305  36 36022  16 32889  99 88199  28 233.9   0
                    ------Sequential Create------ --------Random Create--------
                    -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
                 16  3866  40 +++++ +++  5538  48  3668  38 +++++ +++  1093  11


So it looks very similar but without ncq looks a bit better, doesn't it?

something practical test: copy a movie file (~750MB) into /tmp (tmpfs):
ncq: ~70-75MB/s
noncq: ~65-70MB/s

and hdparm once again:

ncq:
 Timing buffered disk reads:  108 MB in  3.06 seconds =  35.33 MB/sec
noncq:
 Timing buffered disk reads:  258 MB in  3.01 seconds =  85.63 MB/sec


Can you or anyone else analyze those results? They confuse me a lot
cause they are sometimes in a conflict.
And what results of bonnie++ should i compare to other tests?
sequintal output:block ? or per?

and here is my hdd:
 Model=ST9320421AS                             , FwRev=SD13    ,
SerialNo=            5TJ0DGSP
 Config={ HardSect NotMFM HdSw>15uSec Fixed DTR>10Mbs RotSpdTol>.5% }
 RawCHS=16383/16/63, TrkSize=0, SectSize=0, ECCbytes=4
 BuffType=unknown, BuffSize=16384kB, MaxMultSect=16, MultSect=?16?
 CurCHS=16383/16/63, CurSects=16514064, LBA=yes, LBAsects=625142448
 IORDY=on/off, tPIO={min:120,w/IORDY:120}, tDMA={min:120,rec:120}
 PIO modes:  pio0 pio1 pio2 pio3 pio4
 DMA modes:  mdma0 mdma1 mdma2
 UDMA modes: udma0 udma1 udma2 udma3 udma4 udma5 *udma6
 AdvancedPM=yes: unknown setting WriteCache=enabled
 Drive conforms to: unknown:  ATA/ATAPI-4,5,6,7


regards,
bart
