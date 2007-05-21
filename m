Return-Path: <linux-kernel-owner+w=401wt.eu-S1759806AbXEUJfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759806AbXEUJfr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 05:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755944AbXEUJfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 05:35:40 -0400
Received: from mx2.go2.pl ([193.17.41.42]:57892 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755672AbXEUJfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 05:35:39 -0400
Date: Mon, 21 May 2007 11:42:24 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation/memory-barriers.txt: various fixes
Message-ID: <20070521094224.GB1695@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I think at least some of these fixes are justified.
There are 3 causes of them:

- uniformness e.g. in titles or CPU numbering,
- typos e.g. numbering of items,
- the grammar: the most doubtful, so feel free to omit any of these
  proposals in the final patch.

(Probably something could be done yet with the cache lines vs cachelines,
too - or maybe I don't distinguish them enough...)

Regards,
Jarek P.

--->

Documentation/memory-barriers.txt: various fixes

Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>

---

diff -Nur 2.6.22-rc1-git7-/Documentation/memory-barriers.txt 2.6.22-rc1-git7/Documentation/memory-barriers.txt
--- 2.6.22-rc1-git7-/Documentation/memory-barriers.txt	2007-04-26 15:08:32.000000000 +0200
+++ 2.6.22-rc1-git7/Documentation/memory-barriers.txt	2007-05-20 13:37:24.000000000 +0200
@@ -24,7 +24,7 @@
  (*) Explicit kernel barriers.
 
      - Compiler barrier.
-     - The CPU memory barriers.
+     - CPU memory barriers.
      - MMIO write barrier.
 
  (*) Implicit kernel memory barriers.
@@ -265,8 +265,8 @@
 ordering over the memory operations on either side of the barrier.
 
 Such enforcement is important because the CPUs and other devices in a system
-can use a variety of tricks to improve performance - including reordering,
-deferral and combination of memory operations; speculative loads; speculative
+can use a variety of tricks to improve performance - including: reordering,
+deferral and combination of memory operations, speculative loads, speculative
 branch prediction and various types of caching.  Memory barriers are used to
 override or suppress these tricks, allowing the code to sanely control the
 interaction of multiple CPUs and/or devices.
@@ -300,7 +300,7 @@
      A data dependency barrier is a weaker form of read barrier.  In the case
      where two loads are performed such that the second depends on the result
      of the first (eg: the first load retrieves the address to which the second
-     load will be directed), a data dependency barrier would be required to
+     load will be directed), the data dependency barrier would be required to
      make sure that the target of the second load is updated before the address
      obtained by the first load is accessed.
 
@@ -457,8 +457,8 @@
 	(Q == &A) implies (D == 1)
 	(Q == &B) implies (D == 4)
 
-But! CPU 2's perception of P may be updated _before_ its perception of B, thus
-leading to the following situation:
+But (!) CPU 2's perception of P may be updated _before_ its perception of B,
+thus leading to the following situation:
 
 	(Q == &B) and (D == 2) ????
 
@@ -546,10 +546,10 @@
 When dealing with CPU-CPU interactions, certain types of memory barrier should
 always be paired.  A lack of appropriate pairing is almost certainly an error.
 
-A write barrier should always be paired with a data dependency barrier or read
-barrier, though a general barrier would also be viable.  Similarly a read
-barrier or a data dependency barrier should always be paired with at least an
-write barrier, though, again, a general barrier is viable:
+A write barrier should always be paired with a data dependency barrier or a
+read barrier, though a general barrier would also be viable.  Similarly the
+read barrier or the data dependency barrier should always be paired with at
+least the write barrier, though, again, the general barrier is viable:
 
 	CPU 1		CPU 2
 	===============	===============
@@ -573,7 +573,7 @@
 the "weaker" type.
 
 [!] Note that the stores before the write barrier would normally be expected to
-match the loads after the read barrier or data dependency barrier, and vice
+match the loads after the read barrier or the data dependency barrier, and vice
 versa:
 
 	CPU 1                           CPU 2
@@ -588,7 +588,7 @@
 EXAMPLES OF MEMORY BARRIER SEQUENCES
 ------------------------------------
 
-Firstly, write barriers act as a partial orderings on store operations.
+Firstly, write barriers act as partial orderings on store operations.
 Consider the following sequence of events:
 
 	CPU 1
@@ -602,21 +602,21 @@
 
 This sequence of events is committed to the memory coherence system in an order
 that the rest of the system might perceive as the unordered set of { STORE A,
-STORE B, STORE C } all occurring before the unordered set of { STORE D, STORE E
-}:
+STORE B, STORE C } - all occurring before the unordered set of { STORE D, STORE
+E }:
 
 	+-------+       :      :
 	|       |       +------+
 	|       |------>| C=3  |     }     /\
