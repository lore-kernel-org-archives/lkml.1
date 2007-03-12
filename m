Return-Path: <linux-kernel-owner+w=401wt.eu-S1752810AbXCLTuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbXCLTuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 15:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbXCLTuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 15:50:21 -0400
Received: from [212.12.190.74] ([212.12.190.74]:33097 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752810AbXCLTuU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 15:50:20 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
Date: Mon, 12 Mar 2007 22:53:33 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703122253.33866.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Xavier Bestel wrote:
> Le mardi 13 mars 2007 à 05:49 +1100, Con Kolivas a écrit :
> > Again I think your test is not a valid testcase. Why use two threads for
> > your encoding with one cpu? Is that what other dedicated desktop OSs
> > would do?
>
> as your scheduler
> is "strictly fair", won't that enable trivial DoS by just letting an
> user fork a multitude of CPU-intensive processes ?

I don't think we have to worry about DoS with this scheduler.
Note the load average; it happily wraps.

top - 22:34:02 up 8 min,  0 users,  load average: 615.32, 746.30, 929.15
Tasks: 3379 total, 3336 running,  43 sleeping,   0 stopped,   0 zombie
Cpu(s):   8.8% user,  21.1% system,  10.0% nice,  56.5% idle,   3.6% IO-wait
Mem:    499480k total,   414640k used,    84840k free,     1956k buffers
Swap:  1020088k total,        0k used,  1020088k free,     8296k cached

  PID  PR  NI  VIRT  RES  SHR SWAP nFLT nDRT WCHAN     S %CPU    TIME+  Command 
  614  39   0  3668 2712  720  956    5    0 rest_init R  1.9   0:09.70 top     
  845  23   0  3056 1780  932 1276    0    0 wait      S  0.0   0:01.96 sh      
    1  20   0  1440  504  444  936   14    0 rest_init S  0.0   0:00.76 init    
 4180  28   0  3664 2640  652 1024    0    0 rest_init R  3.5   0:00.40 top     
  863  39  19  1584  488  412 1096    0    0 rest_init R  0.0   0:00.30 ping    
  929  39  19  1584  488  412 1096    0    0 rest_init R  0.2   0:00.29 ping    
  871  39  19  1584  488  412 1096    0    0 rest_init R  0.2   0:00.28 ping    
  904  39  19  1584  488  412 1096    0    0 rest_init R  0.2   0:00.28 ping    
  946  39  19  1584  488  412 1096    0    0 rest_init R  0.2   0:00.28 ping    
  947  39  19  1584  488  412 1096    0    0 rest_init R  0.2   0:00.28 ping    
  972  39  19  1584  488  412 1096    0    0 rest_init R  0.0   0:00.28 ping    
  862  39  19  1584  488  412 1096    0    0 rest_init R  0.0   0:00.27 ping    
  881  39  19  1584  488  412 1096    0    0 rest_init R  0.0   0:00.27 ping    
  901  39  19  1584  488  412 1096    0    0 rest_init R  0.0   0:00.27 ping    
  915  39  19  1584  488  412 1096    0    0 rest_init R  0.0   0:00.27 ping    
  923  39  19  1584  488  412 1096    0    0 rest_init R  0.0   0:00.27 ping    
  926  39  19  1584  488  412 1096    0    0 rest_init R  0.0   0:00.27 ping    
  958  39  19  1584  488  412 1096    0    0 rest_init R  0.0   0:00.27 ping    
  967  39  19  1584  488  412 1096    0    0 rest_init R  0.0   0:00.27 ping    
  987  39  19  1584  488  412 1096    0    0 rest_init R  0.0   0:00.27 ping    
  994  39  19  1584  488  412 1096    0    0 rest_init R  0.2   0:00.27 ping    


Thanks!

--
Al

