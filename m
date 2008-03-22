Return-Path: <linux-kernel-owner+w=401wt.eu-S1756446AbYCVLyH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446AbYCVLyH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 07:54:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754845AbYCVLx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 07:53:58 -0400
Received: from mail.gmx.net ([213.165.64.20]:42669 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754786AbYCVLx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 07:53:57 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+eHaQg2WiebTYpuA+2VVYbLJCup+aj5nwLeQ3Lph
	QTEiGrxogmbExx
Subject: Re: Scalability requirements for sysv ipc
From: Mike Galbraith <efault@gmx.de>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: paulmck@linux.vnet.ibm.com, Nadia Derbey <Nadia.Derbey@bull.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <47E4DB06.3020003@colorfullife.com>
References: <47E382DB.70503@colorfullife.com> <47E3ADE3.4030304@bull.net>
	 <47E3B924.3000304@colorfullife.com>
	 <20080321141339.GB9618@linux.vnet.ibm.com>
	 <47E3DD8C.4000904@colorfullife.com>
	 <1206164608.3659.11.camel@marge.simson.net>
	 <47E4DB06.3020003@colorfullife.com>
Content-Type: text/plain
Date: Sat, 22 Mar 2008 12:53:52 +0100
Message-Id: <1206186832.4545.1.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-03-22 at 11:10 +0100, Manfred Spraul wrote:

> Attached are my own testapps: one for sysv msg, one for sysv sem.
> Could you run them? Taskset is done internally, just execute
> 
> $ for i in 1 2 3 4;do ./psem $i 5;./pmsg $i 5;done

2.6.22.18-cfs-v24-smp                         2.6.24.3-smp
Result matrix: (psem)
  Thread   0:  2394885       1:  2394885         Thread   0:  2004534       1:  2004535
Total: 4789770                                Total: 4009069
Result matrix: (pmsg)
  Thread   0:  2345913       1:  2345914         Thread   0:  1971000       1:  1971000
Total: 4691827                                Total: 3942000


Result matrix:
  Thread   0:  1613610       2:  1613611          Thread   0:   477112       2:   477111
  Thread   1:  1613590       3:  1613590          Thread   1:   485607       3:   485607
Total: 6454401                                 Total: 1925437
Result matrix:
  Thread   0:  1409956       2:  1409956          Thread   0:   519398       2:   519398
  Thread   1:  1409776       3:  1409776          Thread   1:   519169       3:   519170
Total: 5639464                                 Total: 2077135 


Result matrix:
  Thread   0:   516309       3:   516309           Thread   0:   401157       3:   401157
  Thread   1:   318546       4:   318546           Thread   1:   408252       4:   408252
  Thread   2:   352940       5:   352940           Thread   2:   703600       5:   703600
Total: 2375590                                  Total: 3026018
Result matrix:
  Thread   0:   478356       3:   478356           Thread   0:   344738       3:   344739
  Thread   1:   241655       4:   241655           Thread   1:   343614       4:   343615
  Thread   2:   252444       5:   252445           Thread   2:   589298       5:   589299
Total: 1944911                                   Total: 2555303


Result matrix:
  Thread   0:   443392       4:   443392           Thread   0:   398491       4:   398491
  Thread   1:   443338       5:   443339           Thread   1:   398473       5:   398473
  Thread   2:   444069       6:   444070           Thread   2:   394647       6:   394648
  Thread   3:   444078       7:   444078           Thread   3:   394784       7:   394785
Total: 3549756                                   Total: 3172792
Result matrix:
  Thread   0:   354973       4:   354973           Thread   0:   331307       4:   331307
  Thread   1:   354966       5:   354966           Thread   1:   331220       5:   331221
  Thread   2:   358035       6:   358035           Thread   2:   322852       6:   322852
  Thread   3:   357877       7:   357877           Thread   3:   322899       7:   322899
Total: 2851702                                   Total: 2616557