-	|       |  :    +------+     }-----  \  -----> Events perceptible
-	|       |  :    | A=1  |     }        \/       to rest of system
+	|       |  :    +------+     }-----  \  -----> Events perceptible to
+	|       |  :    | A=1  |     }        \/       the rest of the system
 	|       |  :    +------+     }
 	| CPU 1 |  :    | B=2  |     }
 	|       |       +------+     }
 	|       |   wwwwwwwwwwwwwwww }   <--- At this point the write barrier
 	|       |       +------+     }        requires all stores prior to the
-	|       |  :    | E=5  |     }        barrier to be committed before
-	|       |  :    +------+     }        further stores may be take place.
+	|       |  :    | E=5  |     }        barrier to be committed, before
+	|       |  :    +------+     }        further stores may take place
 	|       |------>| D=4  |     }
 	|       |       +------+
 	+-------+       :      :
@@ -626,7 +626,7 @@
 	                   V
 
 
-Secondly, data dependency barriers act as a partial orderings on data-dependent
+Secondly, data dependency barriers act as partial orderings on data-dependent
 loads.  Consider the following sequence of events:
 
 	CPU 1			CPU 2
@@ -644,7 +644,7 @@
 
 	+-------+       :      :                :       :
 	|       |       +------+                +-------+  | Sequence of update
-	|       |------>| B=2  |-----       --->| Y->8  |  | of perception on
+	|       |------>| B=2  |-----       --->| Y->8  |  | perception on
 	|       |  :    +------+     \          +-------+  | CPU 2
 	| CPU 1 |  :    | A=1  |      \     --->| C->&Y |  V
 	|       |       +------+       |        +-------+
@@ -975,7 +975,7 @@
 
 	barrier();
 
-This a general barrier - lesser varieties of compiler barrier do not exist.
+This is a general barrier - lesser varieties of compiler barrier do not exist.
 
 The compiler barrier has no direct effect on the CPU, which may then reorder
 things however it wishes.
@@ -997,7 +997,7 @@
 All CPU memory barriers unconditionally imply compiler barriers.
 
 SMP memory barriers are reduced to compiler barriers on uniprocessor compiled
-systems because it is assumed that a CPU will be appear to be self-consistent,
+systems because it is assumed that a CPU will appear to be self-consistent,
 and will order overlapping accesses correctly with respect to itself.
 
 [!] Note that SMP memory barriers _must_ be used to control the ordering of
@@ -1143,14 +1143,14 @@
      signal whilst asleep waiting for the lock to become available.  Failed
      locks do not imply any sort of barrier.
 
-Therefore, from (1), (2) and (4) an UNLOCK followed by an unconditional LOCK is
-equivalent to a full barrier, but a LOCK followed by an UNLOCK is not.
+Therefore, from (1), (2) and (4) the UNLOCK followed by the unconditional LOCK
+is equivalent to a full barrier, but the LOCK followed by the UNLOCK is not.
 
-[!] Note: one of the consequence of LOCKs and UNLOCKs being only one-way
-    barriers is that the effects instructions outside of a critical section may
-    seep into the inside of the critical section.
+[!] Note: one of the consequences of LOCKs and UNLOCKs being only one-way
+    barriers is that the effects of instructions outside of a critical section
+    may seep into the inside of the critical section.
 
