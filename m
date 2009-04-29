Return-Path: <linux-kernel-owner+w=401wt.eu-S1763388AbZD2Wpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763388AbZD2Wpf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 18:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761489AbZD2WlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 18:41:19 -0400
Received: from exprod6og101.obsmtp.com ([64.18.1.181]:33248 "HELO
	exprod6og101.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761194AbZD2WlS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 18:41:18 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: Q: about struct task_struct
Date: Wed, 29 Apr 2009 18:41:15 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE1909016C1AF3@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Q: about struct task_struct
Thread-Index: AcnJG5qpoPFwCEF4QU+LP9LwFYJzZg==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 29 Apr 2009 22:41:16.0485 (UTC) FILETIME=[9B604F50:01C9C91B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

In struct task_struck, should set_child_tid and clear_child_tid
be int __user * or u32 __user *?

In include/linux/sched.h they are both int __user * but in
kernel/fork.c there is the following line:

	u32 __user * tidptr = tsk->clear_child_tid;

This is causing a sparse warning:

warning: incorrect type in initializer (different signedness)
   expected unsigned int [noderef] [usertype] <asn:1>*tidptr
   got int [noderef] <asn:1>*clear_child_tid

It seems the struct should have them as u32 __user * since the
clone_flags are defined up to 0x80000000 (CLONE_IO).

Thanks,
Hartley
