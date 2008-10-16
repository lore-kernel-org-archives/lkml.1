Return-Path: <linux-kernel-owner+w=401wt.eu-S1758712AbYJPXL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712AbYJPXL3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 19:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756781AbYJPXLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 19:11:18 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:24851 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756440AbYJPXLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 19:11:17 -0400
X-YMail-OSG: FPQXVnoVM1nIB4hsZp7EK7WWXPIGYpeAcDCHvAJWBDZJSF37TMB.QnxAbD.J2YJ1.6aplAaycOygVzBwn8Vq4zAhzE0zsWC0pWggoQOmEDVEWoRHYMKATFysAvb7mRiQsfRrBsnegZLmEfBe98XfluQEM8orfqU4dx3.nyrph61IEChGKlQP7X4HVdY-
X-Yahoo-Newman-Property: ymail-3
Subject: [ANNOUNCE]: LIO-Target/ConfigFS for v2.6.27
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: "Linux-iSCSI.org Target Dev" 
	<linux-iscsi-target-dev@googlegroups.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       SCST-Devel <scst-devel@lists.sourceforge.net>,
       dm-devel <dm-devel@redhat.com>,
       OpenFabrics-General <general@lists.openfabrics.org>
Cc: Jerome Martin <tramjoe.merin@gmail.com>, Greg KH <greg@kroah.com>,
       Christoph Hellwig <hch@infradead.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Alasdair G Kergon <agk@redhat.com>,
       Mike Christie <michaelc@cs.wisc.edu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Andrew Morton <akpm@osdl.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Pete Wyckoff <pw@osc.edu>
Content-Type: text/plain
Date: Thu, 16 Oct 2008 16:11:13 -0700
Message-Id: <1224198674.5556.255.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings all,

I am happy to announce the release of LIO-Target/ConfigFS for v2.6.27.

http://linux-iscsi.org/index.php/LIO-Target/ConfigFS

Using ConfigFS it is now possible to create generic storage objects from
Linux/SCSI using struct scsi_device, Linux/BLOCK using struct
block_device and Linux/VFS using struct file into a generic target
infrastructure under /sys/kernel/config/target/core (target_core_mod).
>From there, one can create ConfigFS symbolic links to destinations
under /sys/kernel/config/target/iscsi/ (iscsi_target_mod).  The idea is
that any $FABRIC module can access the same storage objects under the
generic target_core_mod configfs infrastracture.

I have primarly been working on completing the configfs conversion for
iscsi_target_mod, and as that work wraps up, I will next be focusing on
target_core_mod and the generic kernel target infrastructure in Linux.
This involves quite a few different things, merging existing in-tree
STGT code into so it can use /sys/kernel/config/target/core, merging out
of tree SCST code for multiple existing fabric modules and hardware
target mode drivers, the Target API, etc.  This work will definately
take lots of time and effort, but the end result will be a complete
target infrastructure under Linux that all manner of folks can use and
take advantage of and to build upon.

Thanks to the many folks you have made suggestions and comments in order
to get packets across the network and blocks down to storage up as
quickly as possible.  It was only ~7 weeks ago that Ming Zhang made the
recommendation to start using configfs, and now 6k new lines of code in
target_core_config.[c,h] and iscsi_target_configfs.[c.h]..  Wow..

As work continues on both fronts:  making iscsi_target_mod upstream
ready, and creating a generic target engine using configfs for
iscsi_target_mod and *ALL* fabric modules, the Linux-iSCSI.org team
invites anyone who is interested to start looking at the code.  You can
do this online at:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=tree;f=drivers/lio-core;hb=HEAD

or checkout your own git tree and start posting patching to the
LIO-Target devleopment list.  Instructions for git clone can be found
on:

http://linux-iscsi.org/index.php/LIO-Target

Please feel free to ask questions!

--nab