-A LOCK followed by an UNLOCK may not be assumed to be full memory barrier
+The LOCK followed by the UNLOCK may not be assumed to be full memory barrier
 because it is possible for an access preceding the LOCK to happen after the
 LOCK, and an access following the UNLOCK to happen before the UNLOCK, and the
 two accesses can themselves then cross:
@@ -1239,7 +1239,7 @@
 	UNLOCK M			UNLOCK Q
 	*D = d;				*H = h;
 
-Then there is no guarantee as to what order CPU #3 will see the accesses to *A
+Then there is no guarantee, as to what order CPU 3 will see the accesses to *A
 through *H occur in, other than the constraints imposed by the separate locks
 on the separate CPUs. It might, for example, see:
 
@@ -1269,12 +1269,12 @@
 					UNLOCK M	[2]
 					*H = h;
 
-CPU #3 might see:
+CPU 3 might see:
 
 	*E, LOCK M [1], *C, *B, *A, UNLOCK M [1],
 		LOCK M [2], *H, *F, *G, UNLOCK M [2], *D
 
-But assuming CPU #1 gets the lock first, it won't see any of:
+But assuming CPU 1 gets the lock first, CPU 3 won't see any of:
 
 	*B, *C, *D, *F, *G or *H preceding LOCK M [1]
 	*A, *B or *C following UNLOCK M [1]
@@ -1327,12 +1327,12 @@
 					mmiowb();
 					spin_unlock(Q);
 
-this will ensure that the two stores issued on CPU #1 appear at the PCI bridge
-before either of the stores issued on CPU #2.
+this will ensure that the two stores issued on CPU 1 appear at the PCI bridge
+before either of the stores issued on CPU 2.
 
 
-Furthermore, following a store by a load to the same device obviates the need
-for an mmiowb(), because the load forces the store to complete before the load
+Furthermore, following a store by a load from the same device obviates the need
+for the mmiowb(), because the load forces the store to complete before the load
 is performed:
 
 	CPU 1				CPU 2
@@ -1363,7 +1363,7 @@
 
  (*) Atomic operations.
 
- (*) Accessing devices (I/O).
+ (*) Accessing devices.
 
  (*) Interrupts.
 
@@ -1375,7 +1375,7 @@
 system may be working on the same data set at the same time.  This can cause
 synchronisation problems, and the usual way of dealing with them is to use
 locks.  Locks, however, are quite expensive, and so it may be preferable to
-operate without the use of a lock if at all possible.  In such a case
+operate without the use of the lock if at all possible.  In such a case
 operations that affect both CPUs may have to be carefully ordered to prevent
 a malfunction.
 
@@ -1396,10 +1396,10 @@
 
 To wake up a particular waiter, the up_read() or up_write() functions have to:
 
- (1) read the next pointer from this waiter's record to know as to where the
-     next waiter record is;
+ (1) read the list.next pointer from this waiter's record to know as to where
+     the next waiter record is;
 
- (4) read the pointer to the waiter's task structure;
+ (2) read the pointer to the waiter's task structure;
 
  (3) clear the task pointer to tell the waiter it has been given the semaphore;
 
@@ -1407,7 +1407,7 @@
 
  (5) release the reference held on the waiter's task struct.
 
-In otherwords, it has to perform this sequence of events:
+In other words, it has to perform this sequence of events:
 
 	LOAD waiter->list.next;
 	LOAD waiter->task;
@@ -1423,7 +1423,7 @@
 before proceeding.  Since the record is on the waiter's stack, this means that
 if the task pointer is cleared _before_ the next pointer in the list is read,
 another CPU might start processing the waiter and might clobber the waiter's
-stack before the up*() function has a chance to read the next pointer.
+stack before the up_*() function has a chance to read the next pointer.
 
 Consider then what might happen to the above sequence of events:
 
@@ -1502,7 +1502,7 @@
 such the implicit memory barrier effects are necessary.
 
 
-The following operation are potential problems as they do _not_ imply memory
+The following operations are potential problems as they do _not_ imply memory
 barriers, but might be used for implementing such things as UNLOCK-class
 operations:
 
