Return-Path: <linux-kernel-owner+w=401wt.eu-S1754303AbYK0KPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303AbYK0KPg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 05:15:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbYK0KP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 05:15:28 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:57811 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752377AbYK0KP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 05:15:27 -0500
Message-Id: <1227780926.25079.1287038929@webmail.messagingengine.com>
X-Sasl-Enc: ugAr1Azd/qB1Iena2dO71UYVAmh075zhEhWbMit7hYXz 1227780926
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, "Cyrill Gorcunov" <gorcunov@gmail.com>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
Subject: Re: [PATCH 4/5] x86: ret_from_fork - add CFI proc annotation
In-Reply-To: <39e35cbc79237b162a0720dceaa52a72c7eb1690.1227725632.git.gorcunov@gmail.com>
Date: Thu, 27 Nov 2008 11:15:26 +0100
References: <1227727024-2281-1-git-send-email-gorcunov@gmail.com>
 <82259867e200855889261370c29bbd15a111d7fb.1227725632.git.gorcunov@gmail.com>
 <cc7949234e3ac0ddb402764be5ed620035f964a6.1227725632.git.gorcunov@gmail.com>
 <6bc2fd402754cfa5b69a63a529bc065584c5f375.1227725632.git.gorcunov@gmail.com>
 <39e35cbc79237b162a0720dceaa52a72c7eb1690.1227725632.git.gorcunov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 26 Nov 2008 22:17:03 +0300, gorcunov@gmail.com said:
> From: Cyrill Gorcunov <gorcunov@gmail.com>
> 
> ret_from_fork is definitly procedure so mark it as that.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> ---
>  arch/x86/kernel/entry_64.S |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index c409f73..a21be86 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -370,6 +370,7 @@ END(save_paranoid)
>   */
>  /* rdi:	prev */
>  ENTRY(ret_from_fork)
> +	CFI_STARTPROC
>  	DEFAULT_FRAME
>  	push kernel_eflags(%rip)
>  	CFI_ADJUST_CFA_OFFSET 8

This is not needed/wanted. DEFAULT_FRAME includes "CFI_STARTPROC simple"
already.

Alexander

> 1.6.0.4.603.gbc9c0
> 
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - The professional email service

