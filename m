Return-Path: <linux-kernel-owner+w=401wt.eu-S1755463AbZFGKEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbZFGKEL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 06:04:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbZFGKEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 06:04:00 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45425 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754020AbZFGKD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 06:03:59 -0400
Message-ID: <4A2B9086.20309@redhat.com>
Date: Sun, 07 Jun 2009 13:03:50 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: guillaume.thouvenin@ext.bull.net, linux-kernel@vger.kernel.org
Subject: Re: [2.6.30-rc8 KVM] gcc 3.3 dies at emulate_2op_cl().
References: <4A2B7A79.4060600@redhat.com>	<200906071747.FFJ57396.MSOOQFVHtFOJLF@I-love.SAKURA.ne.jp>	<4A2B8201.8050904@redhat.com>	<200906071839.DFB51529.JFHLOFtMFOSVQO@I-love.SAKURA.ne.jp>	<4A2B8B22.3020602@redhat.com> <200906071900.GED43277.OtJOQFOFSMHVFL@I-love.SAKURA.ne.jp>
In-Reply-To: <200906071900.GED43277.OtJOQFOFSMHVFL@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> Avi Kivity wrote:
>   
>> I can eliminate _tmp by using lahf/sahf, but it's not going to be a 
>> trivial patch.
>>     
>
> I don't know what's happening here.
>
> If I comment out (_dst).bytes == 2 , it compiles.
> The problem happens only "w" + "unsigned short" case.
>
> # diff -urp arch/x86/kvm/x86_emulate.c~ arch/x86/kvm/x86_emulate.c
> --- arch/x86/kvm/x86_emulate.c~ 2009-06-03 12:07:25.000000000 +0900
> +++ arch/x86/kvm/x86_emulate.c  2009-06-07 17:52:05.591542272 +0900
> @@ -461,8 +461,8 @@ static u32 group2_table[] = {
>         do {                                                                    \
>                 switch ((_dst).bytes) {                                         \
>                 case 2:                                                         \
> -                       __emulate_2op_cl(_op, _cl, _src, _dst, _eflags,         \
> -                                               "w", unsigned short);           \
> +                       /* __emulate_2op_cl(_op, _cl, _src, _dst, _eflags,      \
> +                          "w", unsigned short); */             \
>                         break;                                                  \
>                 case 4:                                                         \
>                         __emulate_2op_cl(_op, _cl, _src, _dst, _eflags,         \
>   

It's a gcc register allocator bug.  Bugs don't have to be reasonable.


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

