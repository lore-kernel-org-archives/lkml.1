Return-Path: <linux-kernel-owner+w=401wt.eu-S1754608AbXHJE0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608AbXHJE0d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 00:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751058AbXHJE0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 00:26:24 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:2042 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbXHJE0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 00:26:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=U08Hhf3ERWhI+vj46mEMLwPl/N0JUbzb+oK6MWO2LKsRLODY3HCYWdi4eDq9Ywd0zSifPOHHqmHO4o4p/n0zg8t/CA4UEoWZ3ZLxFEbP+OtShbmkm6VKkoHBmU7SdDupVR6QjiF1Vc2DM9mvqPNADdlT7EHvkibDu4FV+gQa0oQ=
Message-ID: <7034e7b50708092126m30ab5744w965f23b4bc669aa7@mail.gmail.com>
Date: Thu, 9 Aug 2007 21:26:22 -0700
From: "Grace Baldonasa" <gbaldona@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Unable to Handle kernel paging request at virtual address during rmmod/insmod
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm kind of lost in my debugging. Hope someone out there can help me
figure out the problem.
I am loading 4 modules-> class driver, device controller, interface
layer(working on a dual-core) &hardware abstraction layer.
Device has to work as a mass storage class. After doing some file
transfer and more complex testing. I unload the modules/driver, and
here is where my problem will come
out. Most of the time, I will get "unable to handle kernel paging
request". and this happens at different timing. I implemented memory
counter in all the modules to ensure that all
kmalloc'd are kfreed. So I am confident there is no memory leakage in
each module.

My understanding from the call trace is, it is failing somewhere in
free_block/sys_delete_module, etc. These routines are internal already
to kernel and were called upon rmmod.
Is there anything I can do in my modules to resolve this issue.

I am using vmalloc in allocating 64K buffer twice in one of the
module. In Hal abstraction layer, also an iormap_nocache was used.
Could the problem be related to this?
I am using linux-2.6.18.


Any help will be greatly appreciated.


grace
