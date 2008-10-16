Return-Path: <linux-kernel-owner+w=401wt.eu-S1754119AbYJPD47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbYJPD47 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 23:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbYJPD4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 23:56:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:50460 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497AbYJPD4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 23:56:49 -0400
Message-ID: <48F6BAFE.6080106@kernel.org>
Date: Thu, 16 Oct 2008 12:54:38 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>, Tejun Heo <tj@kernel.org>, jeff@redhat.com,
       linux-ide@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] stop gcc warning about uninitialized 'dev' in	ata_scsi_scan_host
References: <20081015232505.GB9272@ldl.fc.hp.com> <48F6A2E7.5090005@kernel.org> <20081016034042.GA27621@ldl.fc.hp.com>
In-Reply-To: <20081016034042.GA27621@ldl.fc.hp.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 16 Oct 2008 03:56:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Chiang wrote:
> * Tejun Heo <tj@kernel.org>:
>> Alex Chiang wrote:
>>> Shuts up gcc-3.4.5-glibc-2.3.6 when it complains of:
>>>
>>> drivers/ata/libata-scsi.c: In function `ata_scsi_scan_host':
>>> drivers/ata/libata-scsi.c:3225: warning: 'dev' might be used
>>> uninitialized in this function
>>>
>>> Signed-off-by: Alex Chiang <achiang@hp.com>
>> Nacked-by: Tejun Heo <tj@kernel.org>
>>
>> Some gcc versions complain about sata_via, others complain
>> about something else.  Some versions complain about some
>> iterator usages while not complaining about others, but none of
>> those complaints is actually wrong or dangerous.  I don't think
>> adding = NULL whenever some version of gcc complains is the
>> right approach.
> 
> Hm, ok.
> 
> I guess we don't want to sprinkle these around all over the place
> just to solve cosmetic issues, which makes sense, but is there
> some other approach we could take instead? Any suggestions? Or
> just live with it?

I think the current policy is blaming gcc but I also added quite a few
bogus NULL initializations here and there and caught several bugs thanks
to those warnings.  We can think about adding an additional annotation
with leading double underbars which indicate that certain pointer
arguments to functions expect (or are okay with) pointers to
uninitialized variables which should be able to remove many of those
spurious warnings (on the caller side, the compiler can ignore the
warning and on the callee side the compiler can check whether it's being
dereferenced without being written to).  Does anyone know whether gcc
already has that type of annotation?

Thanks.

-- 
tejun
