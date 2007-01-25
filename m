Return-Path: <linux-kernel-owner+w=401wt.eu-S1030566AbXAYVGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030566AbXAYVGI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 16:06:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030567AbXAYVGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 16:06:08 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:2863 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030566AbXAYVGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 16:06:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=B3BVxP5M4mIg5/1NZDTG71XgdpoajMDGbm5pYBPZolKC+eTSZqBVW9nHFR/TcAjih/WzFsArIclRVBMlV5Nc+Yo235t1gtHFVKf9zUCeNTvk3xIVqa1evdqJIQ7BoG+HAbw0w8ra1YiE7Ivcs62ippDc/kn2/datZLJReXichws=
Message-ID: <45B91BAC.5010707@googlemail.com>
Date: Thu, 25 Jan 2007 22:05:48 +0100
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Venkat Yekkirala <vyekkirala@TrustedCS.com>,
       David Miller <davem@davemloft.net>
Subject: Re: Linux 2.6.20-rc6
References: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Linus Torvalds napisał(a):
> It's been more than a week since -rc5, but I blame everybody (including 
> me) being away for Linux.conf.au and then me waiting for a few days 
> afterwards to let everybody sync up.
> 
> So there it is, -rc6, hopefully the last -rc of the series.
> 
> I'd like everybody to take a really good look at any regressions that 
> Adrian has been pointing out, and that very much includes the people who 
> reported them too, so that we can confirm whether they are still active 
> and relevant.
> 

It doesn't build for me.

make O=/dir
[..]
security/built-in.o: In function `security_set_bools':
(.text+0x12471): undefined reference to `flow_cache_genid'
security/built-in.o: In function `security_load_policy':
(.text+0x128b3): undefined reference to `flow_cache_genid'
make[1]: *** [.tmp_vmlinux1] Error 1
make: *** [_all] Error 2

334c85569b8adeaa820c0f2fab3c8f0a9dc8b92e is first bad commit
commit 334c85569b8adeaa820c0f2fab3c8f0a9dc8b92e
Author: Venkat Yekkirala <vyekkirala@TrustedCS.com>
Date:   Mon Jan 15 16:38:45 2007 -0800

    [SELINUX]: increment flow cache genid

    Currently, old flow cache entries remain valid even after
    a reload of SELinux policy.

    This patch increments the flow cache generation id
    on policy (re)loads so that flow cache entries are
    revalidated as needed.

    Thanks to Herbet Xu for pointing this out. See:
    http://marc.theaimsgroup.com/?l=linux-netdev&m=116841378704536&w=2

    There's also a general issue as well as a solution proposed
    by David Miller for when flow_cache_genid wraps. I might be
    submitting a separate patch for that later.

    I request that this be applied to 2.6.20 since it's
    a security relevant fix.

    Signed-off-by: Venkat Yekkirala <vyekkirala@TrustedCS.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

:040000 040000 aad4041b6ef7f6c0503fb9b66bfe3ce4db3405db 7b3c344f46ac21d524f9eb1c15b9e64b3459f2b7 M      security

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group
(http://www.stardust.webpages.pl/ltg/)
