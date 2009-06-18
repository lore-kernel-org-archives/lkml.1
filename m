Return-Path: <linux-kernel-owner+w=401wt.eu-S1753486AbZFRIGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbZFRIGy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 04:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759317AbZFRIG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 04:06:26 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:61577 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754927AbZFRIGQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 04:06:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MN48sm2Kz3lvus559pzSK/GZtRGBNa2Z/aLK3frHBo09yKYG97mWpr+C78Fror/yE6
         FG4+zxNFF/CX9+5H2ai769WO7Apr4xEScd/+7dkUY3q02Va5vmzvOA37Yk5irQ2EP2f6
         yZbfWi84OPVTcSeoCWNAwiJivMxBHTX36dpD0=
MIME-Version: 1.0
In-Reply-To: <4A39ED3B.2060800@jp.fujitsu.com>
References: <4A3601BF.2000201@jp.fujitsu.com> <4A3605A2.6000206@jp.fujitsu.com>
	 <851fc09e0906172249q40c99fc6n26662b533b063b9e@mail.gmail.com>
	 <4A39ED3B.2060800@jp.fujitsu.com>
Date: Thu, 18 Jun 2009 16:00:37 +0800
Message-ID: <851fc09e0906180100n27c0a80ej1fb12a5cabac21b0@mail.gmail.com>
Subject: Re: [PATCH 12/16] x86, mce: squash mce_intel.c into therm_throt.c
From: huang ying <huang.ying.caritas@gmail.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <ak@linux.intel.com>, Huang Ying <ying.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 18, 2009 at 3:31 PM, Hidetoshi
Seto<seto.hidetoshi@jp.fujitsu.com> wrote:
> huang ying wrote:
>> 2009/6/15 Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>:
>>> move intel_init_thermal() into therm_throt.c
>>>
>>> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
>>> ---
>>>  arch/x86/kernel/cpu/mcheck/Makefile      |    2 +-
>>>  arch/x86/kernel/cpu/mcheck/mce_intel.c   |   73 ------------------------------
>>>  arch/x86/kernel/cpu/mcheck/therm_throt.c |   66 +++++++++++++++++++++++++++
>>>  3 files changed, 67 insertions(+), 74 deletions(-)
>>>  delete mode 100644 arch/x86/kernel/cpu/mcheck/mce_intel.c
>>
>> Why we need this patch? I think the design principle behind MCE is to
>> separate vendor/cpu specific code into different files. At least
>> #ifdef CONFIG_X86_MCE_INTEL should be used around moved code.
>
> Because at this time there are no vendor other than Intel that uses
> thermal codes here.  I don't know much about AMD, whether there are
> any plan to implement AMD specific thermal codes or not, and why they
> have to make such specific thing here in future (patent?).
>
> You can pull out "codes may not be shared" from therm_throt.c and
> put it again into mce_intel.c (that was mce_intel_64.c).  But I
> believe it is not needed now, until another code is available.
> Or you can rename therm_throt.c to thermal_intel.c or so for a while.

I think thermal_intel.c is better.

Best Regards,
Huang Ying
