Return-Path: <linux-kernel-owner+w=401wt.eu-S1755092AbYL1CIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092AbYL1CIS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 21:08:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753856AbYL1CID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 21:08:03 -0500
Received: from rv-out-0506.google.com ([209.85.198.232]:31521 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbYL1CIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 21:08:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=RYfhslKZrsY0y1pJeJy0TKJB05czeuClTJZh0bCt8SrHMcSr/2A4nIy7dbppc6UJXy
         feAXqxDmn1cq7OwHJHoHEIO5hwftqu5Y7o6KSFE71hFNg22/UI6Qi+kbfDnHh9poYo3b
         xmdGisIpxNjH9FvhL0GxsUhPYpNvFU8AvBgSY=
Message-ID: <86802c440812271807q3decd21i5da99754d708449d@mail.gmail.com>
Date: Sat, 27 Dec 2008 18:07:59 -0800
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Hugh Dickins" <hugh@veritas.com>
Subject: Re: linux-next: parsing mem=700M broken
Cc: "Rusty Russell" <rusty@rustcorp.com.au>, "Ingo Molnar" <mingo@elte.hu>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Paul Mackerras" <paulus@samba.org>,
       "Benjamin Herrenschmidt" <benh@au1.ibm.com>
In-Reply-To: <Pine.LNX.4.64.0812280033070.24494@blonde.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0812230257440.27467@blonde.anvils>
	 <200812241808.16195.rusty@rustcorp.com.au>
	 <Pine.LNX.4.64.0812241437230.15556@blonde.anvils>
	 <200812272342.54881.rusty@rustcorp.com.au>
	 <Pine.LNX.4.64.0812280033070.24494@blonde.anvils>
X-Google-Sender-Auth: b3f9268bb55b964e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 27, 2008 at 4:43 PM, Hugh Dickins <hugh@veritas.com> wrote:
> On Sat, 27 Dec 2008, Rusty Russell wrote:
>> > On Thursday 25 December 2008 01:14:35 Hugh Dickins wrote:
>> > But (of course: it's a patch to arch/x86) doesn't help at all on
>> > ppc64; and I presume other architectures also remain broken...
>>
>> Confirmed ppc64.  But it's broken in a *different* way.
>>
>> Whereas most archs called parse_early_param from setup_arch, powerpc
>> does it before start_kernel.  So instead of moving parsing earlier,
>> my patch actually moved it later for powerpc.
>>
>> Too late, for mem=.
>>
>> Rather than try to untangle the powerpc boot process (most archs would
>> do most of this in setup_arch), I think I have to expose the parser
>> again so they can call it:
>>
>> commit 25bf48b74b9fb23b347d00656b604f9e55c72183
>> Author: Rusty Russell <rusty@rustcorp.com.au>
>> Date:   Sat Dec 27 23:40:37 2008 +1030
>>
>>     Fix powerpc (tested on ppc64) command line handling.
>>     Powerpc used to call parse_early_param() really early; the change made
>>     it too late.  Put it back.
>
> I'll make no pretence of reviewing any of this, but this has
> indeed got mem= back working for me on a 2.6.28-rc9-mm1 - thanks!
>
> I have to wonder if all this comes too late in the cycle for 2.6.29:
> changing the early param handling of all the arches is difficult,
> and apparently hasn't been much tested in the short time that it's
> been out there in linux-next.  But of course, not for me to decide.
>

should be ok, just need to go over all early_param()

YH
