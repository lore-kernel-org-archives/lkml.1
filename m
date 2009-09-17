Return-Path: <linux-kernel-owner+w=401wt.eu-S1759858AbZIQDPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759858AbZIQDPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 23:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759711AbZIQDPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 23:15:50 -0400
Received: from mail-qy0-f200.google.com ([209.85.221.200]:37003 "EHLO
	mail-qy0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758307AbZIQDPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 23:15:49 -0400
X-Greylist: delayed 395 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Sep 2009 23:15:49 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gXwLNStXT7JM/Sh91REA2vfICypS6FGKqLD9FH4vqVHlpsB1G6zjXb9PK1A/QY7VN2
         1IUvqxQ80n5wOwqwSHLeZ17/q3yPRpRIeqTkeJbQ2d1NRZc9ddPI/y5gjjrMzSM1c58A
         xRCUXjtV30nMqHr2h8DKWmruR4+teKihjhAD0=
MIME-Version: 1.0
In-Reply-To: <830a8fa70909161930r518a9644ja954ced2ae5814b4@mail.gmail.com>
References: <830a8fa70909161930r518a9644ja954ced2ae5814b4@mail.gmail.com>
Date: Thu, 17 Sep 2009 11:15:53 +0800
Message-ID: <2375c9f90909162015h39aeee14s99d3173d0a9baf7c@mail.gmail.com>
Subject: Re: [patch] Makefile: can't build modules outside the kernel tree if 
	it was built using O=
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Caveh Jalali <ecaveh@gmail.com>
Cc: sam@ravnborg.org, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n8H3G416011130

On Thu, Sep 17, 2009 at 10:30 AM, Caveh Jalali <ecaveh@gmail.com> wrote:> in 2.6.31, it is no longer possible to build kernel modules for some platforms> (the ones that need include2) outside the kernel src tree if the> src tree was built using O= to specify an alternate directory for the> build output.>> i think this broke with the following commit:>> commit b8b572e1015f81b4e748417be2629dfe51ab99f9> Author: Stephen Rothwell <sfr@canb.auug.org.au>> Date:   Fri Aug 1 15:20:30 2008 +1000

Only after 2.6.31? This commit was on 2008 Aug 1...
>>    powerpc: Move include files to arch/powerpc/include/asm>>> when the platform specific include directories were shuffled around> without updating the> top level Makefile.  however, i think this FAIL is generic, and not> limited to powerpc.> here's a patch to the top level Makefile to teach it about the shuffled files:>

You forgot your SOB line.
Anyway, it looks fine.
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
>> --- /local/caveh/linux/linux-2.6.31/Makefile    2009-09-09> 15:13:59.000000000 -0700> +++ Makefile    2009-09-16 12:23:05.000000000 -0700> @@ -958,9 +958,9 @@ ifneq ($(KBUILD_SRC),)>                 echo "  in the '$(srctree)' directory.";\>                 /bin/false; \>         fi;> -       $(Q)if [ ! -d include2 ]; then                                  \> -           mkdir -p include2;                                          \> -           ln -fsn $(srctree)/include/asm-$(SRCARCH) include2/asm;     \> +       $(Q)if [ ! -d include2 ]; then                                   \> +           mkdir -p include2;                                           \> +           ln -fsn $(srctree)/arch/$(SRCARCH)/include/asm include2/asm; \>         fi>  endif���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
