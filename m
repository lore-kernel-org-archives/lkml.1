Return-Path: <linux-kernel-owner+w=401wt.eu-S1754877AbZKUPCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbZKUPCN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 10:02:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754639AbZKUPCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 10:02:13 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:32917 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374AbZKUPCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 10:02:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=DED9cNCnaCLsn1782tGJJLgtMtUY+LcNCXIQv2Yfy/rGAaVxezh+Wl2Z3HEjKcwggR
         OYjN25vBqP4YRFGsD8ffxJxtoVMYzW9ingnknDsCsWyk/IyGYEYnjbfg8U5XQNwU2QSX
         JKdfL7qFXI5P/NEZ87AM5bHXtDABZ6lD4wX5k=
Message-ID: <4B0800F6.1010709@gmail.com>
Date: Sat, 21 Nov 2009 16:02:14 +0100
From: Carmelo Amoroso <carmelo73@gmail.com>
Reply-To: carmelo73@gmail.com
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Carmelo AMOROSO <carmelo.amoroso@st.com>
Subject: Re: [PATCH] modules: Allow to use depmod from a non default install
References: <4AF73BA4.3000501@gmail.com> <20091109030622.GB2399@hack>
In-Reply-To: <20091109030622.GB2399@hack>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Américo Wang wrote:
> On Sun, Nov 08, 2009 at 10:44:04PM +0100, Carmelo Amoroso wrote:
>> This patch allow to specify the directory where to find the
>> depmod tool other than being forced to use the module-init-tools
>> installed on the host. The reason for this is explained below.
>> When doing cross-compilation, it not guaranteed that the
>> module-init-tools installed on the host (and used during kernel build)
>> are exactly the same and compatible with those used on the target at runtime.
>> For example, recent changes in how depmod writes modules.dep using
>> root-less path, make older modprobe unusable on the target.
>> User in ths case could install in a different path the module-init-tools
>> compatible with the version used on the target and specify the path on the
>> command line.
>>
>> Signed-off-by: Carmelo Amoroso <carmelo.amoroso@st.com>
> 
> Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
> 
> 

Hi,
any plan to get it included ?

cheers,
carmelo

>> ---
>> Makefile |    3 ++-
>> 1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/Makefile b/Makefile
>> index b4c04f7..f5286c4 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -316,7 +316,8 @@ OBJDUMP             = $(CROSS_COMPILE)objdump
>> AWK            = awk
>> GENKSYMS       = scripts/genksyms/genksyms
>> INSTALLKERNEL  := installkernel
>> -DEPMOD         = /sbin/depmod
>> +DEPMOD_PATH    ?= /sbin
>> +DEPMOD         = $(DEPMOD_PATH)/depmod
>> KALLSYMS       = scripts/kallsyms
>> PERL           = perl
>> CHECK          = sparse
>> -- 1.6.3.3
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> 

