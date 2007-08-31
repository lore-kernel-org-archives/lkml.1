Return-Path: <linux-kernel-owner+w=401wt.eu-S1760692AbXHaTla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760692AbXHaTla (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 15:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbXHaTlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 15:41:22 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:22331 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbXHaTlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 15:41:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:references:in-reply-to:subject:date:message-id:mime-version:content-type:content-transfer-encoding:x-mailer:thread-index:content-language;
        b=cFG0oNLloGkNpuv/+NXLxXn6Ak0MAjk0j1QkOCRR/p1r+u005YGnSdkz36lqtRmU0iVR256vObEI+13phvFdkq2j/15Z9rjbd5e4APCs1K+MT8ZtXS/SM3BHnezTE75WPzYqCbXlI9nl/nwyiRo+YHBXrWrx7u0rhbar5itNsdY=
From: "Hua Zhong" <hzhong@gmail.com>
To: "'Trond Myklebust'" <trond.myklebust@fys.uio.no>
Cc: "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Frank van Maarseveen'" <frankvm@frankvm.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       <akpm@linux-foundation.org>
References: <000701c7eb49$cff701c0$6fe50540$@com>	 <1188513433.6626.24.camel@heimdal.trondhjem.org>	 <alpine.LFD.0.999.0708302038310.25853@woody.linux-foundation.org>	 <1188577275.6649.133.camel@heimdal.trondhjem.org>	 <006a01c7ebff$709354c0$51b9fe40$@com> <1188587601.19730.45.camel@heimdal.trondhjem.org> 
In-Reply-To: 
Subject: RE: recent nfs change causes autofs regression
Date: Fri, 31 Aug 2007 12:41:09 -0700
Message-ID: <006c01c7ec06$e24378a0$a6ca69e0$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcfsAwZpqgwnfKeOSGi52XTjHDLJnwAAoPPwAAA0CcA=
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> It's not about default (for which backward compatibility is most
> important and this patch is perfectly fine), but user explicitly asks
> for "sharecache". In this case if for any reason the cache cannot be
> shared, I am not sure if he should get an error back.
> 
> I for one agree with Ian and Linus that changing default to
> nosharecache might be the best thing to do, but since I am now able to
> use the latest kernel, I am very happy already.

Actually, I think just fine-tuning it a bit may be better:

1. make 'nosharecache' as default
2. apply the algorithm in this patch to 'nosharecache': if the fsid and
mount options are the same, then share cache

This way the default behavior does not change, but both algorithms have
pitfalls, and we choose from:
1. if user specifies "sharecache", he may end up with nosharecache if mount
options are different
And
2. if user specifies "nosharecache", he may end up with sharecache if mount
options are the same

I'd think 2 is better (least surprise). I cannot think of a case where 2 is
actually a bad thing.

Comments?

> Thanks a lot for your attention to my problem. :-)
> 
> > Trond


