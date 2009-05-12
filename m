Return-Path: <linux-kernel-owner+w=401wt.eu-S1754205AbZELUEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbZELUEA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 16:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbZELUDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 16:03:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38380 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955AbZELUDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 16:03:34 -0400
From: Jarod Wilson <jarod@redhat.com>
Organization: Red Hat, Inc.
To: linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: tcrypt: add option to not exit on success
Date: Tue, 12 May 2009 16:02:45 -0400
User-Agent: KMail/1.11.2 (Linux/2.6.29.1-102.fc11.x86_64; KDE/4.2.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
       Neil Horman <nhorman@tuxdriver.com>
References: <200905111006.32675.jarod@redhat.com>
In-Reply-To: <200905111006.32675.jarod@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905121602.45960.jarod@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 May 2009 10:06:32 Jarod Wilson wrote:
> At present, the tcrypt module always exits with an -EAGAIN upon
> successfully completing all the tests its been asked to run. There
> are cases where it would be much simpler to verify all tests passed
> if tcrypt simply stayed loaded (i.e. returned 0). Specifically, in
> fips mode, all self-tests need to be run from the initrd, and its
> much simpler to check the ret from modprobe for success than to
> scrape dmesg. To make this doable, I've simply added a module param
> to allow this behavior, leaving the default behavior more or less
> the same as before, although now we're tracking all success/failure
> rets as well.

I've been reminded that a self-test failure in fips mode means an
immediate panic, so modprobe never sees the ret in that case, but if
the module load failed for other reasons, a non-zero return value
from modprobe is possible w/o traversing the code paths that trigger
a self-test failure panic. For one, if the tcrypt module were to go
missing for some reason, modprobe would have a non-zero ret, and the
initrd would need to handle panicking the system.

Would there be any objections to dropping the noexit parameter
entirely and just making its behavior the default? It would make
all users regardless of fips mode notice failures more readily.

-- 
Jarod Wilson
jarod@redhat.com
