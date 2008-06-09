Return-Path: <linux-kernel-owner+w=401wt.eu-S1760669AbYFIVOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760669AbYFIVOn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 17:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759319AbYFIVMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 17:12:53 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:31105 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758966AbYFIVMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 17:12:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Yi4Q9RifYXWme7l3dxAydggvQMomOwVIo3il2xg9IEccMUzlh66NM7Sz748sJhHSEH
         mn0GojuyTj/TtEyFtFoohMZKv0Xzg6J+msSE/fxicBjIjIzb+6xNb/bmEcU92HWRzhwe
         80Rx+8IynURjm8V7ACI41rAEwqwgNIQhECJjU=
Message-ID: <84144f020806091412q778198cbi57a3a8b061a56f8f@mail.gmail.com>
Date: Tue, 10 Jun 2008 00:12:50 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] vmallocinfo: Add NUMA informations
Cc: "Christoph Lameter" <clameter@sgi.com>, dada1@cosmosbay.com,
       kosaki.motohiro@jp.fujitsu.com, nickpiggin@yahoo.com.au,
       hugh@veritas.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080609140503.83985d10.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48439916.2070108@cosmosbay.com>
	 <20080602160548.B6D4.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <4844BC75.8040705@cosmosbay.com>
	 <20080603144054.973284bb.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0806090715020.29723@schroedinger.engr.sgi.com>
	 <20080609140503.83985d10.akpm@linux-foundation.org>
X-Google-Sender-Auth: 5e5865df37109719
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 12:05 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> yup.  Oh well, it's not a big deal.
>
> Except the inlined
>
>        if (n != 0 && size > ULONG_MAX / n)
>                return NULL;
>
> is a bit bloaty/inefficient.  I expect that it's often the case that
> one of `n' and `size' is not a compile-time constant.

I think it was out-of-line at first but then somebody made it inline
as an optimization...

On Tue, Jun 10, 2008 at 12:05 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> otoh, there's one good thing about kcalloc: it actually checks for
> multiplicative overflows, whereas the open-coded version often forgets
> to do that.

Yes. That's why we did kcalloc() in the first place. kzalloc() (aka
akpmalloc) came in much later.
