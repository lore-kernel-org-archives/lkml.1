Return-Path: <linux-kernel-owner+w=401wt.eu-S1754183AbYKXX11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183AbYKXX11 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 18:27:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbYKXX1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 18:27:19 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:38042 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753126AbYKXX1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 18:27:17 -0500
Subject: [Patch 1/3] OProfile SPU event profiling support for IBM Cell
	processor
From: Carl Love <cel@us.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>, linux-kernel <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, oprofile-list@lists.sourceforge.net,
       cel <cel@linux.vnet.ibm.com>, cbe-oss-dev <cbe-oss-dev@ozlabs.org>
Content-Type: text/plain
Date: Mon, 24 Nov 2008 15:26:22 -0800
Message-Id: <1227569182.6509.212.camel@carll-linux-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the SPU events for the IBM Cell processor to the 
list of available events to the user level tool.

Signed-off-by: Carl Love <carll@us.ibm.com>

Index: oprofile-0.9.4/events/ppc64/cell-be/events
===================================================================
--- oprofile-0.9.4.orig/events/ppc64/cell-be/events
+++ oprofile-0.9.4/events/ppc64/cell-be/events
@@ -108,12 +108,42 @@ event:0xdbe counters:0,1,2,3 um:PPU_0_cy
 event:0xdbf counters:0,1,2,3 um:PPU_0_cycles          minimum:10000	name:stb_not_empty		: At least one store gather buffer not empty.
 
 # Cell BE Island 4 - Synergistic Processor Unit (SPU)
-
+#
+# OPROFILE FOR CELL ONLY SUPPORTS PROFILING ON ONE SPU EVENT AT A TIME
+#
 # CBE Signal Group 41 - SPU (NClk)
+event:0x1004 counters:0 um:SPU_02_cycles          minimum:10000	name:dual_instrctn_commit	: Dual instruction committed.
+event:0x1005 counters:0 um:SPU_02_cycles          minimum:10000	name:sngl_instrctn_commit	: Single instruction committed.
+event:0x1006 counters:0 um:SPU_02_cycles          minimum:10000	name:ppln0_instrctn_commit	: Pipeline 0 instruction committed.
+event:0x1007 counters:0 um:SPU_02_cycles          minimum:10000	name:ppln1_instrctn_commit	: Pipeline 1 instruction committed.
+event:0x1008 counters:0 um:SPU_02_cycles_or_edges minimum:10000	name:instrctn_ftch_stll	: Instruction fetch stall.
+event:0x1009 counters:0 um:SPU_02_cycles_or_edges minimum:10000	name:lcl_strg_bsy		: Local storage busy.
+event:0x100A counters:0 um:SPU_02_cycles          minimum:10000	name:dma_cnflct_ld_st	: DMA may conflict with load or store.
+event:0x100B counters:0 um:SPU_02_cycles          minimum:10000	name:str_to_lcl_strg	: Store instruction to local storage issued.
+event:0x100C counters:0 um:SPU_02_cycles          minimum:10000	name:ld_frm_lcl_strg	: Load intruction from local storage issued.
+event:0x100D counters:0 um:SPU_02_cycles          minimum:10000	name:fpu_exctn		: Floating-Point Unit (FPU) exception.
+event:0x100E counters:0 um:SPU_02_cycles          minimum:10000	name:brnch_instrctn_commit	: Branch instruction committed.
+event:0x100F counters:0 um:SPU_02_cycles          minimum:10000	name:change_of_flow	: Non-sequential change of the SPU program counter, which can be caused by branch, asynchronous interrupt, stalled wait on channel, error correction code (ECC) error, and so forth.
+event:0x1010 counters:0 um:SPU_02_cycles          minimum:10000	name:brnch_not_tkn		: Branch not taken.
+event:0x1011 counters:0 um:SPU_02_cycles          minimum:10000	name:brnch_mss_prdctn	: Branch miss prediction; not exact. Certain other code sequences can cause additional pulses on this signal (see Note 2).
+event:0x1012 counters:0 um:SPU_02_cycles          minimum:10000	name:brnch_hnt_mss_prdctn	: Branch hint miss prediction; not exact. Certain other code sequences can cause additional pulses on this signal (see Note 2).
+event:0x1013 counters:0 um:SPU_02_cycles          minimum:10000	name:instrctn_seqnc_err	: Instruction sequence error.
+event:0x1015 counters:0 um:SPU_02_cycles_or_edges minimum:10000	name:stlld_wait_on_chnl_wrt	: Stalled waiting on any blocking channel write (see Note 3).
+event:0x1016 counters:0 um:SPU_02_cycles_or_edges minimum:10000	name:stlld_wait_on_chnl0	: Stalled waiting on External Event Status (Channel 0) (see Note 3).
+event:0x1017 counters:0 um:SPU_02_cycles_or_edges minimum:10000	name:stlld_wait_on_chnl3	: Stalled waiting on Signal Notification 1 (Channel 3) (see Note 3).
+event:0x1018 counters:0 um:SPU_02_cycles_or_edges minimum:10000	name:stlld_wait_on_chnl4	: Stalled waiting on Signal Notification 2 (Channel 4) (see Note 3).
+event:0x1019 counters:0 um:SPU_02_cycles_or_edges minimum:10000	name:stlld_wait_on_chnl21	: Stalled waiting on DMA Command Opcode or ClassID Register (Channel 21) (see Note 3).
+event:0x101A counters:0 um:SPU_02_cycles_or_edges minimum:10000	name:stlld_wait_on_chnl24	: Stalled waiting on Tag Group Status (Channel 24) (see Note 3).
+event:0x101B counters:0 um:SPU_02_cycles_or_edges minimum:10000	name:stlld_wait_on_chnl25	: Stalled waiting on List Stall-and-Notify Tag Status (Channel 25) (see Note 3).
+event:0x101C counters:0 um:SPU_02_cycles_or_edges minimum:10000	name:stlld_wait_on_chnl28	: Stalled waiting on PPU Mailbox (Channel 28) (see Note 3).
+event:0x1022 counters:0 um:SPU_02_cycles_or_edges minimum:10000	name:stlld_wait_on_chnl29	: Stalled waiting on SPU Mailbox (Channel 29) (see Note 3).
+
 
 # CBE Signal Group 42 - SPU Trigger (NClk)
