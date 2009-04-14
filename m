Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098AbZDNFBs (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 14 Apr 2009 01:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751756AbZDNFBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 01:01:23 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:52160 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055AbZDNFBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 01:01:21 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: anton@samba.org, mingo@elte.hu, akpm@linux-foundation.org,
   dipankar@in.ibm.com, manfred@colorfullife.com, cl@linux-foundation.org,
   josht@linux.vnet.ibm.com, schamp@sgi.com, niv@us.ibm.com, dvhltc@us.ibm.com,
   ego@in.ibm.com, laijs@cn.fujitsu.com, rostedt@goodmis.org,
   peterz@infradead.org, penberg@cs.helsinki.fi, andi@firstfloor.org,
   tglx@linutronix.de, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH 3/3] v2 Update RCU tracing documentation for __rcu_pending
Date: Mon, 13 Apr 2009 21:31:18 -0700
Message-Id: <12396834792865-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <1239683478419-git-send-email->
References: <1239683478419-git-send-email->
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

This patch updates the RCU documentation to reflect the changes in
tracing made in the previous patch in the set.

Located-by: Anton Blanchard <anton@au1.ibm.com>
Tested-by: Anton Blanchard <anton@au1.ibm.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/trace.txt |  102 +++++++++++++++++++++++++++++++++---------
 1 files changed, 80 insertions(+), 22 deletions(-)

diff --git a/Documentation/RCU/trace.txt b/Documentation/RCU/trace.txt
index 0688482..02cced1 100644
--- a/Documentation/RCU/trace.txt
+++ b/Documentation/RCU/trace.txt
@@ -192,23 +192,24 @@ rcu/rcuhier (which displays the struct rcu_node hierarchy).
 The output of "cat rcu/rcudata" looks as follows:
 
 rcu:
-  0 c=4011 g=4012 pq=1 pqc=4011 qp=0 rpfq=1 rp=3c2a dt=23301/73 dn=2 df=1882 of=0 ri=2126 ql=2 b=10
-  1 c=4011 g=4012 pq=1 pqc=4011 qp=0 rpfq=3 rp=39a6 dt=78073/1 dn=2 df=1402 of=0 ri=1875 ql=46 b=10
-  2 c=4010 g=4010 pq=1 pqc=4010 qp=0 rpfq=-5 rp=1d12 dt=16646/0 dn=2 df=3140 of=0 ri=2080 ql=0 b=10
-  3 c=4012 g=4013 pq=1 pqc=4012 qp=1 rpfq=3 rp=2b50 dt=21159/1 dn=2 df=2230 of=0 ri=1923 ql=72 b=10
-  4 c=4012 g=4013 pq=1 pqc=4012 qp=1 rpfq=3 rp=1644 dt=5783/1 dn=2 df=3348 of=0 ri=2805 ql=7 b=10
-  5 c=4012 g=4013 pq=0 pqc=4011 qp=1 rpfq=3 rp=1aac dt=5879/1 dn=2 df=3140 of=0 ri=2066 ql=10 b=10
-  6 c=4012 g=4013 pq=1 pqc=4012 qp=1 rpfq=3 rp=ed8 dt=5847/1 dn=2 df=3797 of=0 ri=1266 ql=10 b=10
-  7 c=4012 g=4013 pq=1 pqc=4012 qp=1 rpfq=3 rp=1fa2 dt=6199/1 dn=2 df=2795 of=0 ri=2162 ql=28 b=10
+rcu:
+  0 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=10951/1 dn=0 df=1101 of=0 ri=36 ql=0 b=10
+  1 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=16117/1 dn=0 df=1015 of=0 ri=0 ql=0 b=10
+  2 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=1445/1 dn=0 df=1839 of=0 ri=0 ql=0 b=10
+  3 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=6681/1 dn=0 df=1545 of=0 ri=0 ql=0 b=10
+  4 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=1003/1 dn=0 df=1992 of=0 ri=0 ql=0 b=10
+  5 c=17829 g=17830 pq=1 pqc=17829 qp=1 dt=3887/1 dn=0 df=3331 of=0 ri=4 ql=2 b=10
+  6 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=859/1 dn=0 df=3224 of=0 ri=0 ql=0 b=10
+  7 c=17829 g=17830 pq=0 pqc=17829 qp=1 dt=3761/1 dn=0 df=1818 of=0 ri=0 ql=2 b=10
 rcu_bh:
