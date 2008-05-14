Return-Path: <linux-kernel-owner+w=401wt.eu-S1760295AbYENGAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760295AbYENGAm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 02:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757099AbYENGAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 02:00:20 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:56494 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372AbYENGAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 02:00:18 -0400
Message-ID: <482A7F64.50705@ak.jp.nec.com>
Date: Wed, 14 May 2008 14:57:56 +0900
From: KaiGai Kohei <kaigai@ak.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: greg@kroah.com, morgan@kernel.org, serue@us.ibm.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] exporting capability name/code pairs (for 2.6.26)
References: <47C25AE9.7080305@ak.jp.nec.com> <480DC80F.3060403@ak.jp.nec.com> <20080423053726.GF3861@localhost.localdomain> <480EE1F6.3070205@ak.jp.nec.com> <482A33FA.5030109@ak.jp.nec.com> <20080514005238.GZ17453@sequoia.sous-sol.org>
In-Reply-To: <20080514005238.GZ17453@sequoia.sous-sol.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wright wrote:
> * KaiGai Kohei (kaigai@ak.jp.nec.com) wrote:
>> Chris, what is the status of the patch?
> 
> I still don't understand how ...

Hmm...

>>> When we run a userspace utility on the latest kernel, it has to be compiled
>>> with kernel-headers which have same capability set at least.
>>> If installed userspace utility does not support newly added capabilities,
>>> it requires users to rebuild their utilities when they update the kernel.
>>>
>>> Typically, kernel developer faces this kind of version mismatching.
>>> When they boots their kernel with new capabilities, it also requires to
>>> rebuild libcap. Then, they have to revert it, when they boots with normal
>>> kernel.
>>>
>>> If libcap can know what capabilities are supported on the running kernel
>>> automatically, it does not need users to rebuild libcap concurrently.
> 
> ...libcap can do anything meaningful here with capabilities it doesn't
> know about?  This interface is already versioned, what is wrong is old
> cap version on new kernel (clearly new cap version on old kernel would
> have to fall back to older cap version)?

The versioning info is just a hint in this case.

The major purpose of this patch is to save steps of maintainance.
When we tries to run a application using a new capability provided by
the latest kernel, we have to rebuild libcap to follow kernel updates.

If we can obtain an information what capabilities are supported in
the running kernel, we don't need to rebuild libcap for the latest
kernel everytime.

For example, we got CAP_MAC_ADMIN at 2.6.25. If an application tries to
use it, we have to replace libcap for 2.6.24 by libcap for 2.6.25.
Although, we don't get any updates in libcap. :-(

In addition, I noticed it will be usefull for applications which have
a possibility to use arbitary number of capabilities, like busybox
if setcap/getcap stuff is ported.
(IMO, we should not use libcap for busybox, because its first priority
  is to reduce binary size, limited to minimun functionalities.)

Thanks,
-- 
OSS Platform Development Division, NEC
KaiGai Kohei <kaigai@ak.jp.nec.com>
