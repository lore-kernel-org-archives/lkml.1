Return-Path: <linux-kernel-owner+w=401wt.eu-S1759408AbYBHOnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759408AbYBHOnB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 09:43:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757516AbYBHOmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 09:42:50 -0500
Received: from mail-relay-01.mailcluster.net ([77.221.130.213]:48654 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757399AbYBHOmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 09:42:49 -0500
Message-ID: <47AC6A6A.90905@vlnb.net>
Date: Fri, 08 Feb 2008 17:42:50 +0300
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060501 Fedora/1.7.13-1.1.fc5
X-Accept-Language: en-us, ru, en
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
CC: ltuikov@yahoo.com, Bart Van Assche <bart.vanassche@gmail.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       scst-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ming Zhang <blackmagic02881@gmail.com>
Subject: Re: Integration of SCST in the mainstream Linux kernel
References: <393719.81864.qm@web31808.mail.mud.yahoo.com> <1202471639.1805.149.camel@haakon2.linux-iscsi.org>
In-Reply-To: <1202471639.1805.149.camel@haakon2.linux-iscsi.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicholas A. Bellinger wrote:
> On Thu, 2008-02-07 at 12:37 -0800, Luben Tuikov wrote:
> 
>>Is there an open iSCSI Target implementation which does NOT
>>issue commands to sub-target devices via the SCSI mid-layer, but
>>bypasses it completely?
>>
>>   Luben
>>
> 
> 
> Hi Luben,
> 
> I am guessing you mean futher down the stack, which I don't know this to
> be the case.  Going futher up the layers is the design of v2.9 LIO-SE.
> There is a diagram explaining the basic concepts from a 10,000 foot
> level.
> 
> http://linux-iscsi.org/builds/user/nab/storage-engine-concept.pdf
> 
> Note that only traditional iSCSI target is currently implemented in v2.9
> LIO-SE codebase in the list of target mode fabrics on left side of the
> layout.  The API between the protocol headers that does
> encoding/decoding target mode storage packets is probably the least
> mature area of the LIO stack (because it has always been iSCSI looking
> towards iSER :).  I don't know who has the most mature API between the
> storage engine and target storage protocol for doing this between SCST
> and STGT, I am guessing SCST because of the difference in age of the
> projects.  Could someone be so kind to fill me in on this..?

SCST uses scsi_execute_async_fifo() function to submit commands to SCSI 
devices in the pass-through mode. This function is slightly modified 
version of scsi_execute_async(), which submits requests in FIFO order 
instead of LIFO as scsi_execute_async() does (so with 
scsi_execute_async() they are executed in the reverse order). 
Scsi_execute_async_fifo() added as a separate patch to the kernel.

> Also note, the storage engine plugin for doing userspace passthrough on
> the right is also currently not implemented.  Userspace passthrough in
> this context is an target engine I/O that is enforcing max_sector and
> sector_size limitiations, and encodes/decodes target storage protocol
> packets all out of view of userspace.  The addressing will be completely
> different if we are pointing SE target packets at non SCSI target ports
> in userspace.
> 
> --nab
