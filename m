Return-Path: <linux-kernel-owner+w=401wt.eu-S1754329AbZFCLbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329AbZFCLbY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 07:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbZFCLbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 07:31:17 -0400
Received: from smtprelay06.ispgateway.de ([80.67.31.40]:34365 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166AbZFCLbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 07:31:17 -0400
References: <1240950704.3781.12.camel@maxim-laptop> <cone.1241648222.299676.7476.1000@mentalhome> <20090509171432.GA31126@liondog.tnic> <cone.1242065107.695268.13534.1000@onepiie> <20090512060231.GB26286@liondog.tnic> <cone.1242669880.118150.4276.1000@deskpiie> <20090524192219.GA30285@liondog.tnic> <cone.1243865541.882421.4368.1000@deskpiie> <20090603073552.GA2671@liondog.tnic> <cone.1244016635.374757.16292.1000@arca> <9ea470500906030352x7d72f3c7s94b12701142a7f7a@mail.gmail.com>
Message-ID: <cone.1244028557.77039.16292.1000@arca>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Borislav Petkov <petkovbb@googlemail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, lenb@kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [PATCH] Acer Aspire One Fan Control
Date: Wed, 03 Jun 2009 13:29:17 +0200
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Df-Sender: 404094
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Borislav Petkov writes:

> Hi,
> 
> On Wed, Jun 3, 2009 at 10:10 AM, Peter Feuerer <peter@piie.net> wrote:
>>>> Hm.. I think it should be clear that the fan is turned off, as soon as
>>>> the temperature is below the fanoff temperature. In my opinion printing this
>>>> message would be a case for a "verbose==2" verbose mode :)
>>>
>>> My reasoning was that because this is called from sysfs and the user
>>> sees nothing happening even if he'd turned off the fan by calling
>>> .set_cur_state that it might be useful to tell him why.
>>
>> But the user isn't allowed to change the fan state from userspace anymore.
> 
> Actually, Pavel wanted to have that functionality...

So you think it makes sense to allow it, too? For me it doesn't really 
matter whether user is allowed to change the fan or not. I think controlling 
the fan belongs into kernel, but if the user wants to have his own userspace 
tool I'm fine with this too. So I'll enable userspace control of the fan 
again, ok?

>> If you try to change the fan state from userspace you'll get the "changing
>> fan state is not allowed" message.
> 
> By the way, the system log is being polluted with that message after a
> suspend/resume cycle:
> 
> [99027.020952] acerhdf: failed reading fan state, disabling kernelmode.
> [99027.520172] ACPI: EC: missing confirmations, switch off interrupt mode.
> [99047.672142] acerhdf: changing fan state is not allowed
> [99057.696151] acerhdf: changing fan state is not allowed
> [99067.720125] acerhdf: changing fan state is not allowed
> [99077.744164] acerhdf: changing fan state is not allowed
> [99087.796127] acerhdf: changing fan state is not allowed
> [99097.820147] acerhdf: changing fan state is not allowed
> [99107.844136] acerhdf: changing fan state is not allowed
> [99117.908153] acerhdf: changing fan state is not allowed
> [99127.932155] acerhdf: changing fan state is not allowed
> [99137.123893] [drm:i915_get_vblank_counter] *ERROR* trying to get
> vblank count for disabled pipe 0
> [99137.956075] acerhdf: changing fan state is not allowed
> [99147.980158] acerhdf: changing fan state is not allowed
> [99158.004180] acerhdf: changing fan state is not allowed
> [99168.028148] acerhdf: changing fan state is not allowed
> [99170.207885] [drm:i915_get_vblank_counter] *ERROR* trying to get
> vblank count for disabled pipe 0
> [99178.052149] acerhdf: changing fan state is not allowed
> [99188.076149] acerhdf: changing fan state is not allowed
> [99198.100148] acerhdf: changing fan state is not allowed
> [99208.124150] acerhdf: changing fan state is not allowed
> [99210.558715] acerhdf: kernelmode ON
> [99210.581161] acerhdf: changing fan state is not allowed
> 
> because the suspend/resume cycle is causing the EC error message
> above. In that case, you shouldn't probably switch off kernel mode but
> unregister the driver completely until the EC error is fixed (if ever)... Hmm...

There's a bug in the algorithm which disables the kernelmode in case of 
unexpected register value. → It doesn't stop polling.

And I will re-add suspend / resume code to get rid of the resume problem.

Thanks!

best regards,
--peter
