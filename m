Return-Path: <linux-kernel-owner+w=401wt.eu-S1757374AbZDNSCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374AbZDNSCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 14:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753081AbZDNSCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 14:02:21 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52842 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752339AbZDNSCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 14:02:20 -0400
Date: Tue, 14 Apr 2009 19:03:01 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Hugh Dickins <hugh@veritas.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, arjan@linux.intel.com,
       gregkh@suse.de, jmorris@namei.org, hooanon05@yahoo.co.jp,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: current->mm == NULL in security_vm_enough_memory().
Message-ID: <20090414190301.2c151fa2@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.64.0904141812390.24679@blonde.anvils>
References: <200903260130.n2Q1U9EJ040448@www262.sakura.ne.jp>
	<alpine.LRH.2.00.0903261236580.30336@tundra.namei.org>
	<200904092105.HBG52601.MHFOtQOLSVFOFJ@I-love.SAKURA.ne.jp>
	<200904132127.FBG30222.OOFFtQLJFOHSMV@I-love.SAKURA.ne.jp>
	<Pine.LNX.4.64.0904141812390.24679@blonde.anvils>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you want to permit a NULL vm you can use vm_enough_memory_kern() to
indicate that the caller may be a kernel thread and you are ok with that.

The case you are now hitting was considered in the original design and
provided for. The default handler traps NULL to be sure we catch cases
where nobody has considered if NULL mm is meaningful and valid (such as
old code pre the checks)

Given this case appears to be ok (if a bit novel by the kernels
standards) just flipping to use the _kern() version will do the job.

Alan

