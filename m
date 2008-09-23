Return-Path: <linux-kernel-owner+w=401wt.eu-S1754459AbYIWRBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459AbYIWRBK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 13:01:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbYIWRA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 13:00:58 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:4081 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbYIWRA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 13:00:57 -0400
Message-ID: <48D920C8.2060600@ct.jp.nec.com>
Date: Tue, 23 Sep 2008 10:00:56 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH -tip 0/4] x86: signal handler improvement
References: <48D84A2A.2030009@ct.jp.nec.com> <20080923085027.GA25698@elte.hu> <20080923085518.GA29703@elte.hu>
In-Reply-To: <20080923085518.GA29703@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>> could we perhaps first finish unifying them into signal.c, and then 
>> introduce __put_user_cerr() in signal_32/64.c?
> 
> i've got an API suggestion as well. Instead of:
> 
> -               err |= __put_user(UC_FP_XSTATE, &frame->uc.uc_flags);
> +               __put_user_cerr(UC_FP_XSTATE, &frame->uc.uc_flags, err);
> 
> could you instead please make it:
> 
> +               __put_user_cerr(UC_FP_XSTATE, &frame->uc.uc_flags, &err);
> 
> i.e. pass in 'err' as a reference. This makes it clear to the casual 
> reader, in a C calling convention sense, that there's a side-effect to 
> 'err'. [ There should be no change to the resulting code as 
> __put_user_cerr() is a macro. ]

make sense!
Will do in next post.

thanks,
Hiroshi Shimamoto


