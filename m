Return-Path: <linux-kernel-owner+w=401wt.eu-S1752033AbXCEAPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033AbXCEAPr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 19:15:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752560AbXCEAPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 19:15:47 -0500
Received: from wr-out-0506.google.com ([64.233.184.235]:5304 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbXCEAPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 19:15:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Dq3nicpi0Y2y4GODR/BKJ4gO+5gHz5dz0QNmsZURmwMRlQ5gktV8Uo+izLNo33SHr81zJw+CabQWenwLSUVGeTeNSE7yfNCekOysLYe82NkZB8dgBhwZRI/NnvCQ/HCz8zv5OnltbWS8/NwqRQLQVFaNe+gtBpun+hWBv1m6UN8=
Message-ID: <3d8471ca0703041615s790fc1f8vbb4a87c5f9d88148@mail.gmail.com>
Date: Mon, 5 Mar 2007 01:15:42 +0100
From: "Guillaume Chazarain" <guichaz@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [1/3] Bugfix: Don't use the TSC in sched_clock if unstable
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <200703050028.25209.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3d8471ca0703031341l1768fe7rccf40712e452ea09@mail.gmail.com>
	 <200703041825.39361.ak@suse.de>
	 <3d8471ca0703041033v689b51dfuba0b09fc979d7698@mail.gmail.com>
	 <200703050028.25209.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/3/5, Andi Kleen <ak@suse.de>:

> An older one (Banias) I assume? (please post /proc/cpuinfo)

No, a Dothan.
I attached cpuinfo in the previous mail, but here is it again:

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 13
model name	: Intel(R) Pentium(R) M processor 2.00GHz
stepping	: 8
cpu MHz		: 798.000
cache size	: 2048 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat clflush dts acpi mmx fxsr sse sse2 ss tm pbe est tm2
bogomips	: 1596.62
clflush size	: 64


> Can you run with this debug patch and send me the output? If it stops
> logging before you see the problem increase MAX in the patch.

I set MAX to 5000 just to be sure, here is the output from the boot up.
I isolated a block where the audio definitely skipped.

cyc2ns_scale 0 -> 201
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 29db0f2f5b(503)->10bc5b002a(201)
cyc2ns_scale 201 -> 503
sched_clock backward 2b100bdb58(503)->2b100bc6e6(503)
cyc2ns_scale 503 -> 201
sched_clock backward 2bdac2b6ee(503)->1188f4a0e3(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 2c210a4514(503)->11a50e7141(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 2c9192040b(503)->11d20cc96f(201)
cyc2ns_scale 201 -> 301
cyc2ns_scale 301 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 2cb1e4ef60(503)->11def97358(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 2cfcf233c1(503)->11fcfbc79d(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 2d711fc0c8(503)->122b6fc4b4(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 2d8d168a64(503)->12369e27b4(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 2de96c96fe(503)->125b89b04b(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 2eb180620a(503)->12ab89a3e1(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 2ee8e2480c(503)->12c1ae94b5(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 2f04d8ff6e(503)->12ccdcf78d(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 2fde4a968d(503)->1323ce80fa(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 30b7b598be(503)->137abd6f0f(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 3124abac15(503)->13a64ebdb2(201)
cyc2ns_scale 201 -> 3c2
cyc2ns_scale 3c2 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 317dd24c00(503)->13c9f4365a(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 32b540e8cf(503)->14467a6dec(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 32f62bf99d(503)->14606f76c5(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 3332428cea(503)->14787617fe(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 33424da0d9(503)->147ee04906(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 33538a0f92(503)->1485c49305(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 335a01a27d(503)->14885a8e0a(201)
cyc2ns_scale 201 -> 301
cyc2ns_scale 301 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 33705f7f93(503)->14914bfcbe(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 33963e4097(503)->14a0706431(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 33a1848c5d(503)->14a4f276dc(201)
cyc2ns_scale 201 -> 301
cyc2ns_scale 301 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 33abcc7f9b(503)->14a90ed546(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 33b24e19de(503)->14aba8ce9e(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 33b9685fa0(503)->14ae7fd6d6(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 33db3c5d92(503)->14bc067caf(201)
cyc2ns_scale 201 -> 3c2
cyc2ns_scale 3c2 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 3405e6e65b(503)->14cd15c484(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 3443359bd5(503)->14e5993ef0(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 3463f0a992(503)->14f2af8d59(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 3472ca8ea0(503)->14f89fb4e4(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 34a00a63b3(503)->150ab7739c(201)
cyc2ns_scale 201 -> 3c2
cyc2ns_scale 3c2 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 34e28c3aa2(503)->15254f26a4(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 34f62acf20(503)->152d2761eb(201)
cyc2ns_scale 201 -> 301
cyc2ns_scale 301 -> 201
sched_clock backward 1fc32dbff1(301)->15304f9a8e(201)
cyc2ns_scale 201 -> 281
cyc2ns_scale 281 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 35124edd3f(503)->153867e12e(201)
cyc2ns_scale 201 -> 3c2
cyc2ns_scale 3c2 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 35208fca6d(503)->153e1ae071(201)
cyc2ns_scale 201 -> 281
cyc2ns_scale 281 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 352e3894e2(503)->15439109cd(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 353552d998(503)->1546680de6(201)
cyc2ns_scale 201 -> 301
cyc2ns_scale 301 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 3549241806(503)->154e549102(201)
cyc2ns_scale 201 -> 301
cyc2ns_scale 301 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 3554b75951(503)->1552f56ea6(201)
cyc2ns_scale 201 -> 503
sched_clock backward 3562a3cafc(503)->3562a38d33(503)
cyc2ns_scale 503 -> 201
sched_clock backward 356bba6272(503)->155c28ea79(201)
sched_clock backward 155c9831b2(201)->155c98220c(201)
cyc2ns_scale 201 -> 281
cyc2ns_scale 281 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 3578f61e91(503)->1561738015(201)
cyc2ns_scale 201 -> 301
cyc2ns_scale 301 -> 503
sched_clock backward 3592ffd12e(503)->3592ffbdfc(503)
cyc2ns_scale 503 -> 201
sched_clock backward 3697942de5(503)->15d40d942f(201)
cyc2ns_scale 201 -> 301
cyc2ns_scale 301 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 36f2c9b2d3(503)->15f885bee3(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 37172abeac(503)->160711837f(201)
cyc2ns_scale 201 -> 301
cyc2ns_scale 301 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 37246609e6(503)->160c5be75c(201)
cyc2ns_scale 201 -> 3c2
cyc2ns_scale 3c2 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 3731db76d5(503)->1611bd8955(201)
cyc2ns_scale 201 -> 281
cyc2ns_scale 281 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 37a2eacc95(503)->163ef25ba5(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 37b1c4ad2b(503)->1644e28392(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 37cd14b870(503)->164fce3e43(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 37d98c5b09(503)->1654ca6642(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 37e7cda7b3(503)->165a7d8cf2(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 380a52e3e4(503)->16684b107a(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 381b8f437f(503)->166f2f53e3(201)
cyc2ns_scale 201 -> 3c2
cyc2ns_scale 3c2 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 3826a2a415(503)->16739d089e(201)
cyc2ns_scale 201 -> 3c2
cyc2ns_scale 3c2 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 385016c175(503)->1684303ac4(201)
cyc2ns_scale 201 -> 281
cyc2ns_scale 281 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 38766eac1a(503)->1693851058(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 3882e659ee(503)->1698813d9c(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 388ec5751b(503)->169d40686d(201)
cyc2ns_scale 201 -> 281
cyc2ns_scale 281 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 389ed04a2d(503)->16a3aa7fc6(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 3901380f92(503)->16cb034853(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 3911432c80(503)->16d16d7d2f(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 3929a67a6a(503)->16db2dd573(201)
cyc2ns_scale 201 -> 301
cyc2ns_scale 301 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 39394b9fc5(503)->16e16f4496(201)
cyc2ns_scale 201 -> 3c2
cyc2ns_scale 3c2 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 39653fa3b2(503)->16f30251cd(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 39736db010(503)->16f8adc6ca(201)
cyc2ns_scale 201 -> 301
cyc2ns_scale 301 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 3993955f50(503)->17058929c8(201)
cyc2ns_scale 201 -> 301
cyc2ns_scale 301 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 39b2e4baac(503)->17120e0fbd(201)
cyc2ns_scale 201 -> 3c2
cyc2ns_scale 3c2 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 39cbf682f5(503)->171c142b78(201)
cyc2ns_scale 201 -> 281
cyc2ns_scale 281 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 39e625fbd1(503)->17268c8471(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 3a0e79e3f9(503)->1736ac788c(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 3a9fdc2825(503)->1770cdf93e(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 3ae4f32d72(503)->178c6e064b(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 3af760f3d6(503)->1793cc66a4(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 3b49950886(503)->17b4aabfde(201)
cyc2ns_scale 201 -> 281
cyc2ns_scale 281 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 3b6e7c9d21(503)->17c36c4fa7(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 3b8a747b02(503)->17ce9b2489(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 3b95b92024(503)->17d31c8d5f(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 3bbc6a923d(503)->17e2952eda(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 3c021aaff4(503)->17fe7272e1(201)
cyc2ns_scale 201 -> 503
sched_clock backward 3c3e9c9137(503)->3c3e9c7b97(503)
cyc2ns_scale 503 -> 201
sched_clock backward 3c7183e262(503)->182afe7b40(201)
cyc2ns_scale 201 -> 281
cyc2ns_scale 281 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 3c7a67bd71(503)->182e8c78c3(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 3c80e963a4(503)->183126772d(201)
cyc2ns_scale 201 -> 301
cyc2ns_scale 301 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 3c8a98b913(503)->183505d038(201)
cyc2ns_scale 201 -> 281
cyc2ns_scale 281 -> 503
sched_clock backward 3d18766bb6(503)->3d187657b3(503)
cyc2ns_scale 503 -> 201
sched_clock backward 3d7ac0373b(503)->18950c0729(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 3da040a686(503)->18a40ab63d(201)
cyc2ns_scale 201 -> 281
cyc2ns_scale 281 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 3e26e824fd(503)->18d9e1ee40(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 3e4ecaea9b(503)->18e9d4a672(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 3e9180074a(503)->190480d530(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 3eb831829f(503)->1913f97a39(201)
cyc2ns_scale 201 -> 301
cyc2ns_scale 301 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 3edde4c677(503)->19230c7bb2(201)
cyc2ns_scale 201 -> 281
cyc2ns_scale 281 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 3f03fd669e(503)->193248031b(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 3f297d83a7(503)->1941468f0b(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 3fb025c6c2(503)->19771e179f(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 3fd50d7396(503)->1985dfafac(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 400bd6f9da(503)->199bc7b5a2(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 403caa0e8b(503)->19af4d6554(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 40635b9303(503)->19bec60e9a(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 40795cf075(503)->19c79286b6(201)
cyc2ns_scale 201 -> 301
cyc2ns_scale 301 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 4090291533(503)->19d0b013fa(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 40d40f3d79(503)->19ebd63b8a(201)
cyc2ns_scale 201 -> 301
cyc2ns_scale 301 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 40f9c20b7b(503)->19fae90b08(201)
cyc2ns_scale 201 -> 3c2
cyc2ns_scale 3c2 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 411b7c552c(503)->1a08656b34(201)
cyc2ns_scale 201 -> 301
cyc2ns_scale 301 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 4167ed2282(503)->1a26f5e237(201)
cyc2ns_scale 201 -> 281
cyc2ns_scale 281 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 42b3de364e(503)->1aabaf7889(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 42d95ead15(503)->1abaae298a(201)
cyc2ns_scale 201 -> 503
sched_clock backward 42ebbf0a0b(503)->42ebbf00b3(503)
cyc2ns_scale 503 -> 201
sched_clock backward 43161dfa0e(503)->1ad2f84124(201)
cyc2ns_scale 201 -> 301
cyc2ns_scale 301 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 4343906c77(503)->1ae524388f(201)
cyc2ns_scale 201 -> 503
sched_clock backward 439c61cd6d(503)->439c61accb(503)
cyc2ns_scale 503 -> 201
sched_clock backward 43a5dc3437(503)->1b0c71cef0(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 43cb5c8fd4(503)->1b1b707400(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 43f044a493(503)->1b2a323791(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 443b51db96(503)->1b48348149(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 44bdcdd690(503)->1b7c60e3fa(201)
cyc2ns_scale 201 -> 3c2
cyc2ns_scale 3c2 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 4548fd8340(503)->1bb4080150(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 45b13fa930(503)->1bddb7e896(201)
cyc2ns_scale 201 -> 3c2
cyc2ns_scale 3c2 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 45d42a845f(503)->1bebae0d15(201)
cyc2ns_scale 201 -> 301
cyc2ns_scale 301 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 45fb0ed6e7(503)->1bfb3b082a(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 46c2160e73(503)->1c4acf935b(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 46d6e5ec44(503)->1c5321e4c4(201)
cyc2ns_scale 201 -> 281
cyc2ns_scale 281 -> 503
sched_clock backward 474e12b912(503)->474e12a6a7(503)
cyc2ns_scale 503 -> 201
sched_clock backward 476b432a5b(503)->1c8e7477cf(201)
cyc2ns_scale 201 -> 3c2
cyc2ns_scale 3c2 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 4781a9dcfb(503)->1c97697422(201)
cyc2ns_scale 201 -> 281
cyc2ns_scale 281 -> 201
sched_clock backward 23bdd77e9c(281)->1c9aba779e(201)
cyc2ns_scale 201 -> 301
cyc2ns_scale 301 -> 3c2
cyc2ns_scale 3c2 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 479871ccd4(503)->1ca0855119(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 47a1ee897c(503)->1ca450700f(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 47b45c115e(503)->1cabaeb5f6(201)
cyc2ns_scale 201 -> 281
cyc2ns_scale 281 -> 3c2
cyc2ns_scale 3c2 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 48f2655e41(503)->1d2ad8f025(201)
cyc2ns_scale 201 -> 281
cyc2ns_scale 281 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 49174cf5de(503)->1d399a814d(201)
cyc2ns_scale 201 -> 503
sched_clock backward 493610d001(503)->493610bc7b(503)
cyc2ns_scale 503 -> 201
sched_clock backward 4a82d62751(503)->1dcaf61371(201)
cyc2ns_scale 201 -> 301
cyc2ns_scale 301 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 4aa757df45(503)->1dd98ee87d(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 4ab0d4b17f(503)->1ddd5a0e1b(201)
cyc2ns_scale 201 -> 301
cyc2ns_scale 301 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 4ae0a97a46(503)->1df07a0f0f(201)


The following block is where the audio skipped.


cyc2ns_scale 201 -> 281
cyc2ns_scale 281 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 4aed20c237(503)->1df5761279(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 4af56c28e6(503)->1df8c71bac(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 4c37d447f0(503)->1e79b0af32(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 4c575eab43(503)->1e864d2e46(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 4eb1eafb88(503)->1f773a1025(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 5094a966d9(503)->20383fc3f2(201)
cyc2ns_scale 201 -> 301
cyc2ns_scale 301 -> 503
sched_clock backward 50a2fdea09(503)->50a2fde2ca(503)
cyc2ns_scale 503 -> 201
sched_clock backward 50ac0e4ab5(503)->20419a63bf(201)
cyc2ns_scale 201 -> 503
sched_clock backward 51d84a25ff(503)->51d84a145c(503)
cyc2ns_scale 503 -> 201
sched_clock backward 51f3d42086(503)->20c4a93dc8(201)
cyc2ns_scale 201 -> 503




cyc2ns_scale 503 -> 201
sched_clock backward 527354c9f0(503)->20f7a46b0a(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 52d76a614a(503)->211fa90edc(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 52fceaba86(503)->212ea7b387(201)
cyc2ns_scale 201 -> 301
cyc2ns_scale 301 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 5315811206(503)->21387c75d6(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 545c1599a7(503)->21bb113d8d(201)
cyc2ns_scale 201 -> 301
cyc2ns_scale 301 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 54809755d9(503)->21c9aa13ad(201)
cyc2ns_scale 201 -> 3c2
cyc2ns_scale 3c2 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 5539b610b6(503)->2213aefc10(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 627292cecd(503)->275d19cc45(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 62ad8889fd(503)->2774acf0bf(201)
cyc2ns_scale 201 -> 301
cyc2ns_scale 301 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 62d0d90999(503)->2782cbba09(201)
cyc2ns_scale 201 -> 281
cyc2ns_scale 281 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 62f6f1c815(503)->2792074e08(201)
cyc2ns_scale 201 -> 301
cyc2ns_scale 301 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 6361c91d2b(503)->27bcbf9358(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 637e599bbf(503)->27c82b6e73(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 643545fa6c(503)->28114f7c28(201)
cyc2ns_scale 201 -> 3c2
cyc2ns_scale 3c2 -> 503
sched_clock backward 644b7dff6d(503)->644b7deb8b(503)
cyc2ns_scale 503 -> 201
sched_clock backward 65c9234ec6(503)->28b2cb1822(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 676fae746d(503)->295bbeb20a(201)
cyc2ns_scale 201 -> 503
sched_clock backward 68c4ec88dd(503)->68c4ec74ad(503)
sched_clock backward 69b273228b(503)->69b2731b67(503)
sched_clock backward 69d03f7b0e(503)->69d03f68a8(503)
sched_clock backward 6a7076aac2(503)->6a70769a73(503)
sched_clock backward 6ace0ac50e(503)->6ace0aa72a(503)
sched_clock backward 6b29e45147(503)->6b29e432ee(503)
cyc2ns_scale 503 -> 201
sched_clock backward 7206c826a8(503)->2d97c32f6e(201)
cyc2ns_scale 201 -> 503
cyc2ns_scale 503 -> 201
sched_clock backward 72a71120f0(503)->2dd7d9fa80(201)

To reproduce the problem, I waited for the ondemand governor
to set the CPU speed to 798 MHz, and then did a while : ; do : ; done
It does not always work though.

Thanks.

-- 
Guillaume
