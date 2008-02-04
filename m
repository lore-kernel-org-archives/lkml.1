Return-Path: <linux-kernel-owner+w=401wt.eu-S1755759AbYBDVMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759AbYBDVMm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 16:12:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbYBDVMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 16:12:33 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:41420 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272AbYBDVMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 16:12:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=xdnlhkEaXUQjI4/xgMvDdZB4CuUz9JhShK6dzg8Unlw1mPeykluqGugrHN31bHPxjeHpEUTRtC1FlxXbJkMxqqELjYvt7hd6+ww96fBOJgClLDHxdAwL1kLSChi0V/3zSppueveMrjWfcft7nDTfpJNY+FTFDJxstzSuMH+XFZQ=
Message-ID: <aa79d98a0802041312j442c99d5sf702a54202c34963@mail.gmail.com>
Date: Tue, 5 Feb 2008 00:12:32 +0300
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: vmlinux_64.lds.S - use THREAD_SIZE instead of numeric constant
Cc: "Ingo Molnar" <mingo@elte.hu>, "Sam Ravnborg" <sam@ravnborg.org>,
       "Andi Kleen" <ak@suse.de>, "Thomas Gleixner" <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <47A777FD.7080208@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080204171037.GA6743@cvg>
	 <20080204202241.GA16919@uranus.ravnborg.org>
	 <20080204203315.GA31341@elte.hu> <47A777FD.7080208@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam, Ingo, Peter, i didn't commented it 'cause there was no comment in
32bit version. And Sam, you are so right - i spent some time on trying
to remember that 8192 bytes trick, and it seems it's not actual
anymore for 64bits cpu. As punishment for myself i'm going to shut up
for a week. Sorry for spent yours time.

On 2/4/08, H. Peter Anvin <hpa@zytor.com> wrote:
> Ingo Molnar wrote:
> > * Sam Ravnborg <sam@ravnborg.org> wrote:
> >
> >> Hi Cyrill.
> >> On Mon, Feb 04, 2008 at 08:10:37PM +0300, Cyrill Gorcunov wrote:
> >>> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> >> The patch looks simple but please explain why you do what you do. It
> >> took me some digging before I could convince mysleft this was indeed a
> >> correct change. And I am pretty sure you did the same investigation
> >> yourself.
> >>
> >> A comment like:
> >>
> >> arch/x866/kernel/inittask.c require all variables allocated in
> >> the section .data.init_task to be aligned with THREAD_SIZE.
> >>
> >> would have made me happy.
> >
> > Btw., given that on x86 we've moved away from the %esp based task stack
> > trick and use an %fs based Percpu-Data-Area (PDA) to access the current
> > task pointer, this alignment might not be necessary anymore. It's a
> > historic relic of the mask-%esp trick.
> >
>
> Was that *ever* used on x86-64?  I thought x86-64 always used %gs for this.
>
> 	-hpa
>
