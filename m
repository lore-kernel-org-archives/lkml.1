Return-Path: <linux-kernel-owner+w=401wt.eu-S1763405AbXEWSpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763405AbXEWSpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 14:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756240AbXEWSpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 14:45:38 -0400
Received: from keetweej.vanheusden.com ([213.84.46.114]:45990 "EHLO
	keetweej.vanheusden.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755042AbXEWSph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 14:45:37 -0400
Date: Wed, 23 May 2007 20:45:35 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Andrea Righi <righiandr@users.sourceforge.net>, Andi Kleen <ak@suse.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>, Rik van Riel <riel@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: signals logged / [RFC] log out-of-virtual-memory events
Message-ID: <20070523184535.GE21655@vanheusden.com>
References: <464C9D82.60105@redhat.com> <Pine.LNX.4.61.0705202235430.13923@yvahk01.tjqt.qr> <20070520205500.GJ22452@vanheusden.com> <200705202314.57758.ak@suse.de> <46517817.1080208@users.sourceforge.net> <20070521110406.GA14802@vanheusden.com> <Pine.LNX.4.61.0705211420100.4452@yvahk01.tjqt.qr> <20070521124734.GB14802@vanheusden.com> <a781481a0705231100q333a589at6c025eb1292019cd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a781481a0705231100q333a589at6c025eb1292019cd@mail.gmail.com>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Thu May 24 20:12:05 CEST 2007
X-Message-Flag: PGP key-id: 0x1f28d8ae - consider encrypting your e-mail to me with PGP!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >> >+    {
> >> if (sig_fatal(t, sig)) {
> >> >+            printk(KERN_WARNING "Sig %d send to %d owned by %d.%d 
> >(%s)\n",
> >> s/send/sent/;
> >> >+            sig, t -> pid, t -> uid, t -> gid, t -> comm);
> >> t->pid, t->uid, t->gid, t->comm);
> >
> 
> Gargh ... why does this want to be in the *kernel*'s logs? In any case, can
> you please make this KERN_INFO (or lower) instead of KERN_WARNING.

Description:
This patch adds code to the signal-sender making it log a message when
an unhandled fatal signal will be delivered.

Signed-of by: Folkert van Heusden <folkert@vanheusden.com

--- kernel/signal.c.org	2007-05-20 22:47:13.000000000 +0200
+++ kernel/signal.c	2007-05-21 14:46:05.000000000 +0200
@@ -739,6 +739,12 @@
 	struct sigqueue * q = NULL;
 	int ret = 0;
 
+	/* unhandled fatal signals are logged */
+	if (sig_fatal(t, sig)) {
+		printk(KERN_INFO "Sig %d sent to %d owned by %d.%d (%s)\n",
+		sig, t->pid, t->uid, t->gid, t->comm);
+	}
+
 	/*
 	 * fast-pathed signals for kernel-internal things like SIGSTOP
 	 * or SIGKILL.


Folkert van Heusden

-- 
Temperature outside:    21.437500, temperature livingroom: 
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