+event:0x10A1 counters:0 um:SPU_Trigger_cycles_or_edges minimum:10000	name:stld_wait_chnl_op	: Stalled waiting on channel operation (See Note 2).
 
 # CBE Signal Group 43 - SPU Event (NClk)
+event:0x1107 counters:0 um:SPU_Event_cycles_or_edges minimum:10000	name:instrctn_ftch_stll	: Instruction fetch stall.
 
 # Cell BE Island 6 - Element Interconnect Bus (EIB)
 
Index: oprofile-0.9.4/events/ppc64/cell-be/unit_masks
===================================================================
--- oprofile-0.9.4.orig/events/ppc64/cell-be/unit_masks
+++ oprofile-0.9.4/events/ppc64/cell-be/unit_masks
@@ -72,3 +72,66 @@ name:PPU_0123_cycles type:bitmask defaul
 	0x002 Positive polarity				[default  ]
 	0x030 PPU Bus Word 0/1				[default  ]
 	0x0c0 PPU Bus Word 2/3				[optional ]
+name:SPU_02_cycles type:bitmask default:0x0113
+	0x0001 Count cycles				[mandatory]
+	0x0000 Negative polarity			[optional ]
+	0x0002 Positive polarity			[default  ]
+	0x0110 SPU Bus Word 0				[default  ]
+	0x0140 SPU Bus Word 2				[optional ]
+	0x0000 SPU 0					[default  ]
+	0x1000 SPU 1					[optional ]
+	0x2000 SPU 2					[optional ]
+	0x3000 SPU 3					[optional ]
+	0x4000 SPU 4					[optional ]
+	0x5000 SPU 5					[optional ]
+	0x6000 SPU 6					[optional ]
+	0x7000 SPU 7					[optional ]
+name:SPU_02_cycles_or_edges type:bitmask default:0x0113
+	0x0000 Count edges				[optional ]
+	0x0001 Count cycles				[default  ]
+	0x0000 Negative polarity			[optional ]
+	0x0002 Positive polarity			[default  ]
+	0x0110 SPU Bus Word 0				[default  ]
+	0x0140 SPU Bus Word 2				[optional ]
+	0x0000 SPU 0					[default  ]
+	0x1000 SPU 1					[optional ]
+	0x2000 SPU 2					[optional ]
+	0x3000 SPU 3					[optional ]
+	0x4000 SPU 4					[optional ]
+	0x5000 SPU 5					[optional ]
+	0x6000 SPU 6					[optional ]
+	0x7000 SPU 7					[optional ]
+name:SPU_Trigger_cycles_or_edges type:bitmask default:0x0107
+	0x0000 Count edges				[optional ]
+	0x0001 Count cycles				[default  ]
+	0x0000 Negative polarity			[optional ]
+	0x0002 Positive polarity			[default  ]
+	0x0104 SPU Trigger 0				[default  ]
+	0x0114 SPU Trigger 1				[optional ]
+	0x0124 SPU Trigger 2				[optional ]
+	0x0134 SPU Trigger 3				[optional ]
+	0x0000 SPU 0					[default  ]
+	0x1000 SPU 1					[optional ]
+	0x2000 SPU 2					[optional ]
+	0x3000 SPU 3					[optional ]
+	0x4000 SPU 4					[optional ]
+	0x5000 SPU 5					[optional ]
+	0x6000 SPU 6					[optional ]
+	0x7000 SPU 7					[optional ]
+name:SPU_Event_cycles_or_edges type:bitmask default:0x0147
+	0x0000 Count edges				[optional ]
+	0x0001 Count cycles				[default  ]
+	0x0000 Negative polarity			[optional ]
+	0x0002 Positive polarity			[default  ]
+	0x0144 SPU Event 0				[default  ]
+	0x0154 SPU Event 1				[optional ]
+	0x0164 SPU Event 2				[optional ]
+	0x0174 SPU Event 3				[optional ]
+	0x0000 SPU 0					[default  ]
+	0x1000 SPU 1					[optional ]
+	0x2000 SPU 2					[optional ]
+	0x3000 SPU 3					[optional ]
+	0x4000 SPU 4					[optional ]
+	0x5000 SPU 5					[optional ]
+	0x6000 SPU 6					[optional ]
+	0x7000 SPU 7					[optional ]
Index: oprofile-0.9.4/ChangeLog
===================================================================
--- oprofile-0.9.4.orig/ChangeLog
+++ oprofile-0.9.4/ChangeLog
@@ -1,3 +1,11 @@
+2008-11-17  Carl Love  <carll@us.ibm.com
+	* Added IBM CELL SPU event profiling support.
+	* utils/opcontrol - rewrote Cell tests to validate which
+	  events can be selected at the same time.
+        * events/ppc64/cell-be/events - add CELL SPU events
+	* events/ppc64/cell-be/unit_masks - added CELL SPU
+	  unit masks
+
 2008-07-17  Maynard Johnson  <maynardj@us.ibm.com>
 
 	* configure.in: bump version in AM_INIT_AUTOMAKE to 0.9.4
