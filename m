Return-Path: <linux-kernel-owner+w=401wt.eu-S1752824AbYLBUAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbYLBUAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 15:00:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbYLBT75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 14:59:57 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:1606 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbYLBT74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 14:59:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=G8QzdyYh0Ddpp8EhkTd9fN4q4l8Zr5IrCsygy0hfvHyWn+RwcNjaTZsd9Vrri8GRCe
         xzIx3KSyAX58yRPIa/8GgIL84JEu9TRKqLeAu1G1dbAKiri/DcSbFJdK1IIcHN/Jftz9
         ubQAPrKMoYaIbZLv4YitCgslVtcNq93SwOY+Q=
Message-ID: <e2e108260812021159r31eb86a1v95d2cbdf7cfdae2d@mail.gmail.com>
Date: Tue, 2 Dec 2008 20:59:54 +0100
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "kernel list" <linux-kernel@vger.kernel.org>
Subject: A question about sparse: how to use __acquires() and __releases() correctly ?
Cc: "Vladislav Bolkhovitin" <vst@vlnb.net>,
       "Alexander Shishkin" <alexander.shishckin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm helping to prepare the SCST source code for inclusion in the Linux
kernel by a.o. cleaning up sparse warnings. Although most of the SCST
source code has been annotated by this time it's still not clear to me
how to use __acquires() and __releases() correctly.

I will illustrate my questions via the following code from
net/core/dev.c, Linux kernel version 2.6.27.7:

void dev_seq_stop(struct seq_file *seq, void *v)
        __releases(dev_base_lock)
{
        read_unlock(&dev_base_lock);
}

The command "make C=2 M=net/core" produces the following output for
the above function (using a sparse binary built from the sparse git
repository, last updated on August 26, 2008):

net/core/dev.c:2579:2: warning: context problem in 'dev_seq_stop':
'_read_unlock' expected different context
net/core/dev.c:2579:2:    context 'lock': wanted >= 1, got 0

My questions are as follows:
* Which argument type should be passed to __releases() -- a pointer to
a lock structure or the lock strucure itself ? In the header file
include/linux/spinlock_api_smp.h a pointer is passed to __acquires()
and __releases(), while other code (like the above) passes the lock
structure itself to the __acquires() and __releases() annotations.
* If the __releases() annotation is used correctly in net/core/dev.c,
why does sparse complain about a context problem ?

Please keep me in CC -- I'm not subscribed to the LKML.

Bart.
