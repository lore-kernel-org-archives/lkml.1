Return-Path: <linux-kernel-owner+w=401wt.eu-S1031133AbXDQStI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031133AbXDQStI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 14:49:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031132AbXDQStI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 14:49:08 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:1388 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031133AbXDQStH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 14:49:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=GuWeLE2Dl2irRgE9uqC+Q7THfAev0fNoAajJIZqKAM3SaYb9/s4m5bGgza+uJrVccSmMPwqdaS1KvnEraRdFP1wwmkYom3w8dti2KKpYQCF7xmyMaaKea2z8CFMiQnytxc3hqH3DwXoYW5gXH0HQ2OgFhbtVkoyiTAqGlzOL9yo=
Message-ID: <4625169D.9020301@gmail.com>
Date: Wed, 18 Apr 2007 03:49:01 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Cornelia Huck <cornelia.huck@de.ibm.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg K-H <greg@kroah.com>,
       Rusty Russell <rusty@rustcorp.com.au>, dmitry.torokhov@gmail.com
Subject: Re: [PATCH RFD] alternative kobject release wait mechanism
References: <20070416193619.4659a847@gondolin.boeblingen.de.ibm.com> <20070417184110.GJ10619@htj.dyndns.org>
In-Reply-To: <20070417184110.GJ10619@htj.dyndns.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello, all.
> 
> Agreed with the problem but I'm not very enthusiastic for adding
> kobj->owner.  How about the following?  exit() routines will have to
> do device_unregister_wait() instead of device_unregister().  On return
> from it, it's guaranteed that all references to it are dropped and
> ->release is finished.  The caller is responsible for avoiding
> deadlock, of course.

Oh, one more thing, with proper code audit, we can just make
device_unregister() do the waiting instead of adding separate
device_unregister_wait().  I think that will be a good step toward
immediate-detach driver model.

-- 
tejun
