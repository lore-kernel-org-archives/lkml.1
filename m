Return-Path: <linux-kernel-owner+w=401wt.eu-S1760455AbYBWBHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760455AbYBWBHa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 20:07:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbYBWBHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 20:07:14 -0500
Received: from elasmtp-galgo.atl.sa.earthlink.net ([209.86.89.61]:56858 "EHLO
	elasmtp-galgo.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751198AbYBWBHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 20:07:12 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=KMPzQXrXL73ndQl2D+Rdc4kZePa6beDsrb2CenW27aY8J0IaKa79SewVgM3jn69S;
  h=Message-ID:Date:From:Reply-To:To:Subject:Cc:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Mailer:X-ELNK-Trace:X-Originating-IP;
Message-ID: <9643105.1203728826946.JavaMail.root@elwamui-rustique.atl.sa.earthlink.net>
Date: Fri, 22 Feb 2008 17:07:06 -0800 (GMT-08:00)
From: erblichs <erblichs@earthlink.net>
Reply-To: erblichs <erblichs@earthlink.net>
To: linux-kernel@vger.kernel.org
Subject: RFE: __alloc_pages() SLAB_PANIC & gfp_mask
Cc: erblichs@earthlink.net
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: EarthLink Zoo Mail 1.0
X-ELNK-Trace: 074f60c55517ea841aa676d7e74259b7b3291a7d08dfec79512e875a395cc2042d0a89d3a7a76294350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 209.86.224.48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Group,


           Currrently I do not subscribe to this mail alias, so please
           keep the cc.

           Currently a few calls exist where WAIT is specified (
           (GFP_KERNEL)for the slab/slob allocators and also as an
           additional argument, SLAB_PANIC is checked against the
           return of the request for memory allocation. SLAB_PANIC
           is not passed to __alloc_pages() as part of the gfp_mask.

           If the memory allocation fails, and the flag is turned
           on, then a panic will ensure.. There is a very simple fix
           for this. The assumption is too basicly ASSERT a guarantee
           that memory failure in this case will not occur.

           The suggestion is to add the SLAB_PANIC arg to the gfp_mask,
           add it to the mask in the SLAB/SLUB callers,
           and have that checked within __alloc_pages 
           if a mem alloc failure is about to occur 
           after the check for no WAITers.

           If it is set, then force additional loops within the function.

           This would remove new cache creates from causing a panic when
           a low memory condition exists.

           Mitchell Erblich
