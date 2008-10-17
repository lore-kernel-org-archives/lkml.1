Return-Path: <linux-kernel-owner+w=401wt.eu-S1754344AbYJQMc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344AbYJQMc3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 08:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753482AbYJQMcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 08:32:19 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:53256 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbYJQMcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 08:32:18 -0400
To: xiyou.wangcong@gmail.com
CC: akpm@linux-foundation.org, xiyou.wangcong@gmail.com,
       linux-kernel@vger.kernel.org, jdike@addtoit.com, stable@kernel.org
In-reply-to: <20081017122032.GF2951@hack.voiplan.pt> (message from
	=?utf-8?Q?Am=C3=A9rico?= Wang on Fri, 17 Oct 2008 13:20:32 +0100)
Subject: Re: [Patch] uml: fix one compile error
References: <20081016152626.GD13374@hack.voiplan.pt> <20081016161557.af935f49.akpm@linux-foundation.org> <20081017122032.GF2951@hack.voiplan.pt>
Message-Id: <E1KqoV0-0002VW-90@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 17 Oct 2008 14:32:10 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Oct 2008, =?utf-8?Q?Am=C3=A9rico?= Wang wrote:
> On Thu, Oct 16, 2008 at 04:15:57PM -0700, Andrew Morton wrote:
> >On Thu, 16 Oct 2008 16:26:26 +0100
> >Am__rico Wang <xiyou.wangcong@gmail.com> wrote:
> >
> >> 
> >> This patch fixed the following compile error:
> >> 
> >>   CC      arch/um/sys-i386/signal.o
> >>   /home/wangcong/Projects/linux-2.6/arch/um/sys-i386/signal.c: In
> >> function 'copy_sc_from_user':
> >> /home/wangcong/Projects/linux-2.6/arch/um/sys-i386/signal.c:182:
> >> warning: dereferencing 'void *' pointer
> >> /home/wangcong/Projects/linux-2.6/arch/um/sys-i386/signal.c:182:
> >> error: request for member '_fxsr_env' in something not a structure or
> >> union
> >> 
> >> 
> >> Signed-off-by: WANG Cong <wangcong@zeuux.org>
> >> Cc: jdike@addtoit.com
> >> 
> >> ---
> >> diff --git a/arch/um/sys-i386/signal.c b/arch/um/sys-i386/signal.c
> >> index fd0c25a..1296473 100644
> >> --- a/arch/um/sys-i386/signal.c
> >> +++ b/arch/um/sys-i386/signal.c
> >> @@ -179,7 +179,8 @@ static int copy_sc_from_user(struct pt_regs *regs,
> >>  	if (have_fpx_regs) {
> >>  		struct user_fxsr_struct fpx;
> >>  
> >> -		err = copy_from_user(&fpx, &sc.fpstate->_fxsr_env[0],
> >> +		err = copy_from_user(&fpx,
> >> +			&((struct _fpstate __user *)sc.fpstate)->_fxsr_env[0],
> >>  				     sizeof(struct user_fxsr_struct));
> >>  		if (err)
> >>  			return 1;
> >
> >Which kernel versions are affected by this error? 2.6.27?
> 
> I haven't tried a stable version, but I will. :)

2.6.27 as UML works for me without the patch.

But it is needed for 2.6.28...  thanks.

Tested-by: Miklos Szeredi <mszeredi@suse.cz>

Miklos
