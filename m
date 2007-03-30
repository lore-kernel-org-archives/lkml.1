Return-Path: <linux-kernel-owner+w=401wt.eu-S1751450AbXC3NUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450AbXC3NUE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 09:20:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbXC3NUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 09:20:03 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:39501 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbXC3NUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 09:20:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=DDLj1WN6vhQO29fbhSGpIdefHIldUSrQs/Q9cw4vjzvxk8dJLzdZKfcrfUYVzbRxMrwObEnQCLzkbENWqMQkXkdI0Xmqx1MfMfiiTR/RjSsrs+/tAojvZ/Q5NeLeD6U248wE2ip9cArDn0aUnmJ9kfzitrn4lmJFaXMlYQcCYvg=
Message-ID: <460D0E78.3040200@gmail.com>
Date: Fri, 30 Mar 2007 22:19:52 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Cornelia Huck <cornelia.huck@de.ibm.com>
CC: gregkh@suse.de, hugh@veritas.com, dmitry.torokhov@gmail.com,
       oneukum@suse.de, maneesh@in.ibm.com, rpurdie@rpsys.net,
       James.Bottomley@SteelEye.com, Jeff Garzik <jgarzik@pobox.com>,
       lkml <linux-kernel@vger.kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       SCSI Mailing List <linux-scsi@vger.kernel.org>
Subject: Re: [RFD driver-core] Lifetime problems of the current driver model
References: <460CDBA6.5030608@gmail.com> <20070330151926.18fc12a0@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070330151926.18fc12a0@gondolin.boeblingen.de.ibm.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cornelia Huck wrote:
> On Fri, 30 Mar 2007 18:43:02 +0900,
> Tejun Heo <htejun@gmail.com> wrote:
> 
>> One way to solve this problem is to subordinate lifetime rule #b to
>> rule #c.  Each kobject points to its owning module such that grabbing
>> a kobject automatically grabs the module.  The problem with this
>> approach is that it requires wide update and makes kobject_get
>> heavier.
> 
> Shouldn't getting/putting the module refcount be solely done in
> kobject.c? Grab the module reference when the kobject is created and
> release the module reference in kobject_cleanup() after the release
> function has been called. This doesn't make kobject_get() heavier, and
> it ensures we don't delete the module until after the last kobject it is
> supposed to clean up has been released.

If we do that, we wouldn't be able to unload a module if there is any
kobject referencing it even when the node has no openers, so no easy way
out there.  :-(

-- 
tejun