Index: oprofile-0.9.4/utils/opcontrol
===================================================================
--- oprofile-0.9.4.orig/utils/opcontrol
+++ oprofile-0.9.4/utils/opcontrol
@@ -1154,31 +1154,56 @@ check_event_mapping_data()
 	fi
 	if [ "$CPUTYPE" = "ppc64/cell-be" ]; then
 		event_num=`echo $EVENT_STR | awk '{print $1}'`
-		if [ "$event_num" = "2" ] ; then
-			if [ "$CYCLES" = "1" \
-				-o "$GRP_NUM_CK_VAL" != "" ] ; then
-				echo "ERROR: SPU CYCLES cannot be counted with any other events." >&2
-				exit 1
-			else
-				SPU_CYCLES=2
-				return
-			fi
-		fi
-		if [ "$event_num" = "1" ] ; then
-                        # CYCLES is compatible with any event except SPU_CYCLES
-			if [ "$SPU_CYCLES" = "2" ] ; then
-				echo "ERROR: PPU CYCLES and SPU CYCLES cannot be counted simultaneously." >&2
-				exit 1
-			else
-				CYCLES=1
-				return
-			fi
+		# PPU event and cycle events can be measured at
+		# the same time.  SPU event can not be measured
+		# at the same time as any other event.  Similarly for
+		# SPU Cycles
+
+		# We use EVNT_MSK to track what events have already
+		# been seen.  Valid values are:
+		#    NULL string -  no events seen yet
+		#    1 - PPU CYCLES or PPU Event seen
+		#    2 - SPU CYCLES seen
+		#    3 - SPU EVENT seen
+
+		# check if event is PPU_CYCLES
+		if [ "$event_num" = "1" ]; then
+		    if [ "$EVNT_MSK" = "1" ] || [ "$EVNT_MSK" = "" ]; then
+			EVNT_MSK=1
+		    else
+			echo "PPU CYCLES not compatible with previously specified event"
+			exit 1
+		    fi
+
+		# check if event is SPU_CYCLES
+		elif [ "$event_num" = "2" ]; then
+		    if [ "$EVNT_MSK" = "" ]; then
+			EVNT_MSK=2
+		    else
+			echo "SPU CYCLES not compatible with any other event"
+			exit 1
+		    fi
+
+		# check if event is SPU Event profiling
+		elif [ "$event_num" -ge "4100" ] && [ "$event_num" -le "4163" ] ; then
+		    if [ "$EVNT_MSK" = "" ]; then
+			EVNT_MSK=3
+		    else
+			echo "SPU event profiling not compatible with any other event"
+			exit 1
+		    fi
+
+		# check if event is PPU Event profiling (all other events
+		#     are PPU events)
 		else
