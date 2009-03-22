Return-Path: <linux-kernel-owner+w=401wt.eu-S1754184AbZCVIpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbZCVIpd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 04:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752142AbZCVIpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 04:45:22 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:12936 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751685AbZCVIpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 04:45:20 -0400
Message-ID: <49C5FA10.6090607@panasas.com>
Date: Sun, 22 Mar 2009 10:42:56 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Evgeniy Polyakov <zbr@ioremap.net>
CC: Avishay Traeger <avishay@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       open-osd <osd-dev@open-osd.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 7/8] exofs: Documentation
References: <49C1331D.1080805@panasas.com> <1237399858-29537-1-git-send-email-bharrosh@panasas.com> <20090321132601.GA10099@ioremap.net>
In-Reply-To: <20090321132601.GA10099@ioremap.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Mar 2009 08:44:19.0158 (UTC) FILETIME=[63D1CF60:01C9AACA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov wrote:
> Hi.
> 
> On Wed, Mar 18, 2009 at 08:10:58PM +0200, Boaz Harrosh (bharrosh@panasas.com) wrote:
>> +++ b/fs/exofs/BUGS
>> @@ -0,0 +1,3 @@
>> +- Out-of-space may cause a severe problem if the object (and directory entry)
>> +  were written, but the inode attributes failed. Then if the filesystem was
>> +  unmounted and mounted the kernel can get into an endless loop doing a readdir.
> 
> Does it also mean that damaged media may end up freezing the machine
> during the mount?
> 

I had such situation and it was able to mount. Some data was lost.

But sure, if the damage was in a way like above it would. The bad
situation is when there is a directory entry, there is a corresponding
object, but there is an error reading the associated attribute. the
redir code does not expect to fail, independent from iget()

It is difficult for me to repeat this problem because I've changed
the osd-target I'm running with, and with the new target attributes
are stored an a DB, so the create-object fails with ENOSP long before
I'm no longer able to write attributes. But I'm sure one day this problem
will come to hunt me.

Thanks
Boaz

