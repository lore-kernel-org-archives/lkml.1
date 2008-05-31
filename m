Return-Path: <linux-kernel-owner+w=401wt.eu-S1755718AbYEaUXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718AbYEaUXB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 16:23:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752811AbYEaUWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 16:22:52 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:44780 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917AbYEaUWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 16:22:50 -0400
Date: Sat, 31 May 2008 23:22:39 +0300
From: Adrian Bunk <bunk@kernel.org>
To: sam@ravnborg.org, hjl.tools@gmail.com, lethal@linux-sh.org
Cc: linux-kbuild@vger.kernel.org, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: sh64 build error - sh, kbuild or binutils problem?
Message-ID: <20080531202239.GB7347@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cayman_defconfig fails to build with the following error
(using binutils 2.18.50.0.7):

<--  snip  -->

...
  LD      drivers/macintosh/built-in.o
  LD      drivers/media/common/tuners/built-in.o
  CC [M]  drivers/media/common/tuners/tuner-xc2028.o
  CC [M]  drivers/media/common/tuners/tuner-simple.o
  CC [M]  drivers/media/common/tuners/tuner-types.o
  CC [M]  drivers/media/common/tuners/mt20xx.o
  CC [M]  drivers/media/common/tuners/tda8290.o
  CC [M]  drivers/media/common/tuners/tea5767.o
  CC [M]  drivers/media/common/tuners/tea5761.o
  CC [M]  drivers/media/common/tuners/tda9887.o
  CC [M]  drivers/media/common/tuners/xc5000.o
  LD      drivers/media/common/built-in.o
...
  LD      drivers/media/built-in.o
sh64-linux-ld: sh3 architecture of input file `drivers/media/common/built-in.o' is incompatible with sh5 outputmake[3]: *** [drivers/media/built-in.o] Error 1

<--  snip  -->


Minimal example demonstrating the problem:

$ sh64-linux-ar rcs tmp.o
$ sh64-linux-ld -EL -r -o tmp2.o tmp.o
$ sh64-linux-ld -EL -r -o out.o tmp2.o 
sh64-linux-ld: sh3 architecture of input file `tmp2.o' is incompatible with sh5 output
$ 


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

