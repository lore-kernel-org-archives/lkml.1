Return-Path: <linux-kernel-owner+w=401wt.eu-S938798AbXHIFt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938798AbXHIFt6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 01:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763528AbXHIFtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 01:49:49 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:8592 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917AbXHIFtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 01:49:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pAaqbCL3CQ2OCzedjBSWqwadAdyeIfDcAiyAyjiS4DmMeQv5tbgChI4b4UIcKzCMz+mttCHGKSQZdlCPdMbJ4RzmRu7CM2bfT3D5EP+038kjuI98uAjszcuA3vRhWyR5WIms24M1nPuhhkWVkjOEdKjlnKYizA3mYmJH3TW6x3s=
Message-ID: <5d6222a80708082249yb51fc6p16718a6b55e8ef4b@mail.gmail.com>
Date: Thu, 9 Aug 2007 02:49:46 -0300
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH 4/25] [PATCH] Add debugreg/load_rsp native hooks
Cc: "Glauber de Oliveira Costa" <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, mingo@elte.hu, chrisw@sous-sol.org,
       jeremy@goop.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       "Steven Rostedt" <rostedt@goodmis.org>
In-Reply-To: <200708081116.43237.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11865467522495-git-send-email-gcosta@redhat.com>
	 <11865467662182-git-send-email-gcosta@redhat.com>
	 <11865467702103-git-send-email-gcosta@redhat.com>
	 <200708081116.43237.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/8/07, Andi Kleen <ak@suse.de> wrote:
>
> >
> > @@ -264,13 +270,64 @@ struct thread_struct {
> >       set_fs(USER_DS);                                                         \
> >  } while(0)
> >
> > -#define get_debugreg(var, register)                          \
> > -             __asm__("movq %%db" #register ", %0"            \
> > -                     :"=r" (var))
> > -#define set_debugreg(value, register)                        \
> > -             __asm__("movq %0,%%db" #register                \
> > -                     : /* no output */                       \
> > -                     :"r" (value))
> > +static inline unsigned long native_get_debugreg(int regno)
> > +{
> > +     unsigned long val;
>
> It would be better to have own functions for each debug register I think
>
Andi, you mean:
a) split the debugreg paravirt_ops in various
paravirt_ops.set/get_debugreg{X,Y,Z...}, and then join them together
in a set/get_debugreg(a,b) to keep the current interface. OR
b) keep one paravirt_ops for each set/get_debugreg, then split then in
various set/get_debugregX(a, b), changing the current interface, OR
c) plit the debugreg paravirt_ops in various
paravirt_ops.set/get_debugreg{X,Y,Z...}, and give each its own
function set/get_debugregX(a, b), again, changing the current
interface, OR
d) None of the above?

-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
