Return-Path: <linux-kernel-owner+w=401wt.eu-S1754739AbZC2Vu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbZC2Vu5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 17:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753576AbZC2Vuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 17:50:44 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:55673 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737AbZC2Vum convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 17:50:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fO0XyFlYM/VMP5Qzi8/SlSF94fW4tISdH/oJ/dGRII0URIURV73KCeByIYf3D1i33q
         a2W+CumsyZWHGvgqGCCvdvpPVt9/IrBXwvSpMRFW02nNCINk1EjD6N1RhqpKfmJiX933
         0l3Q+DjPaCnlkzcqy4ltWrC8GSHTRdus68zf8=
MIME-Version: 1.0
In-Reply-To: <49CFE7E0.80500@zytor.com>
References: <cover.1238361501.git.ice799@gmail.com>
	 <76c37743d20e5737eadc747cbdddbc2beb11f074.1238361501.git.ice799@gmail.com>
	 <49CFE7E0.80500@zytor.com>
Date: Sun, 29 Mar 2009 14:50:39 -0700
Message-ID: <3605561d0903291450v516a7e9csaff4309c0cacb121@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86: Add getter/setter static inlines for x86 
	descriptors
From: Joe Damato <ice799@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-x86_64@vger.kernel.org, w@1wt.eu, mingo@elte.hu, jeremy@goop.org,
       linux-newbie@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 29, 2009 at 2:28 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Joe Damato wrote:
>> Static inline getters/setters have been provided to encourage consumers not to touch the internals of 32bit x86 descriptors directly.
>>
>> Signed-off-by: Joe Damato <ice799@gmail.com>
>
> Okay, what is the motivation for this?
>
> This is a serious question.  The x86 descriptors are so complex that
> it's not clear to me that this restriction makes the code any more
> clear.  Especially not with things like:
>
> -               cpu->arch.gdt[i].b |= 0x00000100;
> +               desc_set_hi(tmp,  desc_get_hi(tmp) | 0x00000100);
>
> This isn't an improvement.  If you're doing to so something like this,
> you need to actually implement the *intent* here.

Hi -

In my first patch set several months ago I replaced the structure
desc_struct with bit fields that exposed the fields for IDT/LDT/TSS
entries. This patch set was rejected for several reasons, one of which
was that Linux is trying to move away from bit fields. I also received
other comments such as "take a smaller bite", etc.

So instead of the bit fields, I implemented static inline
getters/setters. I thought that this small change would be a good
first step to re-test the waters of submitting patches to the kernel
before I started to clean out more pieces of the x86 architecture
specific code.

I agree that this isn't very clear, but from comments I received on my
first set, I assumed that this was closer to what people wanted to see
in the kernel. I am happy to iterate and submit something better, but
I am clearly misunderstanding what people would like to see.

Any suggestions on how this first-timer can help are greatly appreciated.

Joe
