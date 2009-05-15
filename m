Return-Path: <linux-kernel-owner+w=401wt.eu-S1757442AbZEOE3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442AbZEOE3i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 00:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751152AbZEOE3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 00:29:24 -0400
Received: from n23a.bullet.mail.mud.yahoo.com ([68.142.207.189]:27977 "HELO
	n23a.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751556AbZEOE3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 00:29:23 -0400
X-Yahoo-Newman-Id: 269596.77825.bm@omp418.mail.mud.yahoo.com
X-YMail-OSG: xltqR1wVM1kuzpwILP1iSFYQQcDZtrT6kbisvKnsLkSYSqLBLO_vWWMhF1wdiLarRxVcJdRw0eafERWbdK_YAYiulISJaHhhGlG9DviYTshGnZ1WaXl8G0nyIF8uXauRN.GV8dDBymfsPgHCWXEdekrgBjIYF9urpKQ7ReKA7ApLuWA9hcth63ykn5iqtYt.7U7rytGzlLgIEzvGDsZ8qm1cVXboIzeOXkaQi9ZaJ_dbqSV.F6hgXP_9GNiVxLumeObVAqefn50xrEWJW3sveMCzWWGnCmU2IkvUWBxkR7Eh89v1KtAVyf_FmLXbry4idrgcBKMn_VdRqRigPXGLJWcU0kQ14S0F6._TCVJ6fz6_jwRuPeLISJsvKY8lev6fGZ80GWg-
X-Yahoo-Newman-Property: ymail-3
Subject: KVM 10/Gb Ethernet PCIe passthrough with Linux/iSCSI and large
	block sizes
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: kvm-devel <kvm@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>,
       Linux-netdev <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Hannes Reinecke <hare@suse.de>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Sheng Yang <sheng@linux.intel.com>,
       Leonid Grossman <leonid.grossman@neterion.com>,
       Ramkrishna Vepa <Ramkrishna.Vepa@neterion.com>,
       Rastapur Santosh <santosh.rastapur@neterion.com>
Content-Type: text/plain
Date: Thu, 14 May 2009 21:29:21 -0700
Message-Id: <1242361761.21442.276.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings all,

The first test results for Linux/iSCSI Initiators and targets for large
block sizes using 10 Gb/sec Ethernet + PCIe device-passthrough into
Linux/KVM guests have been posted at:

http://linux-iscsi.org/index.php/KVM-LIO-Target

So far, the results have been quite impressive using the Neterion X3100
series hardware with recent KVM-85 stable code (with Marcelo's patches,
see the above link) on v2.6.29.2 KVM guests, and using v2.6.30-rc3 KVM
Hosts.

Using iSCSI RFC defined MC/S to scale a *single* KVM accessable
Linux/iSCSI Logical Unit to 10 Gb/sec line-rate speeds has been
successful using Core-iSCSI WRITE/READ (bi-directional) traffic using
Linux-Test-Project disktest pthreaded benchmark with O_DIRECT enabled.
Using Core-iSCSI MC/S w/ iSCSI READ (uni-directional) the average is
about 6-7 Gb/sec, and with MC/S iSCSI WRITE (uni-directional) the
average is about 5 Gb/sec to the RAMDISK_DR and FILEIO storage objects
for these same streaming tests.  Please see the link for more
information on the tests and hardware/software setup.

The tests have been run with both upstream Open-iSCSI and Core-iSCSI
Initiators against Target_Core_Mod/LIO-Target v3.0 in KVM guests.  It is
important to note that these tests have been run with tcp_sendpage()
disabled (tcp_sendpage() is enabled by default in LIO-Target and
Open-iSCSI) in 10 Gb/sec KVM guests, which have been disable into order
to get up running with the 10 Gb/sec hardware.  1 Gb/sec e1000e ports
are stable with sendpage() in LIO-Target KVM guests, and these will be
enabled in 10 Gb/sec hardware in subsequent tests.  Also note that
Open-iSCSI WRITEs using tcp_sendpage() have been ommited for this first
run of tests.

It is also important to note that both iSCSI MC/S and dm-multipath are
methods to allow a single Linux/SCSI Logical Unit to scale across
multiple TCP connections using the iSCSI Protocol.  Both of these
methods (iSCSI RFC fabric level multiplexing and OS-level SCSI
Multipath) allow for means for scaling across multiple X3110 Vpaths
(MSI-X TX/RX pairs), and MC/S is a method that has a low amount of
overhead.

Some of the future setups for KVM + 10 Gb/sec will be using dm-multipath
block devices, 10 Gb/sec Ethernet PCIe multi-function mode into KVM
guest, as well as PCIe SR-IOV on recent IOMMU capable hardware
platforms.

Many thanks to the Neterion folks and Sheng Yang for answering my
questions!

--nab


