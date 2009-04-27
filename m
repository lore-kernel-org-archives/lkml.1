Return-Path: <linux-kernel-owner+w=401wt.eu-S1756984AbZD0OjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984AbZD0OjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 10:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755951AbZD0OjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 10:39:06 -0400
Received: from mail-qy0-f180.google.com ([209.85.221.180]:53313 "EHLO
	mail-qy0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756658AbZD0OjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 10:39:04 -0400
X-Greylist: delayed 470 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Apr 2009 10:39:04 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=M9xhp/Sd4KQOlAcDQEnBEgfNeZFFyoz39OaRPLOlZTaWEKXdGHwUAqb2A27v/7/5ER
         rqbSLRBw5HczCnu68lxIfMtVpUxzWKojCaaJueKYyr4/FE5VHmvC8HDL+GkQSu7Cgm5g
         m4d5+nEWrNtPGCX0DP80KX7/hgSoD5uR8t2Tc=
MIME-Version: 1.0
In-Reply-To: <D7CCA83BB0796C49BC0BB53B6AB1208928CA1D@zch01exm21.fsl.freescale.net>
References: <20090424183517.GB23140@ovro.caltech.edu>
	 <D7CCA83BB0796C49BC0BB53B6AB1208928CA1D@zch01exm21.fsl.freescale.net>
Date: Mon, 27 Apr 2009 09:31:12 -0500
X-Google-Sender-Auth: be36beb348c68657
Message-ID: <ed82fe3e0904270731g2d2519a7mc12e4152c716c0a9@mail.gmail.com>
Subject: Re: [PATCH] fsldma: use PCI Read Multiple command
From: Timur Tabi <timur@freescale.com>
To: Liu Dave-R63238 <DaveLiu@freescale.com>
Cc: Ira Snyder <iws@ovro.caltech.edu>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Dan Williams <dan.j.williams@intel.com>,
       Li Yang-R58472 <LeoLi@freescale.com>,
       Zhang Wei <wei.zhang@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 4:09 AM, Liu Dave-R63238 <DaveLiu@freescale.com> wrote:

> You are assuming the PCI memory space is prefetchable( no side effect)
> for DMA.
> Is it possible that DMA is from non-prefetchable memory space?

This should be a safe assumption for this driver.  Remember, this
driver just does offload memcpy, from one region to another.  So the
PCI memory that you are reading from should be just a buffer of data,
and there should be side-effect of reading it.

However, I would like to see a comment at the top of the file warning
people that copying from PCI memory will result in prefetched reads.

-- 
Timur Tabi
Linux kernel developer at Freescale
