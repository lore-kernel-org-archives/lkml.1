Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559AbZBJPZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbZBJPZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 10:25:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbZBJPZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 10:25:11 -0500
Received: from el-out-1112.google.com ([209.85.162.180]:34639 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbZBJPZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 10:25:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UTkQz00Av98FN0q8iY6dkPpam79v1GveSm5zgdcCJOI2DzK3Fhorh8AkVVB/v1P+H6
         rW1ub4rFT18mqCq+GzQm3d/tDeMC0igCXz5c7SRnEGa3twIq+tkkjLydMYMen49iHVen
         zq0lyw72mIBwaNwQawHyxu+XudljEVnsBjl4M=
MIME-Version: 1.0
In-Reply-To: <1234186798-16820-12-git-send-email-tj@kernel.org>
References: <1234186798-16820-1-git-send-email-tj@kernel.org>
	 <1234186798-16820-12-git-send-email-tj@kernel.org>
Date: Tue, 10 Feb 2009 10:25:06 -0500
Message-ID: <73c1f2160902100725w2503d693v5a3d1ae93ada75de@mail.gmail.com>
Subject: Re: [PATCH 11/11] x86: implement x86_32 stack protector
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: hpa@zytor.com, jeremy@goop.org, tglx@linutronix.de, mingo@elte.hu,
       linux-kernel@vger.kernel.org, x86@kernel.org, rusty@rustcorp.com.au
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 9, 2009 at 8:39 AM, Tejun Heo <tj@kernel.org> wrote:
> Impact: stack protector for x86_32
>
> Implement stack protector for x86_32.  GDT entry 28 is used for it.
> It's set to point to stack_canary-20 and have the length of 24 bytes.
> CONFIG_CC_STACKPROTECTOR turns off CONFIG_X86_32_LAZY_GS and sets %gs
> to the stack canary segment on entry.  As %gs is otherwise unused by
> the kernel, the canary can be anywhere.  It's defined as a percpu
> variable.
>
> x86_32 exception handlers take register frame on stack directly as
> struct pt_regs.  With -fstack-protector turned on, gcc copies the
> whole structure after the stack canary and (of course) doesn't copy
> back on return thus losing all changed.  For now, -fno-stack-protector
> is added to all files which contain those functions.  We definitely
> need something better.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>

Am I missing something, or does this patch not actually implement the
offset of the start of the segment by 20 from the stack_canary
variable?

--
Brian Gerst
