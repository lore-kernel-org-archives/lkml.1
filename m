Return-Path: <linux-kernel-owner+w=401wt.eu-S1752601AbZHQSza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbZHQSza (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 14:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbZHQSz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 14:55:29 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:57697 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbZHQSz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 14:55:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=msKNS5Mx+tMy5RljAFc2l+rCbSKlWw6UtLdhEI3Jv7oDUn0HsoBjpPgyVtg2HEGLLE
         +dJTH14avAxl1fCYzwMIHBh5+ZxtCLP1WUPqwBUh+G2dvdL5gLgkEuiW5YR4c0Bq1PRw
         Nc0PCrnH70ZEicfheWVro6oe9cEdfgYFJIJRY=
Message-ID: <4A89A7C0.1090909@gmail.com>
Date: Mon, 17 Aug 2009 11:56:00 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009031304)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ohci1396_dma=early nogo on an imac?
References: <4A88F6BF.7090104@gmail.com> <4A89722A.1070407@s5r6.in-berlin.de> <dd18b0c30908171104o7ed67aa3x7cab741263de09c3@mail.gmail.com> <4A899D41.7000405@s5r6.in-berlin.de>
In-Reply-To: <4A899D41.7000405@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Justin Mattock wrote:
>> [  660.190134] ieee1394: Current remote IRM is not 1394a-2000
>> compliant, resetting...
> ...
>> keeps going.
>
> It's a bug in ieee1394.  http://bugzilla.kernel.org/show_bug.cgi?id=8403
>
> Use the ieee1394 disable_irm=1 parameter on one or both nodes.  
> Perhaps firescope will then get going as well.
O.K. Thanks to you
using 2.6.30.4 I was able to log the boot message.
now I can see if I can grab the info on the stuckage that
im getting with the bad kernel.

The problem im seeing is if I use ohci1394_dma=early on the bad kernel
instantly Ill get a message on the screen saying:

PANIC: early exception 08 rip 246:10 error ffffffff8145ff15 cr2 0

if I don't use the boot param the system loads but half way through
ill get a message of

manually writing down:

[   0.655640] [<ffffffff81440c33>] panic+0x84/0x129
[   0.655883] [<ffffffff81063f96>]  do_exit+0x84/0x67e
[   0.656125] [<ffffffff81445044>] oops_end+0x9c/0xb7
[   0.656368] [<ffffffff81044a6c>] no_context+0x200/0x223
[   0.656611] [<ffffffff81442d3d>] ? __mutex_lock_slowpath+0x226/0x249
[   0.656848] [<ffffffff81044c36>] __bad_area_nosemaphore+0x1a7/0x1e1
[   0.657097] [<ffffffff81442b01>]? mutex_unlock+0x1c/0x32
[   0.657097] [<ffffffff811ce094>] ? inode_doinit_with_dentry+0x533/0x5be
[   0.657579] [<ffffffff81443ee0>] ? _spin_unlock+0x1c/0x32
[   0.657822] [<ffffffff81044c91>] bad_area_nosemaphore+0x2a/0x40
[   0.658066] [<ffffffff811ce149>] ? selinux_d_instantiate+0x2a/0x40
[   0.658309] [<ffffffff8144687d>] do_page_fault+0x192/0x2dd
[   0.658549] [<ffffffff814444cf>] page_fault+0x1f/0x30
[   0.658791] [<ffffffff8120e856>] ? strcmp+0x17/0x46
[   0.659040] [<ffffffff810b9ca0>] event_create_dir+0x49/0x37b
[   0.659276] [<ffffffff81696f0a>] ? event_trace_init+0x0/0x1a2
[   0.659519] [<ffffffff81697061>] event_trace_init+0x157/0x1a2
[   0.659762] [<ffffffff81696f0a>] ? event_trace_init+0x0/0x1a2
[   0.660008] [<ffffffff810091db>] do_one_initcall+0x65/0x14e
[   0.660251] [<ffffffff81140000>] ? proc_set_super+0x49/0x5d
[   0.660488] [<ffffffff8167ef53>] kernel_init+0x160/0x1cc
[   0.660731] [<ffffffff8102801a>] child_rip+0xa/0x20
[   0.660973] [<ffffffff8167edf3>] ? kernel_init+0x0/0x1cc
[   0.661220] [<ffffffff81028010>] ? child_rip+0x0/0x20


Justin P. Mattock
