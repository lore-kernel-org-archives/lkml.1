Return-Path: <linux-kernel-owner+w=401wt.eu-S1759365AbXFDRCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759365AbXFDRCT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 13:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757156AbXFDRCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 13:02:12 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:31077 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756785AbXFDRCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 13:02:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=tsLNHrCdZcjAn0BBJJtOsHNA+muP0Pc+1ldMEEFVh/+Nhxfp/WKzME+UwkppatV7AfyRjEExvyZr1qnb0PgahBsKBv623BxFkJFXsDW4TUCpdV/nLUJORG3QiYVH6dGZ5daVkLfZC9FXlVzaML2EKtDSAdKZHhn5oJxYUykvYMQ=
Message-ID: <84144f020706041002t39142548l29cff861461dd7d7@mail.gmail.com>
Date: Mon, 4 Jun 2007 20:02:09 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Roland Dreier" <rdreier@cisco.com>
Subject: Re: SLUB: Return ZERO_SIZE_PTR for kmalloc(0)
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Christoph Lameter" <clameter@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, jeremy@goop.org
In-Reply-To: <ada6463llgr.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0706011831170.10767@schroedinger.engr.sgi.com>
	 <Pine.LNX.4.64.0706012057580.11358@schroedinger.engr.sgi.com>
	 <20070601213117.1178e8e0.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0706012139480.11577@schroedinger.engr.sgi.com>
	 <84144f020706040808t4882f961t80b8d8eb145bfa50@mail.gmail.com>
	 <Pine.LNX.4.64.0706040916090.23191@schroedinger.engr.sgi.com>
	 <84144f020706040922v56cb10eg5a730b4abe9d5251@mail.gmail.com>
	 <alpine.LFD.0.98.0706040924070.23741@woody.linux-foundation.org>
	 <84144f020706040937xb06535em543fa887ad65ee8f@mail.gmail.com>
	 <ada6463llgr.fsf@cisco.com>
X-Google-Sender-Auth: 013bd1156cf9c526
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/4/07, Roland Dreier <rdreier@cisco.com> wrote:
> No, because as was mentioned earlier in the thread, we want code to be
> able to handle 0-sized allocations without special cases.  The goal is
> that code like
>
>         buf = kmalloc(nobj * obj_size);
>         if (buf == NULL)
>                 return -ENOMEM;
>
> should work fine if nobj happens to be 0.  But we do want to get an
> oops if the code actually tries to read or write *buf.

Aah, missed that part of the discussion. Sorry for the noise ;-)
