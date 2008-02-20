Return-Path: <linux-kernel-owner+w=401wt.eu-S1762778AbYBTOIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762778AbYBTOIt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 09:08:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754411AbYBTOIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 09:08:41 -0500
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:40703
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042AbYBTOIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 09:08:40 -0500
Message-ID: <47BC3407.20307@qumranet.com>
Date: Wed, 20 Feb 2008 16:07:03 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>,
       kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] build #365 issue for v2.6.25-rc2-342-g5d9c4a7 in
 ./arch/x86/kvm/kvm.ko
References: <200802201411.18026.toralf.foerster@gmx.de> <47BC3121.8070902@qumranet.com>
In-Reply-To: <47BC3121.8070902@qumranet.com>
Content-Type: multipart/mixed;
 boundary="------------060305080804060306040509"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060305080804060306040509
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Avi Kivity wrote:
> Toralf Förster wrote:
>> Hello,
>>
>> the build with the attached .config failed, make ends with:
>> ...
>>   HOSTCC  arch/x86/boot/tools/build
>>   BUILD   arch/x86/boot/bzImage
>> Root device is (3, 8)
>> Setup is 12280 bytes (padded to 12288 bytes).
>> System is 2192 kB
>> Kernel: arch/x86/boot/bzImage is ready  (#1)
>>   Building modules, stage 2.
>>   MODPOST 211 modules
>> ERROR: "smp_ops" [arch/x86/kvm/kvm.ko] undefined!
>> make[1]: *** [__modpost] Error 1
>> make: *** [modules] Error 2
>>
>>
>> The build was made with :
>> $> make mrproper && make rndconfig && <tweak config file> && make 
>> oldconfig && make
>>
>> Here's the config:
>>   
>
> Looks like KVM conflicts with CONFIG_VOYAGER...
>

Attached patch should fix.

Subject: x86: disable KVM on Voyager

Most classic Pentiums don't have hardware virtualization
extension, and building kvm with voyager generates
spurious failures.

Signed-off-by: Avi Kivity <avi@qumranet.com>

-- 
Any sufficiently difficult bug is indistinguishable from a feature.


--------------060305080804060306040509
Content-Type: text/x-patch;
 name="kvm-vs-voyager.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kvm-vs-voyager.patch"

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cc2bc37..e27962c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -21,7 +21,7 @@ config X86
 	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
-	select HAVE_KVM
+	select HAVE_KVM if ((X86_32 && !X86_VOYAGER) || X86_64)
 
 
 config GENERIC_LOCKBREAK

--------------060305080804060306040509--