@@ -1517,7 +1517,7 @@
 
 The following also do _not_ imply memory barriers, and so may require explicit
 memory barriers under some circumstances (smp_mb__before_atomic_dec() for
-instance)):
+instance):
 
 	atomic_add();
 	atomic_sub();
@@ -1530,7 +1530,8 @@
 If they're used for reference counting on an object to control its lifetime,
 they probably don't need memory barriers because either the reference count
 will be adjusted inside a locked section, or the caller will already hold
-sufficient references to make the lock, and thus a memory barrier unnecessary.
+sufficient references to make the lock, and thus the memory barrier
+unnecessary.
 
 If they're used for constructing a lock of some description, then they probably
 do need memory barriers as a lock primitive generally has to do things in a
@@ -1641,8 +1642,8 @@
      indeed have special I/O space access cycles and instructions, but many
      CPUs don't have such a concept.
 
-     The PCI bus, amongst others, defines an I/O space concept - which on such
-     CPUs as i386 and x86_64 cpus readily maps to the CPU's concept of I/O
+     The PCI bus, amongst others, defines an I/O space concept which - on such
+     CPUs as i386 and x86_64 - readily maps to the CPU's concept of I/O
      space.  However, it may also be mapped as a virtual I/O space in the CPU's
      memory map, particularly on those CPUs that don't support alternate I/O
      spaces.
@@ -1659,16 +1660,16 @@
  (*) readX(), writeX():
 
      Whether these are guaranteed to be fully ordered and uncombined with
-     respect to each other on the issuing CPU depends on the characteristics
+     respect to each other on the issuing CPU - depends on the characteristics
      defined for the memory window through which they're accessing. On later
      i386 architecture machines, for example, this is controlled by way of the
      MTRR registers.
 
-     Ordinarily, these will be guaranteed to be fully ordered and uncombined,,
+     Ordinarily, these will be guaranteed to be fully ordered and uncombined,
      provided they're not accessing a prefetchable device.
 
      However, intermediary hardware (such as a PCI bridge) may indulge in
-     deferral if it so wishes; to flush a store, a load from the same location
+     deferral if it wishes so; to flush a store, a load from the same location
      is preferred[*], but a load from the same device or from configuration
      space should suffice for PCI.
 
@@ -1689,7 +1690,7 @@
 
  (*) ioreadX(), iowriteX()
 
-     These will perform as appropriate for the type of access they're actually
+     These will perform appropriately for the type of access they're actually
      doing, be it inX()/outX() or readX()/writeX().
 
 
@@ -1705,7 +1706,7 @@
 
 This means that it must be considered that the CPU will execute its instruction
 stream in any order it feels like - or even in parallel - provided that if an
-instruction in the stream depends on the an earlier instruction, then that
+instruction in the stream depends on an earlier instruction, then that
 earlier instruction must be sufficiently complete[*] before the later
 instruction may proceed; in other words: provided that the appearance of
 causality is maintained.
@@ -1795,8 +1796,8 @@
 become apparent in the same order on those other CPUs.
 
 
-Consider dealing with a system that has pair of CPUs (1 & 2), each of which has
-a pair of parallel data caches (CPU 1 has A/B, and CPU 2 has C/D):
+Consider dealing with a system that has a pair of CPUs (1 & 2), each of which
+has a pair of parallel data caches (CPU 1 has A/B, and CPU 2 has C/D):
 
 	            :
 	            :                          +--------+
@@ -1835,7 +1836,7 @@
 
  (*) the coherency queue is not flushed by normal loads to lines already
      present in the cache, even though the contents of the queue may
-     potentially effect those loads.
+     potentially affect those loads.
 
 Imagine, then, that two writes are made on the first CPU, with a write barrier
 between them to guarantee that they will appear to reach that CPU's caches in
@@ -1845,7 +1846,7 @@
 	===============	===============	=======================================
 					u == 0, v == 1 and p == &u, q == &u
 	v = 2;
