Return-Path: <linux-kernel-owner+w=401wt.eu-S934868AbYBUW5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934868AbYBUW5x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 17:57:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbYBUW5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 17:57:45 -0500
Received: from ik-out-1112.google.com ([66.249.90.178]:52325 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbYBUW5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 17:57:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bctJMdOJVUHsf2LKPM6d1C0Px7OiAHm2GZWFPavhQ/3/PwtetP+BvZvubYvLVxepHdYtrXClRG516zgGaxpPLQBJWBrVtwui9eZSoWVW+oomVEsTLUdZ/DQGfkuOTvQA5Iyq169myd/HSjsRoMGC93n+l13r3DeXR7Wuu37GPLM=
Message-ID: <5d6222a80802211457s2beb4d5cre331bc800c28d111@mail.gmail.com>
Date: Thu, 21 Feb 2008 19:57:39 -0300
From: "Glauber Costa" <glommer@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 2/2] make work have a static address in do_boot_cpu()
Cc: "Glauber Costa" <gcosta@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu, arjan@infradead.org
In-Reply-To: <1203631967.6112.16.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1203626456-3101-1-git-send-email-gcosta@redhat.com>
	 <1203626456-3101-2-git-send-email-gcosta@redhat.com>
	 <1203626456-3101-3-git-send-email-gcosta@redhat.com>
	 <1203631967.6112.16.camel@lappy>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2008 at 7:12 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
>  On Thu, 2008-02-21 at 17:40 -0300, Glauber Costa wrote:
>  > This patch makes the work field in create_idle have
>  > a static address. Otherwise, being a stack variable, it can
>  > boild down the lockdep system.
>
>  Looks way overkill. Doesn't something like:
>
>
>  > Signed-off-by: Glauber Costa <gcosta@redhat.com>
>  > ---
>  >  arch/x86/kernel/smpboot_64.c |   13 +++++++------
>  >  1 files changed, 7 insertions(+), 6 deletions(-)
>  >
>  > diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
>  > index f15b774..d79b7a8 100644
>  > --- a/arch/x86/kernel/smpboot_64.c
>  > +++ b/arch/x86/kernel/smpboot_64.c
>
>
> > @@ -553,12 +554,12 @@ static int __cpuinit do_boot_cpu(int cpu
>  >       unsigned long boot_error;
>  >       int timeout;
>  >       unsigned long start_rip;
>  >       struct create_idle create_idle = {
>  > -             .work = __WORK_INITIALIZER(create_idle.work, do_fork_idle),
>  >               .cpu = cpu,
>  >               .done = COMPLETION_INITIALIZER_ONSTACK(create_idle.done),
>  >       };
>  > +     INIT_WORK(&create_idle.work, do_fork_idle);
>
>  work?

Indeed.

I missed the static lock_class_key definition inside INIT_WORK macro.
It does the job neatly.


-- 
Glauber Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
