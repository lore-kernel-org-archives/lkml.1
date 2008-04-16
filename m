Return-Path: <linux-kernel-owner+w=401wt.eu-S1760312AbYDPIwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760312AbYDPIwP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 04:52:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754336AbYDPIv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 04:51:59 -0400
Received: from qb-out-0506.google.com ([72.14.204.229]:11231 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166AbYDPIv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 04:51:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=krpPf+4PpaiS/YHad36NPRg55eco+z5+Lh+0iAfvUaPECkXXD4jCUxt2vSuRRwakKgytRQKkoplqZXFxxzlPO9k0SWjMfew6fR6IO08jvY7Yhc5m881Xq1C5xpbm2wo7qwnitcTxNhyHV39WdMrl69l4HEXMx5WnoQvSOu8voyE=
Message-ID: <7c86c4470804160151w75aaa1doaf98a46543ba03f9@mail.gmail.com>
Date: Wed, 16 Apr 2008 10:51:57 +0200
From: "stephane eranian" <eranian@googlemail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [patch 1/1] x86, ptrace: PEBS support
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Markus Metzger" <markus.t.metzger@intel.com>, andi-suse@firstfloor.org,
       hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de, markus.t.metzger@gmail.com,
       suresh.b.siddha@intel.com, roland@redhat.com, mtk.manpages@gmail.com,
       juan.villacis@intel.com
In-Reply-To: <4805A798.7050004@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080408110158.A9336@sedona.ch.intel.com>
	 <20080415173534.b746f8da.akpm@linux-foundation.org>
	 <4805A798.7050004@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2008 at 9:15 AM, Andi Kleen <andi@firstfloor.org> wrote:
>
>  > Should we skip the RLIMIT_MEMLOCK check if capable(CAP_IPC_LOCK)?
>
>  FWIW I don't think we should. They are not really related.
>
That is true even though I see in mlock() that both are actually used.
I don't check against capabilities in perfmon, but I check RLIMIT_MEMLOCK
for the sampling buffer.

I see the capset()/capget() syscalls, however, I am still not clear as to how a
sysadmin could set up the capabilities for users via PAM or other
security interface.

>
>  > It's a fairly large patch.
>
>  The original version was much smaller -- a lot of the increase came out of
>  review feedback for "more infrastructure" etc. I don't think you can blame
>  Markus for that.
>
I believe the patch could potentially be broken into multiple pieces:
ds/bts, pebs, ptrace.
