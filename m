Return-Path: <linux-kernel-owner+w=401wt.eu-S1750733AbXCFUQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750733AbXCFUQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 15:16:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750763AbXCFUQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 15:16:37 -0500
Received: from mo-p07-ob.rzone.de ([81.169.146.189]:28643 "EHLO
	mo-p07-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbXCFUQg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 15:16:36 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Hugh Dickins <hugh@veritas.com>
Subject: Re: 2.6.21-rc suspend regression: sysfs deadlock
Date: Tue, 6 Mar 2007 21:16:25 +0100
User-Agent: KMail/1.9.1
Cc: Oliver Neukum <oliver@neukum.name>, Maneesh Soni <maneesh@in.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0703061914030.18144@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0703061914030.18144@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703062116.26194.oliver@neukum.org>
X-RZG-AUTH: kN+qSWxTQH+Xqix8Cni7tCsVYhPCm1GPE5pUNaoG1wTinqjVVl1GKJZKNFH60/y81w==
X-RZG-CLASS-ID: mo07
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 6. März 2007 20:20 schrieb Hugh Dickins:
> This comes from Oliver's commit 94bebf4d1b8e7719f0f3944c037a21cfd99a4af7
> Driver core: fix race in sysfs between sysfs_remove_file() and read()/write()
> in 2.6.21-rc1.  It looks to me like sysfs_write_file downs buffer->sem
> while calling flush_write_buffer, and flushing that particular write
> buffer entails downing buffer->sem in orphan_all_buffers.

I had not thought about sysfs removing files in sysfs.

> Suspend no longer deadlocks with the following silly patch, but I expect
> this either pokes a small hole in your scheme, or renders it pointless.

The latter.
 
> Maybe that commit needs to be reverted, or maybe you can see how to fix
> it up for -rc3.

If you want a quick fix a work queue could be used, but it's a kludge.
Suggestions, anybody?

	Regards
		Oliver
