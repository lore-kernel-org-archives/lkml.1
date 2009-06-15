Return-Path: <linux-kernel-owner+w=401wt.eu-S1753523AbZFODcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbZFODcU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 23:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbZFODcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 23:32:12 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:34677 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbZFODcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 23:32:11 -0400
Message-ID: <4A35C0A4.20707@ct.jp.nec.com>
Date: Mon, 15 Jun 2009 12:31:48 +0900
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       device-mapper development <dm-devel@redhat.com>,
       Boaz Harrosh <bharrosh@panasas.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>, k-ueda@ct.jp.nec.com
Subject: Re: [PATCH block#for-2.6.31] block: add request clone interface (v2)
References: <4A3075B2.9040208@ct.jp.nec.com>	<20090611110903.GO11363@kernel.dk>	<x49vdn3lynd.fsf@segfault.boston.devel.redhat.com>	<20090612133014.GK11363@kernel.dk> <x49ski5v7vs.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49ski5v7vs.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

On 06/12/2009 11:33 PM +0900, Jeff Moyer wrote:
> Jens Axboe <jens.axboe@oracle.com> writes:
>> On Thu, Jun 11 2009, Jeff Moyer wrote:
>>> Jens Axboe <jens.axboe@oracle.com> writes:
>>> Is blk_rq_unprep_clone really the best name?
>>>           ^^^^^^
>> Probably not, but I'm not very good at coming up with elegant names.
>> Your email should have included a new suggestion :-)
> 
> Fair enough.  ;)
> 
>>  - blk_rq_unprep_clone(struct request *clone)
>>      * Frees cloned bios from the clone request.
> 
> Why not blk_rq_free_clone?

Because the 'clone' is not freed in this interface.
This interface frees only bios in the 'clone'.
Allocating/freeing the 'clone' are the caller's work, since
only the caller knows how to allocate/free it.

'prep' after 'alloc' and 'unprep' before 'free' is symmetric
and I feel a good candidate for my request-stacking driver,
so I chose it. 

Thanks,
Kiyoshi Ueda
