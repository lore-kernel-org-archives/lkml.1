Return-Path: <linux-kernel-owner+w=401wt.eu-S1764095AbXEWA2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764095AbXEWA2j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 20:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758517AbXEWA2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 20:28:30 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:55254 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758205AbXEWA23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 20:28:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ryvBgHAI5AJaXOeF0X6SrjS9MhQC7hKojEGeGDH88dy0fF9zWRRnC1YCbVKvfBktVAvjk9mkf5fsZsmQr3p55/fgfcANJsE4KMaFpJAbIQc7ALuImgzHzGncwgtnoQlQExft0/yWLXqUHXMBDKEepBaYF36WN0GWcEWRCKWB3Nk=
Message-ID: <8bd0f97a0705221728p1c4761bbi83e58245cfca48f9@mail.gmail.com>
Date: Tue, 22 May 2007 20:28:28 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Paul Mundt" <lethal@linux-sh.org>,
       "Robin Getz" <rgetz@blackfin.uclinux.org>,
       "Bryan Wu" <bryan.wu@analog.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/32] Blackfin update for 2.6.22-rc2
In-Reply-To: <20070521143730.GA18110@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1179742180228-git-send-email-bryan.wu@analog.com>
	 <200705211035.08380.rgetz@blackfin.uclinux.org>
	 <20070521143730.GA18110@linux-sh.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/21/07, Paul Mundt <lethal@linux-sh.org> wrote:
> On Mon, May 21, 2007 at 10:35:08AM -0400, Robin Getz wrote:
> > On Mon 21 May 2007 06:09, Bryan Wu pondered:
> > > Lots of update for 2.6.22-rc2 and tested on STAMP537 board.
> > >
> >
> > One of the things I noticed when trying out 2.6.22-rc1, on blackfin was:
> >
> >  CALL    scripts/checksyscalls.sh
> [snip syscalls]
> >
> > since there is noMMU, are we better:
> >  - putting stubs (return ENOSYS - give runtime errors), or
> >  - just ignore the errors - and give compile errors? (Is there any way to put
> > something into the syscall table, as not to get the warnings?)
>
> No, you'd be better of figuring out which ones you can support and which
> ones you have to -ENOSYS. CONFIG_MMU=n is not a "get out of syscalls
> free" card. Many of these have no dependency on CONFIG_MMU, anyways.

when you say -ENOSYS, do you mean we need sys_foo() that simply does
return -ENOSYS or do we just let the default syscall code go "__NR_foo
is not registered, return -ENOSYS"
-mike
