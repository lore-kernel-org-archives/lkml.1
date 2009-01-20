Return-Path: <linux-kernel-owner+w=401wt.eu-S1760882AbZATBpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760882AbZATBpV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 20:45:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755204AbZATBpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 20:45:06 -0500
Received: from main.gmane.org ([80.91.229.2]:33189 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755186AbZATBpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 20:45:04 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Peter Annema <jag@tty.nl>
Subject: Re: [bisected] 2.6.29-rc1 Firefox crashing on page load
Date: Tue, 20 Jan 2009 01:39:39 +0000 (UTC)
Message-ID: <loom.20090120T012630-735@post.gmane.org>
References: <4970F46F.4060803@gawab.com> <49714266.6020401@gawab.com> <49715039.2090406@gmail.com> <49719B53.8050300@gawab.com> <alpine.LNX.2.00.0901172115170.28288@swampdragon.chaosbits.net> <4972489B.30500@gawab.com> <497260FE.4010102@gmail.com> <4972723B.4000201@gawab.com> <49727BDE.9070509@gmail.com> <49751BA0.1040004@gawab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 70.79.225.63 (Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.4; en-US; rv:1.9.1b3pre) Gecko/20081229 SeaMonkey/2.0a3pre)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Madru <jdm64 <at> gawab.com> writes:
> Ok, finally bisected the bug, but the commit isn't related to networking!
> I did: git revert 4217458dafaa57d8e26a46f5d05ab8c53cf64191
> on current git and that fixed the bug.

...

>  #ifdef CONFIG_X86_32
> -asmlinkage int sys_rt_sigreturn(unsigned long __unused)
> +asmlinkage int sys_rt_sigreturn(struct pt_regs regs)
>  {
> -       struct pt_regs *regs = (struct pt_regs *)&__unused;
> -
> -       return do_rt_sigreturn(regs);
> +       return do_rt_sigreturn(&regs);
>  }

Is sizeof(struct pt_regs) different from sizeof(unsigned long)? If so, is some
code somewhere messing with the stack and not expecting a struct pt_regs to have
been put on it?



