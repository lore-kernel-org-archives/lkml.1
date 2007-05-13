Return-Path: <linux-kernel-owner+w=401wt.eu-S1757744AbXEMJyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757744AbXEMJyz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 05:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756944AbXEMJyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 05:54:47 -0400
Received: from smtp104.plus.mail.re1.yahoo.com ([69.147.102.67]:44765 "HELO
	smtp104.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756991AbXEMJyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 05:54:47 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 May 2007 05:54:46 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=zHXygODGB2LuSS2h47NhJxvlAYVgvBTQvwR6z3O5Ap0srKezL9Jq+JF+yjrRVRfmWmp8XP0rXlY5frjdAzM6LqEDNk9GgaVY+Tbj+vLT2bvfQNqWnY4k0iIy2UnMhsq4+d0RPYPuzlE8skkhJQZB0lbNWHMJvV6eti7NQl4toFY=  ;
X-YMail-OSG: 5fmC_iEVM1li8Gcxi973vpleRF2QNvfOlgUh1Q570mkVOhgI0GlTGnPmd3fURkh5W3uPnS6lvw--
Date: Sun, 13 May 2007 11:47:53 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: [PATCH] driver core: fix warning of temporarily unused multithreaded probing function (was: Re: Linux 2.6.22-rc1)
Message-ID: <20070513094752.GA5232@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

if I'm not mistaken, despite the PCI_MULTITHREAD_PROBE removal,
Cornelia Huck wanted to keep driver-core-per-subsystem-multithreaded-probing.patch:

<quote>
> Wouldn't per-subsystem multithreaded probing just expose bugs that
> could also be exposed on SMP systems?

Yes, it would be the same.
</quote>

However, device_probe_drivers() remains temporarily unused, so we either
suppress the compiler warning or remove the whole function altogether. The
following patch does the first.

-----
From: Borislav Petkov <bbpetkov@yahoo.de>

This patch shuts the following warning:

drivers/base/dd.c:211: warning: 'device_probe_drivers' defined but not used

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>

--

Index: 22-rc1/drivers/base/dd.c
===================================================================
--- 22-rc1/drivers/base/dd.c.orig
+++ 22-rc1/drivers/base/dd.c
@@ -207,7 +207,7 @@ static int __device_attach(struct device
 	return driver_probe_device(drv, dev);
 }

-static int device_probe_drivers(void *data)
+static int __used device_probe_drivers(void *data)
 {
 	struct device *dev = data;
 	int ret = 0;


-- 
Regards/Gruﬂ,
    Boris.
