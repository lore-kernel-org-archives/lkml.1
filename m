Return-Path: <linux-kernel-owner+w=401wt.eu-S1757588AbYKTWGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588AbYKTWGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 17:06:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756193AbYKTWG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 17:06:26 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:56088 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490AbYKTWGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 17:06:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=E/HhZWCXJ9yak99FPQfZNOoG66KK6ssASmcvKjhOJibS62ZZfQnQyWN+YWT1RNpyRX
         2f+LJa9M4TeSjAa447KINaFIQ3lvnWdxAAmiSPzX3FfwJyMfmxB+tM67Cdcveml4QkfU
         k9I1bSxc/kzJFhmLGVaBAe29MsNwUVKMwwDas=
Message-ID: <7c86c4470811201406y61e110f6nea16a2f776af085c@mail.gmail.com>
Date: Thu, 20 Nov 2008 23:06:22 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch] x86, bts: fix unlock problem in ds.c
Cc: "Markus Metzger" <markus.t.metzger@googlemail.com>,
       lkml <linux-kernel@vger.kernel.org>, work <markus.t.metzger@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20081120214805.GA8475@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1226743217.6162.4.camel@raistlin>
	 <7c86c4470811201314q564b64c0i99f3d9865d9cc8f0@mail.gmail.com>
	 <20081120214805.GA8475@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2008 at 10:48 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * stephane eranian <eranian@googlemail.com> wrote:
>
>> Markus,
>>
>> I think this patch is not quite right. You don't want to go out via
>> out_unlock because you're going to call ds_put_context)() when you
>> did not invoke the matching ds_get_context() (hidden in
>> ds_alloc_context). It happens later in the ds_request() function.
>
> i noticed that, and fixed it via:
>
>  10db4ef: x86, PEBS/DS: fix code flow in ds_request()
>
> can you still see problems with it?
>
Well, I have lots of problems with ds.c so I have heavily modified the
code therefore I have not pulled from
any public tree in several days.
