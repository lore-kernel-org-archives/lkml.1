Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbZH3Uqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbZH3Uqs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 16:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754093AbZH3Uqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 16:46:48 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:52113 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092AbZH3Uqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 16:46:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        b=EYlheyN2kQlFEmiKHVc9VAtPI25TpD7yzDx/xa9n/HKrWSaDD1d6vPXC/cOqCL0YFd
         7VLqXgnVmw63yohcByLDu91fk4OZbrHEMu4VhtEL5pbKedVSt3UIuAqZKh8/vbD3IJbz
         jbGWPyH8S4HYxl97U1FbiadEdUwX9vmgAlVAc=
Date: Sun, 30 Aug 2009 22:46:46 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, kjwinchester@gmail.com,
       tglx@linutronix.de, borislav.petkov@amd.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH 2/3] x86, msr: rewrite AMD rd/wrmsr variants
Message-ID: <20090830204646.GD22234@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	"H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com,
	linux-kernel@vger.kernel.org, kjwinchester@gmail.com,
	tglx@linutronix.de, borislav.petkov@amd.com,
	linux-tip-commits@vger.kernel.org
References: <1251633031-2244-1-git-send-email-petkovbb@gmail.com>
 <1251633031-2244-2-git-send-email-petkovbb@gmail.com>
 <4A9ADB24.6000100@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A9ADB24.6000100@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 30, 2009 at 01:03:48PM -0700, H. Peter Anvin wrote:
> On 08/30/2009 04:50 AM, Borislav Petkov wrote:
> > +#define memset(d,c,l) __builtin_memset(d,c,l)
> 
> Uh, *NO*.
> 
> #include <linux/string.h> instead.

With string.h I seem to be getting some symbols visibility conflict at
link time:

arch/x86/boot/compressed/misc.c:134: error: conflicting types for ‘memset’
/home/boris/kernel/linux-2.6/arch/x86/include/asm/msr.h:178: error: previous implicit declaration of ‘memset’ was here
make[2]: *** [arch/x86/boot/compressed/misc.o] Error 1
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [arch/x86/boot/compressed/vmlinux] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [bzImage] Error 2
make: *** Waiting for unfinished jobs....

Will look more deeply into it tomorrow.

-- 
Regards/Gruss,
    Boris.
