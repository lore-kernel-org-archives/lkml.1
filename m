Return-Path: <linux-kernel-owner+w=401wt.eu-S1030622AbXCBWUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030622AbXCBWUi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 17:20:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030628AbXCBWUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 17:20:38 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41013 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030622AbXCBWUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 17:20:37 -0500
Message-ID: <45E8A300.9020001@redhat.com>
Date: Fri, 02 Mar 2007 17:19:44 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: John Reiser <jreiser@BitWagon.com>
CC: Oleg Nesterov <oleg@tv-sign.ru>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: + fully-honor-vdso_enabled.patch added to -mm tree
References: <20070301175207.GA849@tv-sign.ru> <45E891E6.7090807@BitWagon.com>
In-Reply-To: <45E891E6.7090807@BitWagon.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John Reiser wrote:
> The value of ->sysenter_return is interpreted in user space by the
> sysexit instruction; nobody else cares what the value is.  The kernel
> is not required to provide a good value when vdso_enabled is zero,
> because the kernel has not told the process that sysenter is valid
> (by setting AT_SYSINFO.)

Doesn't matter because a malicious user can still execute sysenter.
We do have to deal with that somehow, so we have to put something
safe in there.

> Correct.  Changing vdso_enabled from 0 to non-zero must be prepared
> to lose this race if it is not prevented.  Ordinarily it won't matter
> because the administrator will perform such changes at a "quiet" time.
> 

We have to deal with all the possibilities here, too.
