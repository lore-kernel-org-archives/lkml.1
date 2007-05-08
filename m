Return-Path: <linux-kernel-owner+w=401wt.eu-S967294AbXEHLdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967294AbXEHLdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 07:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934566AbXEHLdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 07:33:21 -0400
Received: from [212.12.190.181] ([212.12.190.181]:33122 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S934519AbXEHLdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 07:33:20 -0400
From: Al Boldi <a1426z@gawab.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Execute in place
Date: Tue, 8 May 2007 14:36:11 +0300
User-Agent: KMail/1.5
Cc: Dmitry Krivoschekov <dmitry.krivoschekov@gmail.com>,
       linux-kernel@vger.kernel.org
References: <200705030211.36293.a1426z@gawab.com> <200705072356.51283.a1426z@gawab.com> <4640137A.8030000@zytor.com>
In-Reply-To: <4640137A.8030000@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705081436.11928.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Al Boldi wrote:
> >> What you're talking about is, *and should be*, a different filesystem.
> >> You will relatively quickly find that you have to deal with the same
> >> kind of stuff that you have to in any filesystem.
> >
> > That's exactly what I want to avoid, as this would introduce a
> > performance penalty.
> >
> > All we need is a periodically synced tmpfs to mmap, with a minimal
> > stream into page-cache algo on mount.
>
> ... which would be completely useless, because you wouldn't get any sort
> of coherency; you would have pointers pointing into space, etc. etc.

You don't really think that anybody is suggesting to store the tmpfs data 
without any coherency, do you?

I am suggesting that you can easily isolate tmpfs coherency from the rest of 
the page-cache, by simply streaming tmpfs data out to an mmap and plugging 
it with the tmpfs fat on umount.  And streaming things back in on mount.

> Sorry, it's useless.

Persisting tmpfs is useful for the mere case of saving you the need to 
repopulate on mount.


Thanks!

--
Al

