Return-Path: <linux-kernel-owner+w=401wt.eu-S965148AbXBSW6D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965148AbXBSW6D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 17:58:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965149AbXBSW6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 17:58:03 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:49947 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965148AbXBSW6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 17:58:01 -0500
In-Reply-To: <x49y7mt4vdd.fsf@segfault.boston.devel.redhat.com>
References: <20070219213830.4032.71308.sendpatchset@tetsuo.zabbo.net> <20070219213835.4032.87439.sendpatchset@tetsuo.zabbo.net> <x49y7mt4vdd.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <46C10DE9-B203-4A1F-AF18-7E8A0A899EAF@oracle.com>
Cc: linux-aio@kvack.org, linux-kernel@vger.kernel.org,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna bhattacharya <suparna@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Leonid Ananiev <leonid.i.ananiev@intel.com>
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH 2/2] aio: propogate post-EIOCBQUEUED errors to completion event
Date: Mon, 19 Feb 2007 14:57:09 -0800
To: Jeff Moyer <jmoyer@redhat.com>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Zach> So this patch introduces a helper, aio_propogate_error(),
>
> ...which is spelled incorrectly:  aio_propagate_error.

Man, I am batting 1000!  Randy also made fun of my 'intead'.

> Zach> which queues post-submission errors in the iocb so that they are
> Zach> given to the user completion event when aio_complete() is
> Zach> finally called.
>
> Ugly, but I can't think of a better way to do it, either.

Yeah, this seemed to be the lesser of the available evils.  We (Chris  
and I, while in california) considered introducing a primitive to  
have the submission path wait for aio_complete() to be called so that  
it could just return the error.  We also thought about turning EIOCB 
{RETRY,QUEUED} into bits on the iocb instead of return codes that we  
have to lovingly pass back up to fs/aio.c.

This seemed to be the least intrusive :/.

- z