-	smp_wmb();			Make sure change to v visible before
+	smp_wmb();			Make sure change to v is visible before
 					 change to p
 	<A:modify v=2>			v is now in cache A exclusively
 	p = &v;
@@ -1853,7 +1854,7 @@
 
 The write memory barrier forces the other CPUs in the system to perceive that
 the local CPU's caches have apparently been updated in the correct order.  But
-now imagine that the second CPU that wants to read those values:
+now imagine that the second CPU wants to read those values:
 
 	CPU 1		CPU 2		COMMENT
 	===============	===============	=======================================
@@ -1861,7 +1862,7 @@
 			q = p;
 			x = *q;
 
-The above pair of reads may then fail to happen in expected order, as the
+The above pair of reads may then fail to happen in the expected order, as the
 cacheline holding p may get updated in one of the second CPU's caches whilst
 the update to the cacheline holding v is delayed in the other of the second
 CPU's caches by some other cache event:
@@ -1916,7 +1917,7 @@
 
 Other CPUs may also have split caches, but must coordinate between the various
 cachelets for normal memory accesses.  The semantics of the Alpha removes the
-need for coordination in absence of memory barriers.
+need for coordination in the absence of memory barriers.
 
 
 CACHE COHERENCY VS DMA
@@ -1931,10 +1932,10 @@
 
 In addition, the data DMA'd to RAM by a device may be overwritten by dirty
 cache lines being written back to RAM from a CPU's cache after the device has
-installed its own data, or cache lines simply present in a CPUs cache may
-simply obscure the fact that RAM has been updated, until at such time as the
-cacheline is discarded from the CPU's cache and reloaded.  To deal with this,
-the appropriate part of the kernel must invalidate the overlapping bits of the
+installed its own data, or cache lines present in the CPU's cache may simply
+obscure the fact that RAM has been updated, until at such time as the cacheline
+is discarded from the CPU's cache and reloaded.  To deal with this, the
+appropriate part of the kernel must invalidate the overlapping bits of the
 cache on each CPU.
 
 See Documentation/cachetlb.txt for more information on cache management.
@@ -1944,7 +1945,7 @@
 -----------------------
 
 Memory mapped I/O usually takes place through memory locations that are part of
-a window in the CPU's memory space that have different properties assigned than
+a window in the CPU's memory space that has different properties assigned than
 the usual RAM directed window.
 
 Amongst these properties is usually the fact that such accesses bypass the
@@ -1960,7 +1961,7 @@
 =========================
 
 A programmer might take it for granted that the CPU will perform memory
-operations in exactly the order specified, so that if a CPU is, for example,
+operations in exactly the order specified, so that if the CPU is, for example,
 given the following piece of code to execute:
 
 	a = *A;
@@ -1969,7 +1970,7 @@
 	d = *D;
 	*E = e;
 
-They would then expect that the CPU will complete the memory operation for each
+they would then expect that the CPU will complete the memory operation for each
 instruction before moving on to the next one, leading to a definite sequence of
 operations as seen by external observers in the system:
 
@@ -1986,8 +1987,8 @@
  (*) loads may be done speculatively, and the result discarded should it prove
      to have been unnecessary;
 
- (*) loads may be done speculatively, leading to the result having being
-     fetched at the wrong time in the expected sequence of events;
+ (*) loads may be done speculatively, leading to the result having been fetched
+     at the wrong time in the expected sequence of events;
 
  (*) the order of the memory accesses may be rearranged to promote better use
      of the CPU buses and caches;
@@ -2069,12 +2070,12 @@
 
 The DEC Alpha CPU is one of the most relaxed CPUs there is.  Not only that,
 some versions of the Alpha CPU have a split data cache, permitting them to have
-two semantically related cache lines updating at separate times.  This is where
+two semantically related cache lines updated at separate times.  This is where
 the data dependency barrier really becomes necessary as this synchronises both
 caches with the memory coherence system, thus making it seem like pointer
 changes vs new data occur in the right order.
 
-The Alpha defines the Linux's kernel's memory barrier model.
+The Alpha defines the Linux kernel's memory barrier model.
 
 See the subsection on "Cache Coherency" above.
 
