Return-Path: <linux-kernel-owner+w=401wt.eu-S1755475AbYJQO2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbYJQO2A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 10:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754545AbYJQO1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 10:27:52 -0400
Received: from ik-out-1112.google.com ([66.249.90.177]:62240 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500AbYJQO1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 10:27:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XEVSNIb+5/kFCLyDn8VhvYIZhC93f5KorbxuQE2FgOO/2F8+guT4yRiwdj194HTetu
         rlH/JLCtVeezvsp/HtoMGNdvsCvwuHeuWT66apMPmByQH2NxSa5StOSnNLI70xNYs9KN
         qME3WlRAIfPcEiKy+IBHqOvC2xMYNO7CyTeSI=
Date: Fri, 17 Oct 2008 15:27:25 +0100
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: xiyou.wangcong@gmail.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, jdike@addtoit.com, stable@kernel.org
Subject: Re: [Patch] uml: fix one compile error
Message-ID: <20081017142725.GB19832@hack.voiplan.pt>
References: <20081016152626.GD13374@hack.voiplan.pt> <20081016161557.af935f49.akpm@linux-foundation.org> <20081017122032.GF2951@hack.voiplan.pt> <E1KqoV0-0002VW-90@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1KqoV0-0002VW-90@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 02:32:10PM +0200, Miklos Szeredi wrote:
>On Fri, 17 Oct 2008, =?utf-8?Q?Am=C3=A9rico?= Wang wrote:
>> On Thu, Oct 16, 2008 at 04:15:57PM -0700, Andrew Morton wrote:
>> >On Thu, 16 Oct 2008 16:26:26 +0100
>> >Am__rico Wang <xiyou.wangcong@gmail.com> wrote:
>> >
>> >> 
>> >> This patch fixed the following compile error:
>> >> 
>> >>   CC      arch/um/sys-i386/signal.o
>> >>   /home/wangcong/Projects/linux-2.6/arch/um/sys-i386/signal.c: In
>> >> function 'copy_sc_from_user':
>> >> /home/wangcong/Projects/linux-2.6/arch/um/sys-i386/signal.c:182:
>> >> warning: dereferencing 'void *' pointer
>> >> /home/wangcong/Projects/linux-2.6/arch/um/sys-i386/signal.c:182:
>> >> error: request for member '_fxsr_env' in something not a structure or
>> >> union
>> >> 
>> >> 
>> >> Signed-off-by: WANG Cong <wangcong@zeuux.org>
>> >> Cc: jdike@addtoit.com
>> >> 
>> >> ---
>> >> diff --git a/arch/um/sys-i386/signal.c b/arch/um/sys-i386/signal.c
>> >> index fd0c25a..1296473 100644
>> >> --- a/arch/um/sys-i386/signal.c
>> >> +++ b/arch/um/sys-i386/signal.c
>> >> @@ -179,7 +179,8 @@ static int copy_sc_from_user(struct pt_regs *regs,
>> >>  	if (have_fpx_regs) {
>> >>  		struct user_fxsr_struct fpx;
>> >>  
>> >> -		err = copy_from_user(&fpx, &sc.fpstate->_fxsr_env[0],
>> >> +		err = copy_from_user(&fpx,
>> >> +			&((struct _fpstate __user *)sc.fpstate)->_fxsr_env[0],
>> >>  				     sizeof(struct user_fxsr_struct));
>> >>  		if (err)
>> >>  			return 1;
>> >
>> >Which kernel versions are affected by this error? 2.6.27?
>> 
>> I haven't tried a stable version, but I will. :)
>
>2.6.27 as UML works for me without the patch.
>
>But it is needed for 2.6.28...  thanks.
>
>Tested-by: Miklos Szeredi <mszeredi@suse.cz>

Thank you! :)


-- 
"Sometimes the only way to stay sane is to go a little crazy."

