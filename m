Return-Path: <linux-kernel-owner+w=401wt.eu-S1756055AbYFQQZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbYFQQZZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 12:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753515AbYFQQZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 12:25:18 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:14573 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbYFQQZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 12:25:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=fv3LjdgmQk8Oo4f7Y/m9DTi1OgrjEOwE9foHxdmBeESvXXAGgnpz9rvbLldpJAFZVr
         W16fBvPNENqMkNLWvqxWm4O2GCJMscdtFrhgzcuWjOmMUyhIDq5A22af3WTvdq2gzk/Z
         Hd9pyk/9rib8fiwg0va6xnL3ClnPSlANtTfnc=
Message-ID: <5d6222a80806170925u197b0f7bye6fb9b071a3d03f@mail.gmail.com>
Date: Tue, 17 Jun 2008 13:25:16 -0300
From: "Glauber Costa" <glommer@gmail.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] x86: merge setup_memory_map with e820
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <86802c440806170918l1cb10014nccfd8d3e2b13da47@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806161303.31997.yhlu.kernel@gmail.com>
	 <200806161958.28627.yhlu.kernel@gmail.com>
	 <5d6222a80806170531g50a72ea2r963bba8e404e619f@mail.gmail.com>
	 <4857E07F.3070209@zytor.com>
	 <86802c440806170918l1cb10014nccfd8d3e2b13da47@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2008 at 1:18 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On Tue, Jun 17, 2008 at 9:04 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> Glauber Costa wrote:
>>>>
>>>> +       boot_params.e820_entries = new_nr;
>>>> +       if (copy_e820_map(boot_params.e820_map, boot_params.e820_entries)
>>>> < 0) {
>>>> +#ifdef CONFIG_X86_64
>>>> +               early_panic("Cannot find a valid memory map");
>>>> +#else
>>>
>>> Can't this be made dependant on HIGHMEM instead of X86_64? It seems
>>> high-memory dependant anyway. Also, are you sure
>>> this code that maps into himem would work with HIGHMEM disabled anyway?
>
> that is behavoir before merge.
>
>>>
>>
>> Uhm... x86-64 and HIGHMEM are mutually exclusive.
>>
>> Either way, it shouldn't be dependent on anything; there is no reason why
>> the #else clause can't be applied to both.
>
> remove the early_panic?

If this can be done, I'm for it.
However, it would be better to leave this patch as is, and throw in
another one that just address that, for bisectability purposes.
> YH
>



-- 
Glauber Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
