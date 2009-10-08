Return-Path: <linux-kernel-owner+w=401wt.eu-S1758014AbZJHMnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014AbZJHMnB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 08:43:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757921AbZJHMnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 08:43:00 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:35759 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757936AbZJHMnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 08:43:00 -0400
Subject: Re: [2.6.32-rc3 kmemleak] WARNING: at
	kernel/lockdep.c:3161check_flags+0xbe/0x180()
From: Catalin Marinas <catalin.marinas@arm.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
In-Reply-To: <200910082134.EJD35962.HLFSQVFOOFMJOt@I-love.SAKURA.ne.jp>
References: <200910050315.n953FCD9030264@www262.sakura.ne.jp>
	 <20091007155142.GB6743@linux.vnet.ibm.com>
	 <200910082134.EJD35962.HLFSQVFOOFMJOt@I-love.SAKURA.ne.jp>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 08 Oct 2009 13:42:18 +0100
Message-Id: <1255005738.6715.6.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Oct 2009 12:42:19.0894 (UTC) FILETIME=[C66B3160:01CA4814]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-08 at 21:34 +0900, Tetsuo Handa wrote:
> If the stack dump is correct, this error indicates circular function calls.
> We need to find the location which triggers circular memory allocation.
> Maybe just checking for NULL is not sufficient.

The circular function call is expected, nothing to do with the NULL
checking. You get callbacks from the slab allocator into kmemleak which
also allocates memory (but this latter call isn't traced - similar
behaviour in kmemtrace).

-- 
Catalin