-  0 c=-268 g=-268 pq=1 pqc=-268 qp=0 rpfq=-145 rp=21d6 dt=23301/73 dn=2 df=0 of=0 ri=0 ql=0 b=10
-  1 c=-268 g=-268 pq=1 pqc=-268 qp=1 rpfq=-170 rp=20ce dt=78073/1 dn=2 df=26 of=0 ri=5 ql=0 b=10
-  2 c=-268 g=-268 pq=1 pqc=-268 qp=1 rpfq=-83 rp=fbd dt=16646/0 dn=2 df=28 of=0 ri=4 ql=0 b=10
-  3 c=-268 g=-268 pq=1 pqc=-268 qp=0 rpfq=-105 rp=178c dt=21159/1 dn=2 df=28 of=0 ri=2 ql=0 b=10
-  4 c=-268 g=-268 pq=1 pqc=-268 qp=1 rpfq=-30 rp=b54 dt=5783/1 dn=2 df=32 of=0 ri=0 ql=0 b=10
-  5 c=-268 g=-268 pq=1 pqc=-268 qp=1 rpfq=-29 rp=df5 dt=5879/1 dn=2 df=30 of=0 ri=3 ql=0 b=10
-  6 c=-268 g=-268 pq=1 pqc=-268 qp=1 rpfq=-28 rp=788 dt=5847/1 dn=2 df=32 of=0 ri=0 ql=0 b=10
-  7 c=-268 g=-268 pq=1 pqc=-268 qp=1 rpfq=-53 rp=1098 dt=6199/1 dn=2 df=30 of=0 ri=3 ql=0 b=10
+  0 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=10951/1 dn=0 df=0 of=0 ri=0 ql=0 b=10
+  1 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=16117/1 dn=0 df=13 of=0 ri=0 ql=0 b=10
+  2 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=1445/1 dn=0 df=15 of=0 ri=0 ql=0 b=10
+  3 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=6681/1 dn=0 df=9 of=0 ri=0 ql=0 b=10
+  4 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=1003/1 dn=0 df=15 of=0 ri=0 ql=0 b=10
+  5 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=3887/1 dn=0 df=15 of=0 ri=0 ql=0 b=10
+  6 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=859/1 dn=0 df=15 of=0 ri=0 ql=0 b=10
+  7 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=3761/1 dn=0 df=15 of=0 ri=0 ql=0 b=10
 
 The first section lists the rcu_data structures for rcu, the second for
 rcu_bh.  Each section has one line per CPU, or eight for this 8-CPU system.
@@ -253,12 +254,6 @@ o	"pqc" indicates which grace period the last-observed quiescent
 o	"qp" indicates that RCU still expects a quiescent state from
 	this CPU.
 
-o	"rpfq" is the number of rcu_pending() calls on this CPU required
-	to induce this CPU to invoke force_quiescent_state().
-
-o	"rp" is low-order four hex digits of the count of how many times
-	rcu_pending() has been invoked on this CPU.
-
 o	"dt" is the current value of the dyntick counter that is incremented
 	when entering or leaving dynticks idle state, either by the
 	scheduler or by irq.  The number after the "/" is the interrupt
@@ -305,6 +300,9 @@ o	"b" is the batch limit for this CPU.  If more than this number
 	of RCU callbacks is ready to invoke, then the remainder will
 	be deferred.
 
+There is also an rcu/rcudata.csv file with the same information in
+comma-separated-variable spreadsheet format.
+
 
 The output of "cat rcu/rcugp" looks as follows:
 
