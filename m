Return-Path: <linux-kernel-owner+w=401wt.eu-S1757605AbYKDR0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605AbYKDR0d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 12:26:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757233AbYKDR0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 12:26:18 -0500
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3213 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756980AbYKDR0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 12:26:17 -0500
Date: Tue, 4 Nov 2008 18:26:15 +0100
From: Folkert van Heusden <folkert@vanheusden.com>
To: linux-kernel@vger.kernel.org
Subject: [2.6.26] ERROR FC host 'qla2xxx' attempted to flush work, when no
	workqueue created
Message-ID: <20081104172615.GI23232@vanheusden.com>
References: <20081104172513.GH23232@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081104172513.GH23232@vanheusden.com>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Wed Nov  5 16:29:01 CET 2008
X-Message-Flag: PGP key-id: 0x1f28d8ae - consider encrypting your e-mail to
	me with PGP!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While running my http://vanheusden.com/pyk/ script (which randomly
inserts and removes modules) I triggered the folllowing WARNING in a
2.6.26 kernel on an IBM xSeries x3650 (2 quadcores (intel qc x5450)
and 10GB ram).

[ 2813.078094] ERROR: FC host 'qla2xxx' attempted to flush work, when no workqueue created.
[ 2813.078094] Pid: 10082, comm: qla2xxx_8_dpc Tainted: G        W 2.6.26-1-amd64 #1
[ 2813.078094] 
[ 2813.078094] Call Trace:
[ 2813.078094]  [<ffffffffa00a06f4>] :scsi_transport_fc:fc_flush_work+0x33/0x41
[ 2813.078094]  [<ffffffffa00a2c98>] :scsi_transport_fc:fc_remote_port_add+0x2b/0x60d
[ 2813.078094]  [<ffffffffa03864a4>] :qla2xxx:qla2x00_update_fcport+0x2b8/0x363
[ 2813.078094]  [<ffffffffa038e02d>] :qla2xxx:qla2x00_get_port_database+0x2f0/0x2fe
[ 2813.078094]  [<ffffffffa03868fa>] :qla2xxx:qla2x00_configure_local_loop+0x32a/0x3c0
[ 2813.078094]  [<ffffffffa0386d14>] :qla2xxx:qla2x00_configure_loop+0x384/0x10fd
[ 2813.078094]  [<ffffffffa038c854>] :qla2xxx:qla2x00_get_retry_cnt+0x43/0xbd
[ 2813.078094]  [<ffffffff8023ca94>] process_timeout+0x0/0x5
[ 2813.078094]  [<ffffffff8042874a>] schedule_timeout+0x85/0xad
[ 2813.078094]  [<ffffffffa0387ae9>] :qla2xxx:qla2x00_loop_resync+0x5c/0xae
[ 2813.078094]  [<ffffffffa03848d5>] :qla2xxx:qla2x00_do_dpc+0x435/0x4d4
[ 2813.078094]  [<ffffffffa03844a0>] :qla2xxx:qla2x00_do_dpc+0x0/0x4d4
[ 2813.078094]  [<ffffffff80245efb>] kthread+0x47/0x74
[ 2813.078094]  [<ffffffff80230057>] schedule_tail+0x27/0x5c
[ 2813.078094]  [<ffffffff8020cef8>] child_rip+0xa/0x12
[ 2813.078094]  [<ffffffff80245eb4>] kthread+0x0/0x74
[ 2813.078161]  [<ffffffff8020ceee>] child_rip+0x0/0x12


Folkert van Heusden

-- 
MultiTail è uno flexible tool per seguire di logfiles e effettuazione
di commissioni. Feltrare, provedere da colore, merge, 'diff-view',
etc. http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
