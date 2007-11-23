Return-Path: <linux-kernel-owner+w=401wt.eu-S1756225AbXKWKyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225AbXKWKyz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 05:54:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753967AbXKWKyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 05:54:47 -0500
Received: from el-out-1112.google.com ([209.85.162.183]:59866 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537AbXKWKyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 05:54:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Q8HiEqvZNiFjK9ddV1CZ/Wic8I8WVS1i+9fQVZ2Lcu0xn224/8PlI3RvtGV1ySvpaaa9toYKdeEQbLbdyBekH06klTPAheHa4A07ogkKBE0VOw3NOP7IgybGYWmCcq+E3C2vdHcxNROPHmDXtRjGqwYiyhnuX4U1+MjD9OJuW2Q=
Message-ID: <4746B171.1070001@gmail.com>
Date: Fri, 23 Nov 2007 11:54:41 +0100
From: Jiri Olsa <olsajiri@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Karol Swietlicki <magotari@gmail.com>
CC: Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net,
       Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [uml-devel] uml doesn't work on 2.6.24-rc2
References: <E1Is5FL-00078H-00@dorka.pomaz.szeredi.hu>	<20071114011002.GA11477@c2.user-mode-linux.org>	<E1IsFbA-0007y2-00@dorka.pomaz.szeredi.hu>	<20071114142247.GA5848@c2.user-mode-linux.org>	<E1IsK83-0008CJ-00@dorka.pomaz.szeredi.hu>	<20071114173639.GA7899@c2.user-mode-linux.org>	<E1IsPo5-0008RU-00@dorka.pomaz.szeredi.hu>	<20071116170630.GA9299@c2.user-mode-linux.org>	<E1IvGTn-0007cC-7q@dorka.pomaz.szeredi.hu>	<20071122235141.GA7876@c2.user-mode-linux.org> <ea9232d10711230101j24e4bd4btce65e62b9fcc8f8b@mail.gmail.com>
In-Reply-To: <ea9232d10711230101j24e4bd4btce65e62b9fcc8f8b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

after applying following changes, the mainline is working for me.

Jiri Olsa


diff --git a/arch/um/Kconfig.i386 b/arch/um/Kconfig.i386
index e0ac74e..234fcb4 100644
--- a/arch/um/Kconfig.i386
+++ b/arch/um/Kconfig.i386
@@ -8,6 +8,13 @@ config UML_X86
 	bool
 	default y
 
+config X86_32
+	bool
+	default y
+
+config RWSEM_XCHGADD_ALGORITHM
+	def_bool y
+
 config 64BIT
 	bool
 	default n
diff --git a/arch/um/Makefile b/arch/um/Makefile
index 31999bc..ba6813a 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -168,7 +168,7 @@ ifneq ($(KBUILD_SRC),)
 	$(Q)mkdir -p $(objtree)/include/asm-um
 	$(Q)ln -fsn $(srctree)/include/asm-$(HEADER_ARCH) include/asm-um/arch
 else
-	$(Q)cd $(TOPDIR)/include/asm-um && ln -fsn ../asm-$(SUBARCH) arch
+	$(Q)cd $(TOPDIR)/include/asm-um && ln -fsn ../asm-$(HEADER_ARCH) arch
 endif
 
 $(objtree)/$(ARCH_DIR)/include:

Karol Swietlicki wrote:
> On 23/11/2007, Jeff Dike <jdike@addtoit.com> wrote:
>> On Thu, Nov 22, 2007 at 07:08:47PM +0100, Miklos Szeredi wrote:
>>> Thanks.  My other problem is (probably you are aware) that recent -mm
>>> kernels don't compile for UML.
>> The patch below fixes the build for rc3-mm1 for me.
>>
>>                                 Jeff
> 
> There must be something more to it. I got a clean -mm and it still
> does not build after applying the patch. It does have less problems,
> but it still won't build. I tried to get it to compile for half an
> hour, but considering the amount of sleep I got (and my experience),
> there is no surprise that I failed miserably. After fixing the
> complaint about a structure not having a 'x86' member, it died in the
> linker complaining about stuff relating to rwsem.h.
> 
> Karol Swietlicki
> 
> -------------------------------------------------------------------------
> This SF.net email is sponsored by: Microsoft
> Defy all challenges. Microsoft(R) Visual Studio 2005.
> http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
> _______________________________________________
> User-mode-linux-devel mailing list
> User-mode-linux-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/user-mode-linux-devel
> 

