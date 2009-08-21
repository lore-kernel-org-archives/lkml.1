Return-Path: <linux-kernel-owner+w=401wt.eu-S1755742AbZHUScg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742AbZHUScg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 14:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753846AbZHUScf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 14:32:35 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:21118 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048AbZHUScf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 14:32:35 -0400
Message-ID: <4A8EE7EC.70909@oracle.com>
Date: Fri, 21 Aug 2009 11:31:08 -0700
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       jeff@garzik.org, benh@kernel.crashing.org, htejun@gmail.com,
       bzolnier@gmail.com, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 5/6] aio: use lazy workqueues
References: <1250763604-24355-1-git-send-email-jens.axboe@oracle.com>	<1250763604-24355-6-git-send-email-jens.axboe@oracle.com> <x49k50yjzdd.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49k50yjzdd.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt004.oracle.com [141.146.116.13]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4A8EE7F1.005C:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> So far as I can tell, the aio workqueue isn't used for much these days.
> We could probably get away with switching to keventd.

It's only used by drivers/usb/gadget to implement O_DIRECT reads by
DMAing into kmalloc()ed memory and then performing the copy_to_user() in
the retry thread's task context after it has assumed the submitting
task's mm.

> Zach, isn't
> someone working on a patch to get rid of all of the -EIOCBRETRY
> infrastructure?  That patch would probably make things clearer in this
> area.

Yeah, a startling amount of fs/aio.c vanishes if we get rid of
EIOCBRETRY.  I'm puttering away at it, but I'll be on holiday next week
so it'll be a while before anything emerges.

- z
