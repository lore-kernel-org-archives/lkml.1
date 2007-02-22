Return-Path: <linux-kernel-owner+w=401wt.eu-S1751477AbXBVDAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477AbXBVDAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 22:00:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbXBVDAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 22:00:19 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:54365 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbXBVDAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 22:00:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=UhKEVL94V7msgDHS2IYFM8kgBT+TeRa/lCxmAwZbgkwpaNTmvE5sKxoZCfy292tbbj3W9C6Ql1YqUHjOeaolZsnZCTC2S+s9leLpZtbpCS3IXjo96Z15TTThzly/gFScwJQncMoS/ecqliRBin2G8zIEsM7Y77MpxGFuQgweyXY=
Message-ID: <a2ebde260702211900v29c3f9a3y45ec5867e36b7a4b@mail.gmail.com>
Date: Thu, 22 Feb 2007 11:00:16 +0800
From: "Dong Feng" <middle.fengdong@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: PREEMP_ACTIVE in cond_resched
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cond_resched() checks and conditionally sets PREEMPT_ACTIVE flag for
the current task. The comments says,

/*
* The BKS might be reacquired before we have dropped
* PREEMPT_ACTIVE, which could trigger a second
* cond_resched() call.
*/

My understanding is that cond_resched() would be indirectly invoked
twice recursively, through the following path,

cond_resched() -> schedule() -> reacquire_kernel_lock() -> down() ->
might_sleep() -> might_resched() -> cond_resched().

However, the above path is possible only in a voluntary-preemptive
kernel. In a full-preemptive kernel, I do not find any possible path
to cause recursive cond_resched(). Does that mean we can actually
remove the check and setting of PREEMPT_ACTIVE for a full-preemptive
kernel?
