Return-Path: <linux-kernel-owner+w=401wt.eu-S1754316AbZKHP4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316AbZKHP4P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 10:56:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662AbZKHP4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 10:56:14 -0500
Received: from icebox.esperi.org.uk ([81.187.191.129]:39127 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303AbZKHP4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 10:56:14 -0500
To: "Tantilov, Emil S" <emil.s.tantilov@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
Subject: Re: [E1000-devel] [in-tree drivers] freezing e1000e in 2.6.31 (SMP only? MSI?)
References: <873a4rqu9o.fsf@spindle.srvr.nix>
	<EA929A9653AAE14F841771FB1DE5A1365F9923A504@rrsmsx501.amr.corp.intel.com>
From: Nix <nix@esperi.org.uk>
Emacs: a Lisp interpreter masquerading as ... a Lisp interpreter!
Date: Sun, 08 Nov 2009 15:55:58 +0000
In-Reply-To: <EA929A9653AAE14F841771FB1DE5A1365F9923A504@rrsmsx501.amr.corp.intel.com> (Emil S. Tantilov's message of "Fri, 6 Nov 2009 16:58:09 -0700")
Message-ID: <87ljihnh81.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b29 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-wuwien-Metrics: spindle 1290; Body=3 Fuz1=3 Fuz2=3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 Nov 2009, Emil S. Tantilov verbalised:

> Nix wrote:
>> Ever since 2.6.31 was released, my gigabit e1000e link has been acting
>> up. Notably, under sufficient load (generally, on this machine, NFS
>> load), packets cease to be transferred, and the (MSI) interrupt count
>> ceases to rise. Pulling the interface down and bringing it back up
>> works, both via ip(8) and by simply yanking the cable and plugging it
>> in again.
>
> Can you please send the output of ethtool -S from the interface after you observe the failure?

Sure:

NIC statistics:
     rx_packets: 16502510
     tx_packets: 16371898
     rx_bytes: 14021876468
     tx_bytes: 13559743390
     rx_broadcast: 4011
     tx_broadcast: 69508
     rx_multicast: 146
     tx_multicast: 159
     rx_errors: 0
     tx_errors: 0
     tx_dropped: 0
     multicast: 146
     collisions: 0
     rx_length_errors: 0
     rx_over_errors: 0
     rx_crc_errors: 0
     rx_frame_errors: 0
     rx_no_buffer_count: 0
     rx_missed_errors: 130
     tx_aborted_errors: 0
     tx_carrier_errors: 0
     tx_fifo_errors: 0
     tx_heartbeat_errors: 0
     tx_window_errors: 0
     tx_abort_late_coll: 0
     tx_deferred_ok: 0
     tx_single_coll_ok: 0
     tx_multi_coll_ok: 0
     tx_timeout_count: 22
     tx_restart_queue: 61194
     rx_long_length_errors: 0
     rx_short_length_errors: 0
     rx_align_errors: 0
     tx_tcp_seg_good: 100122
     tx_tcp_seg_failed: 0
     rx_flow_control_xon: 1452391
     rx_flow_control_xoff: 1452502
     tx_flow_control_xon: 569948727
     tx_flow_control_xoff: 432717010
     rx_long_byte_count: 14021876468
     rx_csum_offload_good: 16478902
     rx_csum_offload_errors: 22235
     rx_header_split: 6854792
     alloc_rx_buff_failed: 0
     tx_smbus: 0
     rx_smbus: 0
     dropped_smbus: 0
     rx_dma_failed: 0
     tx_dma_failed: 0

I did a floodping out of the dead interface (100% packet loss) for a few
seconds and got some more:

NIC statistics:
     rx_packets: 16502523
     tx_packets: 16371898
     rx_bytes: 14021877794
     tx_bytes: 13559743390
     rx_broadcast: 4012
     tx_broadcast: 69508
     rx_multicast: 146
     tx_multicast: 159
     rx_errors: 0
     tx_errors: 0
     tx_dropped: 0
     multicast: 146
     collisions: 0
     rx_length_errors: 0
     rx_over_errors: 0
     rx_crc_errors: 0
     rx_frame_errors: 0
     rx_no_buffer_count: 0
     rx_missed_errors: 132
     tx_aborted_errors: 0
     tx_carrier_errors: 0
     tx_fifo_errors: 0
     tx_heartbeat_errors: 0
     tx_window_errors: 0
     tx_abort_late_coll: 0
     tx_deferred_ok: 0
     tx_single_coll_ok: 0
     tx_multi_coll_ok: 0
     tx_timeout_count: 22
     tx_restart_queue: 61194
     rx_long_length_errors: 0
     rx_short_length_errors: 0
     rx_align_errors: 0
     tx_tcp_seg_good: 100122
     tx_tcp_seg_failed: 0
     rx_flow_control_xon: 1452391
     rx_flow_control_xoff: 1452502
     tx_flow_control_xon: 623287688
     tx_flow_control_xoff: 432717010
     rx_long_byte_count: 14021877794
     rx_csum_offload_good: 16478902
     rx_csum_offload_errors: 22235
     rx_header_split: 6854792
     alloc_rx_buff_failed: 0
     tx_smbus: 0
     rx_smbus: 0
     dropped_smbus: 0
     rx_dma_failed: 0
     tx_dma_failed: 0


> Also try disabling Tx pause frames:
> ethtool -A fastnet tx off autoneg off

Trying that now. No freezes yet, but I haven't really given it long
enough.


Further mysteries: a couple of times bringing the interface down and up
again hasn't sufficed to fix it: I've had to do it multiple times. (It's
possible that this just the same bug being tripped again by the flood of
blocked traffic once the if comes up). Just once, the interface came back
on its own, without my needing to do a thing.

(Just in case, I changed the cable and the switch it's connected to. No
change. Of course given my luck that just means I have *two* bad cables
or switches ;P )
