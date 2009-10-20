Return-Path: <linux-kernel-owner+w=401wt.eu-S1752727AbZJTQdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbZJTQdM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 12:33:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbZJTQdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 12:33:12 -0400
Received: from n21.bullet.mail.mud.yahoo.com ([68.142.206.160]:27409 "HELO
	n21.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752634AbZJTQdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 12:33:11 -0400
X-Yahoo-Newman-Id: 571371.20701.bm@omp410.mail.mud.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: CpHmghkVM1lg1uooZk7vTKceQCiAHPA6GMyUfhdeEPoPDN2YgEzJV8Jg5lNUkWVTaApSL8DqL3bbdu3g_GAFiS332UZNXVlWkmPGG9aatDmv8zdovaVjPO8yJ2j_vVotpGdZPILaocPPcdCetohBKPNkVvmoB5hqpDg4hxYpTWzmMsKE.rkgV.xjnfElcrGFoDUlOIARhFwQN97vIz_bXC3hbds4xbBQhnkao9YDPLO0SDvEfo2Ha7emmm5xFvXGaTKPo23E5C2sNI11pJ7mfOu4HXp95gGRoKI-
X-Yahoo-Newman-Property: ymail-3
Subject: [ANNOUNCE] Initial release of tcm_loop.ko virtual SCSI fabric
	module TCM Core 3.2
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Cc: Hannes Reinecke <hare@suse.de>, Florian Haas <florian.haas@linbit.com>,
       Philipp Reisner <philipp.reisner@linbit.com>,
       Christoph Hellwig <hch@lst.de>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Christie <michaelc@cs.wisc.edu>,
       Richard Sharpe <realrichardsharpe@gmail.com>,
       Boaz Harrosh <bharrosh@panasas.com>, Daniel Walker <dwalker@fifo99.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Avi Kivity <avi@redhat.com>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Anthony Liguori <anthony@codemonkey.ws>
Content-Type: text/plain
Date: Tue, 20 Oct 2009 09:33:13 -0700
Message-Id: <1256056393.4263.150.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings all,

I am happy to announce the first release of the tcm_loop.ko virtual SCSI
fabric module for TCM Core v3.2 that provides CDB-level SPC-3 and above
emulation for SAS Target and Initiator Port Addresses.  This allows
virtual TCM storage objects like BLOCK, FILEIO and RAMDISK to be
presented as locally accessable Linux/SCSI devices (/dev/sdz) using CDB
level emulation capable of TCM/LIO v3.2 T10 NAA WWN naming, Persistent
Reservations, and ALUA logic.

So far, sg_persist is able to span reservations between multiple
emulated SAS I_T Nexues, as well as across iSCSI Target Ports for the
same TCM backend storage object.  Also, the ability to pass the locally
accessable TCM_Loop virtual SCSI luns using scsi_generic SG_IO
passthrough into VM guests of different operating systems (RHEL5 and
NetBSD5 for example) is also up and running on top of the vmw6
hypervisor mpt-fusion HBA emulation on a Linux v2.6.32-rc5 host.

For more information and screenshots, please see:

http://linux-iscsi.org/index.php/TCM_loop

Here is the original running commit for the kernel piece:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=commitdiff;h=10eae38203a01a26fca3b2097f13e48a0ba2d38f

And the tcm_loop.py CLI commit:

http://git.kernel.org/?p=linux/storage/lio/lio-utils.git;a=commitdiff;h=564dcf1733bb8591f02900c644f0694e1fb2af35

There is still some of work to be done in tcm_loop_configfs.c, and the
struct scsi_host_template for the emulated SCSI LLD is pretty much just
queuecommand() and proc() currently, so it needs TMR LUN_RESET.  Also
can_queue needs to be ramped up to 32 and ENABLE_CLUSTERING set, and so
far the tcm_loop virtual SCSI LUNs are able to pass simple badblocks
tests, and able to push bulk I/O.

Thanks!

--nab





