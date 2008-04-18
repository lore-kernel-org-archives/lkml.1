Return-Path: <linux-kernel-owner+w=401wt.eu-S1756499AbYDROZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499AbYDROZk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 10:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbYDROZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 10:25:31 -0400
Received: from rv-out-0708.google.com ([209.85.198.245]:24373 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752645AbYDROZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 10:25:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=eFgPJsvnBAosQ5TN6pny9JhCMXa07UFoPafUXUA/RxlmxBp9BrHmmmEcnniAZk57Kb2w1KcgBH7Cj3/EK+8xouvbbqZCUBFErdv0xdX1htY0kwuCtoLVOdZe/BG7PJaf4+pW97rIihuc3i0ZHORZc1WxkhxptKs+bB39s26ZeVw=
Message-ID: <2c0942db0804180725h88fa7d1mb8e85e5a8b0aede6@mail.gmail.com>
Date: Fri, 18 Apr 2008 07:25:27 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "pradeep singh rautela" <rautelap@gmail.com>
Subject: Re: [PATCH 5/5] tun: vringfd xmit support.
Cc: "Rusty Russell" <rusty@rustcorp.com.au>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Max Krasnyansky" <maxk@qualcomm.com>,
       virtualization@lists.linux-foundation.org
In-Reply-To: <6bc632150804180446u29e5dae9h986e1d255e584d21@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804181433.48488.rusty@rustcorp.com.au>
	 <200804181441.10499.rusty@rustcorp.com.au>
	 <200804181442.17251.rusty@rustcorp.com.au>
	 <200804181443.24812.rusty@rustcorp.com.au>
	 <6bc632150804180446u29e5dae9h986e1d255e584d21@mail.gmail.com>
X-Google-Sender-Auth: 5f334b19a4c6da6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2008 at 4:46 AM, pradeep singh rautela
<rautelap@gmail.com> wrote:
>
> On Fri, Apr 18, 2008 at 10:13 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>  >  +               /* How many pages will this take? */
>  >  +               npages = 1 + (base + len - 1)/PAGE_SIZE - base/PAGE_SIZE;
>
>  Hi Rusty,
>  A trivial suggestion, how about
>           npages = 1+(len -1)/PAGE_SIZE ?

That's not the same. In particular, his version accounts for the
fractional page at the beginning, while yours doesn't.

While it's tempting to use algebra to simplify things, it's not safe
to do so when the expression involves division over the integers. The
only care-free integer math in a computer is subtraction and ++.
