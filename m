Return-Path: <linux-kernel-owner+w=401wt.eu-S1752032AbZGOFq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbZGOFq5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 01:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751722AbZGOFq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 01:46:56 -0400
Received: from mxp3.isis.unc.edu ([152.2.2.161]:38418 "EHLO mxpm.isis.unc.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751619AbZGOFqz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 01:46:55 -0400
X-Greylist: delayed 4792 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Jul 2009 01:46:55 EDT
Message-ID: <20090715002526.camdiuc3k48go0sk@webmail3.isis.unc.edu>
Date: Wed, 15 Jul 2009 00:25:26 -0400
From: "Bjoern B. Brandenburg" <bbb@cs.unc.edu>
To: "James H. Anderson" <anderson@cs.unc.edu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Chris Friesen <cfriesen@nortel.com>, Raistlin <raistlin@linux.it>,
       Douglas Niehaus <niehaus@ittc.ku.edu>, Henrik Austad <henrik@austad.us>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Thomas Gleixner <tglx@linutronix.de>, Ted Baker <baker@cs.fsu.edu>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Noah Watkins <jayhawk@soe.ucsc.edu>,
       KUSP Google Group <kusp@googlegroups.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>,
       Bjoern Brandenburg <bbb@cs.unc.edu>, shinpei@ny.ics.keio.ac.jp,
       yamasaki@ny.ics.keio.ac.jp
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
References: <200907102350.47124.henrik@austad.us>
	<1247336891.9978.32.camel@laptop> <4A594D2D.3080101@ittc.ku.edu>
	<1247412708.6704.105.camel@laptop> <1247499843.8107.548.camel@Palantir>
	<4A5B61DF.8090101@nortel.com> <1247568455.9086.115.camel@Palantir>
	<4A5C9ABA.9070909@nortel.com>
	<alpine.LRH.2.00.0907141109190.16818@anderson.cs.unc.edu>
	<1247589099.7500.191.camel@twins>
	<alpine.LRH.2.00.0907141234280.16818@anderson.cs.unc.edu>
In-Reply-To: <alpine.LRH.2.00.0907141234280.16818@anderson.cs.unc.edu>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: UNC-CH Webmail 2.0
X-Organization: University of North Carolina at Chapel Hill
X-Originating-IP: 17.202.44.200
X-Remote-Browser: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6; en-us)
	AppleWebKit/531.1 (KHTML, like Gecko) Version/4.0 Safari/531.1
X-Proofpoint-Virus-Version: vendor=fsecure engine=1.12.8161:2.4.5,1.2.40,4.0.166 definitions=2009-07-15_04:2009-07-03,2009-07-15,2009-07-14 signatures=0
X-Proofpoint-Spam-Details: rule=uncdefault_notspam policy=uncdefault score=0 spamscore=0 ipscore=0 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx engine=5.0.0-0811170000 definitions=main-0907140216
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting "James H. Anderson" <anderson@cs.unc.edu>:
> Ted Baker did some work on an algorithm called EDZL
> (EDF until zero laxity) that is essentially a hybrid of these two
> algorithms.  In simulations we've done (not based on real implementations),
> EDZL exhibits really low tardiness (almost non-existent).  EDZL may
> give you the benefits of using laxities where useful and be easier
> to implement (but that's just my guess)

EDZL has nice properties but may be hard to implement efficiently 
because it requires (a lot of) fine-grained timers.  However, Shinpei 
Kato and Nobuyuki Yamasaki (CC'ed) presented an EDZL-derived scheduler 
called EDCL at RTCSA'08 that has similar performance guarantees but 
only does priority promotions at the release and completion times of 
jobs (hence, no additional timers are required).

  Global EDF-based Scheduling with Efficient Priority Promotion
  Shinpei Kato and Nobuyuki Yamasaki
  Proceedings of the 14th International Conference on Embedded and
  Real-Time Computing Systems and Applications, pages 197-206. IEEE, 2008.
  http://www.ny.ics.keio.ac.jp/members/shinpei/papers/rtcsa08.pdf

I know that Shinpei and friends implemented EDCL on top of LITMUS^RT, 
but I never got around to incorporating the patches into the "official" 
LITMUS^RT patch. (Sorry, Shinpei!)

Regarding the comments about the availability of academic papers (which 
were also voiced repeatedly at OSPERT'09), I'd like to point out that 
you can find almost any recent paper by searching for the title with 
scholar.google.com and clicking on the "All XYZ versions" link... most 
researches make PDFs available on their homepages.

- Björn


