Return-Path: <linux-kernel-owner+w=401wt.eu-S1760065AbZKLE2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760065AbZKLE2A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 23:28:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757383AbZKLE2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 23:28:00 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:22749 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828AbZKLE17 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 23:27:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nAYrtxXs2h74FhFEjvgBQ5yt58YaRm1HDK/2wV8RSOg8YLBO2RKn0Ve21w8iSXS+wJ
         BItSV1ZqPS8rSvbL8xmF1EH0O2GOxE8eDom06dDOz7SoIDDrAmM3NX/jagHvMXnFsOpj
         T/71liKdhIa8CW7tg34R8db1e5dfjS8he7K8s=
MIME-Version: 1.0
In-Reply-To: <4AFB3D31.6070901@zytor.com>
References: <1257500482-16182-1-git-send-email-ling.ma@intel.com>
	 <4AF457E0.4040107@zytor.com> <4AF4784C.5090800@zytor.com>
	 <8FED46E8A9CA574792FC7AACAC38FE7714FCF772C9@PDSMSX501.ccr.corp.intel.com>
	 <4AF7C66C.6000009@zytor.com> <20091109080830.GI453@elte.hu>
	 <8FED46E8A9CA574792FC7AACAC38FE7714FE830398@PDSMSX501.ccr.corp.intel.com>
	 <20091111203425.GA25401@lenovo> <4AFB3D31.6070901@zytor.com>
Date: Thu, 12 Nov 2009 07:28:03 +0300
Message-ID: <aa79d98a0911112028nf3fc475r30aa8dc37936ea22@mail.gmail.com>
Subject: Re: [PATCH RFC] [X86] performance improvement for memcpy_64.S by fast 
	string.
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Ma, Ling" <ling.ma@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 12, 2009 at 1:39 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 11/11/2009 12:34 PM, Cyrill Gorcunov wrote:
>>                                               memcpy_orig     memcpy_new
>> TPT: Len 1024, alignment  8/ 0:               490             570
>> TPT: Len 2048, alignment  8/ 0:               826             329
>> TPT: Len 3072, alignment  8/ 0:               441             464
>> TPT: Len 4096, alignment  8/ 0:               579             596
>> TPT: Len 5120, alignment  8/ 0:               723             729
>> TPT: Len 6144, alignment  8/ 0:               859             861
>> TPT: Len 7168, alignment  8/ 0:               996             994
>> TPT: Len 8192, alignment  8/ 0:               1165            1127
>> TPT: Len 9216, alignment  8/ 0:               1273            1260
>> TPT: Len 10240, alignment  8/ 0:      1402            1395
>> TPT: Len 11264, alignment  8/ 0:      1543            1525
>> TPT: Len 12288, alignment  8/ 0:      1682            1659
>> TPT: Len 13312, alignment  8/ 0:      1869            1815
>> TPT: Len 14336, alignment  8/ 0:      1982            1951
>> TPT: Len 15360, alignment  8/ 0:      2185            2110
>>
>> I've run this test a few times and results almost the same,
>> with alignment 1024, 3072, 4096, 5120, 6144, new version a bit slowly.
>>
>
> Was the result for 2048 consistent (it seems odd in the extreme)... the
> discrepancy between this result and Ling's results bothers me; perhaps
> the right answer is to leave the current code for Core2 and use new code
> (with a lower than 1024 threshold?) for NHM and K8?
>
>        -hpa
>

Hi Peter,

no, results for 2048 is not repeatable (that is why I didn't mention this number
in a former report).

Test1:
TPT: Len 2048, alignment  8/ 0:	826	329
Test2:
TPT: Len 2048, alignment  8/ 0:	359	329
Test3:
TPT: Len 2048, alignment  8/ 0:	306	331
Test4:
TPT: Len 2048, alignment  8/ 0:	415	329

I guess this was due to cpu frequency change from 800 to 2.1Ghz since
I did tests manually
not using any kind of bash cycle to run the test program.
