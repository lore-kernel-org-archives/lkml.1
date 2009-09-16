Return-Path: <linux-kernel-owner+w=401wt.eu-S1758913AbZIPMkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913AbZIPMkg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 08:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753234AbZIPMke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 08:40:34 -0400
Received: from james.oetiker.ch ([213.144.138.195]:37929 "EHLO
	james.oetiker.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbZIPMkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 08:40:33 -0400
Date: Wed, 16 Sep 2009 14:40:36 +0200 (CEST)
From: Tobias Oetiker <tobi@oetiker.ch>
To: Corrado Zoccolo <czoccolo@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: unfair io behaviour for high load interactive use still present
 in 2.6.31
In-Reply-To: <4e5e476b0909160029l296efe2fk7b873ac68f6bb6a3@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0909161208100.14727@sebohet.brgvxre.pu>
References: <alpine.DEB.2.00.0909150844140.19305@sebohet.brgvxre.pu>  <4e5e476b0909150753k699a2f5awadc666a9b3afebfa@mail.gmail.com>  <alpine.DEB.2.00.0909152305030.14727@sebohet.brgvxre.pu> <4e5e476b0909160029l296efe2fk7b873ac68f6bb6a3@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463760128-1742137852-1253104836=:14727"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463760128-1742137852-1253104836=:14727
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

Hi Corrado,

Today Corrado Zoccolo wrote:

> Hi Tobias,
> On Tue, Sep 15, 2009 at 11:07 PM, Tobias Oetiker <tobi@oetiker.ch> wrote:
> > Today Corrado Zoccolo wrote:
> >
> >> On Tue, Sep 15, 2009 at 9:30 AM, Tobias Oetiker <tobi@oetiker.ch> wrote:
> >> > Below is an excerpt from iostat while the test is in full swing:
> >> >
> >> > * 2.6.31 (8 cpu x86_64, 24 GB Ram)
> >> > * scheduler = cfq
> >> > * iostat -m -x dm-5 5
> >> > * running in parallel on 3 lvm logical volumes
> >> >  on a single physical volume
> >> >
> >> > Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> >> > ---------------------------------------------------------------------------------------------------------
> * with i/o controller patches, what happens if you put readers in one
> domain and writers in the other?

With the io-conroller and readers and writers in two groups, the
rMB/s and wMB/s come out roughly the same. there are two problems unfortunately

a) the interactive performance is still not good since directory access still seems to get.

b) processes normally do both, read AND write, so the distinction would have to be made at the io-controller level.


Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
---------------------------------------------------------------------------------------------------------
dm-5              0.00     0.00  549.80    0.00     2.15     0.00     8.00   577.75    6.82   1.82 100.00
dm-5              0.00     0.00  191.20 1333.60     0.75     5.21     8.00  1077.45  953.15   0.66 100.00
dm-5              0.00     0.00  457.20 1144.00     1.79     4.47     8.00  1820.56  836.86   0.62 100.00
dm-5              0.00     0.00  453.00 1328.80     1.77     5.19     8.00  1326.74 1168.99   0.56 100.00
dm-5              0.00     0.00  353.09  353.49     1.38     1.38     8.00  1405.80 1993.23   1.41  99.80
dm-5              0.00     0.00  280.40 1296.80     1.10     5.07     8.00  1248.95  747.99   0.63 100.00
dm-5              0.00     0.00  307.00 4557.20     1.20    17.80     8.00   985.92  211.25   0.21 100.00
dm-5              0.00     0.00    6.00    0.00     0.02     0.00     8.00   450.42 19116.00 166.67 100.00
dm-5              0.00     0.00  154.00  624.20     0.60     2.44     8.00   926.52 1119.77   1.29 100.00


cheers
tobi



> Are you willing to test some patches? I'm working on patches to reduce
> read latency, that may be interesting to you.
>
> Corrado
>
> > cheers
> > tobi
> >
> > --
> > Tobi Oetiker, OETIKER+PARTNER AG, Aarweg 15 CH-4600 Olten, Switzerland
> > http://it.oetiker.ch tobi@oetiker.ch ++41 62 775 9902 / sb: -9900
>
>
>
>

-- 
Tobi Oetiker, OETIKER+PARTNER AG, Aarweg 15 CH-4600 Olten, Switzerland
http://it.oetiker.ch tobi@oetiker.ch ++41 62 775 9902 / sb: -9900
---1463760128-1742137852-1253104836=:14727--
