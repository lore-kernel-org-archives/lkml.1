Return-Path: <linux-kernel-owner+w=401wt.eu-S1755385AbYKDS4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385AbYKDS4V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 13:56:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753123AbYKDS4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 13:56:08 -0500
Received: from rv-out-0506.google.com ([209.85.198.239]:21190 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbYKDS4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 13:56:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=LcW6P+NokeukCzD+DgPfM1xLdh4yzgu5SA1KOVWKBjqTpMBVb5awzqGDljihaTwhuh
         fufWn6oT8SvjmwMn2vQEn66O8IiDNryVJs4n4OMMw7sqiFVUcl/eVVjFzKd4OAOmzZlO
         aWgHWRHBEN2Q69+sHjdN4y7tXsIXgPD65Olqk=
Message-ID: <86802c440811041056p631e2dc9i21c4994e3d01cf32@mail.gmail.com>
Date: Tue, 4 Nov 2008 10:56:05 -0800
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Ben Hutchings" <bhutchings@solarflare.com>
Subject: Re: [PATCH] x86: Don't allow nr_irqs > NR_IRQS
Cc: "Cyrill Gorcunov" <gorcunov@gmail.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <1225823807.3074.24.camel@achroite>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1225819102.3074.15.camel@achroite>
	 <20081104180012.GG21470@localhost> <1225823807.3074.24.camel@achroite>
X-Google-Sender-Auth: d6c695893a75b338
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 4, 2008 at 10:36 AM, Ben Hutchings
<bhutchings@solarflare.com> wrote:
> On Tue, 2008-11-04 at 21:00 +0300, Cyrill Gorcunov wrote:
> [...]
>> | I hit this when running net-next-2.6 (close to 2.6.28-rc3) on a
>> | Supermicro dual Xeon system.  NR_IRQS is 224 but probe_nr_irqs() detects
>> | 5 IOAPICs (!) and returns 240.  Here are the log messages:
>> |
>
> Well there must have been an earlier change that resulted in detecting 5
> IOAPICs instead of just 1, but that presumably would work as long as the
> irq_desc array was dynamically allocated.  This reversion breaks that.
>
> You don't really need to see the config; NR_IRQS is *always* 224 on
> normal x86-32 systems.
>

Yes. it should the same as setting to 64bit. we will cost some extra ram...

We can not make sparseirq/dyn_array to 2.6.28..., maybe 2.6.29 later.

Ingo,
Maybe we can put back dyn_array at first, that will still be 1:1
mapping..., and not waste memory..

YH
