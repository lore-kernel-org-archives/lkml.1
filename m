Return-Path: <linux-kernel-owner+w=401wt.eu-S1758236AbZABQNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236AbZABQNS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 11:13:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756401AbZABQNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 11:13:08 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:35890 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756148AbZABQNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 11:13:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=XurBdm9F0onfv02KF3eAPxJLIEe/k3Qul/LbpG4XbrU6njrDL+dWjxotHfNFHrxhuY
         XbBHU58I/2K4+kJGmgoz9w3IaoadhiIMX5K1UYtsQxFw7PyZZjHeTFyBF2ZA5LisEcEz
         +1fWF8th0t5l4eTZT/8rDeeA0UX0ggVZgLaUo=
Message-ID: <3f9a31f40901020813t136ad2ceif1092f312866a0ce@mail.gmail.com>
Date: Fri, 2 Jan 2009 21:43:03 +0530
From: "Jaswinder Singh Rajput" <jaswinderlinux@gmail.com>
To: Valdis.Kletnieks@vt.edu
Subject: Re: x86 (Linux Tiny): configure out support for some processors
Cc: "Ingo Molnar" <mingo@elte.hu>, "Bryan Donlan" <bdonlan@gmail.com>,
       "Ingo Brueckl" <ib@wupperonline.de>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <11444.1230910752@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <495d2974@wupperonline.de>
	 <3e8340490901012119i40971452q9f938702e58d7532@mail.gmail.com>
	 <3f9a31f40901012159l255b95a8he41a341f36ebc54e@mail.gmail.com>
	 <20090102093801.GD1975@elte.hu>
	 <3f9a31f40901020710h508bbfbch3d7ccd6f4898ea03@mail.gmail.com>
	 <11444.1230910752@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 2, 2009 at 9:09 PM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Fri, 02 Jan 2009 20:40:16 +0530, Jaswinder Singh Rajput said:
>
>> If I know what is my CPU there is no point for supporting all related
>> CPUs in my kernel.
>
> EMBEDDED is for a large assortment of things, all of which are of the form:
>
> General users won't want to change Y, but if I know I don't need Y, there is
> no point in supporting Y in the kernel.
>

On 64 bit AMD machine I was getting :
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls

By using the following patch I get rid of extra CPU support and also
reduces size of the kernel.

Let me know why should I choose EMBEDDED option ? I know I am not
using Embbeded machine and I do not need embbeded features on my
machine. If I am willing to go North why should I go South first ?

--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -411,7 +411,7 @@ config X86_DEBUGCTLMSR
        depends on !(MK6 || MWINCHIPC6 || MWINCHIP3D || MCYRIXIII ||
M586MMX || M586TSC || M586 || M486 || M386)

 menuconfig PROCESSOR_SELECT
-       bool "Supported processor vendors" if EMBEDDED
+       bool "Supported processor vendors"
        help
          This lets you choose what x86 vendor support code your kernel
          will include.