@@ -411,3 +409,63 @@ o	Each element of the form "1/1 0:127 ^0" represents one struct
 		For example, the first entry at the lowest level shows
 		"^0", indicating that it corresponds to bit zero in
 		the first entry at the middle level.
+
+
+The output of "cat rcu/rcu_pending" looks as follows:
+
+rcu:
+  0 np=255892 qsp=53936 cbr=0 cng=14417 gpc=10033 gps=24320 nf=6445 nn=146741
+  1 np=261224 qsp=54638 cbr=0 cng=25723 gpc=16310 gps=2849 nf=5912 nn=155792
+  2 np=237496 qsp=49664 cbr=0 cng=2762 gpc=45478 gps=1762 nf=1201 nn=136629
+  3 np=236249 qsp=48766 cbr=0 cng=286 gpc=48049 gps=1218 nf=207 nn=137723
+  4 np=221310 qsp=46850 cbr=0 cng=26 gpc=43161 gps=4634 nf=3529 nn=123110
+  5 np=237332 qsp=48449 cbr=0 cng=54 gpc=47920 gps=3252 nf=201 nn=137456
+  6 np=219995 qsp=46718 cbr=0 cng=50 gpc=42098 gps=6093 nf=4202 nn=120834
+  7 np=249893 qsp=49390 cbr=0 cng=72 gpc=38400 gps=17102 nf=41 nn=144888
+rcu_bh:
+  0 np=146741 qsp=1419 cbr=0 cng=6 gpc=0 gps=0 nf=2 nn=145314
+  1 np=155792 qsp=12597 cbr=0 cng=0 gpc=4 gps=8 nf=3 nn=143180
+  2 np=136629 qsp=18680 cbr=0 cng=0 gpc=7 gps=6 nf=0 nn=117936
+  3 np=137723 qsp=2843 cbr=0 cng=0 gpc=10 gps=7 nf=0 nn=134863
+  4 np=123110 qsp=12433 cbr=0 cng=0 gpc=4 gps=2 nf=0 nn=110671
+  5 np=137456 qsp=4210 cbr=0 cng=0 gpc=6 gps=5 nf=0 nn=133235
+  6 np=120834 qsp=9902 cbr=0 cng=0 gpc=6 gps=3 nf=2 nn=110921
+  7 np=144888 qsp=26336 cbr=0 cng=0 gpc=8 gps=2 nf=0 nn=118542
+
+As always, this is once again split into "rcu" and "rcu_bh" portions.
+The fields are as follows:
+
+o	"np" is the number of times that __rcu_pending() has been invoked
+	for the corresponding flavor of RCU.
+
+o	"qsp" is the number of times that the RCU was waiting for a
+	quiescent state from this CPU.
+
+o	"cbr" is the number of times that this CPU had RCU callbacks
+	that had passed through a grace period, and were thus ready
+	to be invoked.
+
+o	"cng" is the number of times that this CPU needed another
+	grace period while RCU was idle.
+
+o	"gpc" is the number of times that an old grace period had
+	completed, but this CPU was not yet aware of it.
+
+o	"gps" is the number of times that a new grace period had started,
+	but this CPU was not yet aware of it.
+
+o	"nf" is the number of times that this CPU suspected that the
+	current grace period had run for too long, and thus needed to
+	be forced.
+
+	Please note that "forcing" consists of sending resched IPIs
+	to holdout CPUs.  If that CPU really still is in an old RCU
+	read-side critical section, then we really do have to wait for it.
+	The assumption behing "forcing" is that the CPU is not still in
+	an old RCU read-side critical section, but has not yet responded
+	for some other reason.
+
+o	"nn" is the number of times that this CPU needed nothing.  Alert
+	readers will note that the rcu "nn" number for a given CPU very
+	closely matches the rcu_bh "np" number for that same CPU.  This
+	is due to short-circuit evaluation in rcu_pending().
-- 
1.5.2.5