-		    if [ "$SPU_CYCLES" = "2" ] ; then
-			echo "ERROR: SPU CYCLES cannot be counted with any other events." >&2
+		    if [ "$EVNT_MSK" = "1" ] || [ "$EVNT_MSK" = "" ]; then
+			EVNT_MSK=1
+		    else
+			echo "PPU profiling not compatible with previously specified event"
 			exit 1
-			fi
+		    fi
 		fi
+
 		len=`echo -n $event_num | wc -m`
 		num_chars_in_grpid=`expr $len - 2`
 		GRP_NUM_VAL=`echo | awk '{print substr("'"${event_num}"'",1,"'"${num_chars_in_grpid}"'")}'`
Index: oprofile-0.9.4/doc/oprofile.xml
===================================================================
--- oprofile-0.9.4.orig/doc/oprofile.xml
+++ oprofile-0.9.4/doc/oprofile.xml
@@ -123,6 +123,10 @@ For information on how to use OProfile's
                        of 2.6.22 or more recent.  Additionally, full support of SPE profiling requires a BFD library
                        from binutils code dated January 2007 or later.  To ensure the proper BFD support exists, run
                        the <code>configure</code> utility with <code>--with-target=cell-be</code>.
+
+		       Profiling the Cell Broadband Engine using SPU events requires a kernel version of 2.6.TBD or
+		       more recent.
+
                        <note>Attempting to profile SPEs with kernel versions older than 2.6.22 may cause the
                        system to crash.</note>
 		</para></listitem>
@@ -1195,6 +1199,12 @@ is collected in the sample data in order
 the performance of each separate SPU is not necessary.
 </para>
 <para>
+Profiling with an SPU event (events 4100 through 4163) is not compatible with any other
+event.  Further more, only one SPU event can be specified at a time.  The hardware only
+supports profiling on one SPU per node at a time.  The OProfile kernel code time slices
+between the eight SPUs to collect data on all SPUs.
+</para>
+<para>
 SPU profile reports have some unique characteristics compared to reports for
 standard architectures:
 </para>


