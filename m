Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188Ab0BUOgc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 09:36:32 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:59757 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab0BUOgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 09:36:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=SX3EXutTS81AxqrddsShrabeGzcBnMkl8Oj4ZdENzbXQJH79pfWTxfjve4OkTZ84li
         HchNVHQHoS1xE7V/Dtb1zLODChBbdsi5+hg7Wi5muLnr7vxa8viDa+Umycgr5mZwHoi6
         GkMDjFT+kHPtvnOpoioOfX1CbI+HBzJ3gjYIY=
Date: Sun, 21 Feb 2010 16:36:23 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 03/17] sysctl extern cleanup - binfmts
Message-ID: <20100221143623.GC21281@core2>
References: <20100221142303.GA3004@darkstar>
 <20100221142813.GB21281@core2>
 <a8e1da1002210633r7a4a8c5em93d908c829d1f4ff@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a8e1da1002210633r7a4a8c5em93d908c829d1f4ff@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 21, 2010 at 10:33:43PM +0800, Dave Young wrote:
> On Sun, Feb 21, 2010 at 10:28 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> > On Sun, Feb 21, 2010 at 10:23:03PM +0800, Dave Young wrote:
> >> --- linux-2.6.32.orig/include/linux/binfmts.h
> >> +++ linux-2.6.32/include/linux/binfmts.h
> >> @@ -20,6 +20,11 @@ struct pt_regs;
> >>  #ifdef __KERNEL__
> >>  #include <linux/list.h>
> >>
> >> +/* for sysctl */
> >
> > This comment is neither accurate nor needed. :^)
> 
> Thanks, sounds good, but the there's no other file use the three vars.
> 
> >
> > In fact master sysctl table always was a big mess, so slight mess
> > caused by extern declarations is fine.
> >
> >> +extern int core_uses_pid;
> >> +extern char *core_pattern;
> >> +extern unsigned int core_pipe_limit;

In fact coredump code should be moved out of fs/exec.c including headers,
so this movement is quite pointless.
