Return-Path: <linux-kernel-owner+w=401wt.eu-S1753432AbYCRMBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbYCRMBh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 08:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbYCRMBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 08:01:30 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:9053 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbYCRMBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 08:01:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=azjXShO68zYnEsnt/YZPUQcWpcafJ76qz7eSrlA0qRsv6z7Undje/u0OkjT7lH3ELVpzwFkq257wkvtleGoArjaU1MQs7NP72iXLUjpEBwmH/vnMiAG7055+A4yPwlYzw87CRMSgcgNqPGwXzAN8FBJWtY05bMBANcpKfaMvDYk=
Message-ID: <1865922a0803180501g1f3b270bm7034fc0fc826a108@mail.gmail.com>
Date: Tue, 18 Mar 2008 14:01:27 +0200
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>
Subject: Re: [PATCH] de-semaphorize smackfs
Cc: "Jonathan Corbet" <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       "Casey Schaufler" <casey@schaufler-ca.com>
In-Reply-To: <20080318073503.GA25958@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <30338.1205795680@vena.lwn.net>
	 <20080318073503.GA25958@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!,

On Tue, Mar 18, 2008 at 9:35 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Mar 17, 2008 at 05:14:40PM -0600, Jonathan Corbet wrote:
>  > While looking at the generic semaphore patch, I came to wonder what the
>  > remaining semaphore users in the kernel were actually doing.  After a
>  > quick grep for down_interruptible(), smackfs remained at the bottom of
>  > my screen.  It seems like a straightforward mutex case - low-hanging
>  > fruit.  So here's a conversion patch; compile-tested only, but what
>  > could go wrong?
>

I have a feeling that a very nice LWN article is under the way :).

>
>  The lock is kept while returning to userspace and could potentially
>  be release by another process.  This is not allowed for mutexes.
>

Yes, this was an artifact of an old design where different processes
write _sessions_ were not allowed to interleave, thus locking them in
the very beginning (open).

Since now those sessions can be interleaved safely, I'll modify this
issue today to move the locking to each write() call instead.

Thanks Jonathan/Cristoph

-- 
Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com
