Return-Path: <linux-kernel-owner+w=401wt.eu-S1759303AbYGPN5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759303AbYGPN5t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 09:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755221AbYGPN5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 09:57:41 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:1459 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088AbYGPN5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 09:57:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Apya5+CQzWSXR90UbG6GtXMc+g1k5ZD2hjpBuDHqXqYdCMOhUfvamLNLSrKgmfIPZN
         /SlH61Qst7/a4WCwrNRn/iBJ2afU8jeSQt2hkV9DxG2JvV0Q8u7t5fkFQht3M676AVkn
         U/4+YIJT+GflVG9qFmCnhKSt5KZMHKWZUjq0Q=
Message-ID: <c61f462d0807160657p206fb29dt5a2d68c0493aab49@mail.gmail.com>
Date: Wed, 16 Jul 2008 19:27:38 +0530
From: "Unmil Tambe" <catchunmil@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Sync_page_io() call hangs when called from make_request (2.6.25)
In-Reply-To: <c61f462d0807160656y4b36edeftc86b02fc7fce6a6b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c61f462d0807160656y4b36edeftc86b02fc7fce6a6b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am writing a stacking block device driver which writes some metadata
on a block device before redirecting the data bio to underlying disk.
For this I have been using sync_page_io from raid/md.h to do the
metadata write synchronously.

This worked fine in 2.6.18.2 kernel. I am now trying to port the
driver to 2.6.25 kernel, but even in a basic stacking driver in this
kernel, the sync_page_io call does not return. The process (dd in this
case) never returns. The machine does not freeze, nor is there an OOPS
generated. It is as if waiting on a lock.

All I could find in my search was this msg at:
http://repo.ugm.ac.id/linux/ChangeLog-2.6.22.12

"Author: Milan Broz <mbroz@redhat.com>
Date:   Thu Jul 12 17:28:00 2007 +0100

   dm snapshot: fix invalidation deadlock

   patch fcac03abd325e4f7a4cc8fe05fea2793b1c8eb75 in mainline

   Process persistent exception store metadata IOs in a separate thread.

   A snapshot may become invalid while inside generic_make_request().
   A synchronous write is then needed to update the metadata while still
   inside that function.  Since the introduction of
   md-dm-reduce-stack-usage-with-stacked-block-devices.patch this has to
   be performed by a separate thread to avoid deadlock. "


I dont really know whether this is related to my problem or not. Any ideas?

Thanks,
Unmil
