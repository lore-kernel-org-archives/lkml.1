Return-Path: <linux-kernel-owner+w=401wt.eu-S1752854AbXBSFOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbXBSFOY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 00:14:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbXBSFOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 00:14:24 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:29901 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbXBSFOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 00:14:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ptVou6nw8iVtWgrT8DI8CEu/G79m1oNN0TYVP5yAl/ERSgPU7aSBBGCPy4Zfd1L+OmeViL5XC2Cyt9XQktdfwll0ybpguiMZE68WuE2GI9A+dPLR/9pUUG6DMljScjrZ01paARWznns4TmGFzHrBWlg0SdLUlVooid+0aznjLdU=
Message-ID: <2fe399760702182114v33f6825ckef91936c4a28b3f1@mail.gmail.com>
Date: Sun, 18 Feb 2007 21:14:21 -0800
From: "Phy Prabab" <phyprabab@gmail.com>
To: "Willy Tarreau" <w@1wt.eu>
Subject: Re: Question about setting affinity in 2.4
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070219043927.GE943@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2fe399760702181802q39e75b42iea7f80124506f169@mail.gmail.com>
	 <20070219043927.GE943@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Willy,

Thanks for the heads up and patch location.  It looks like the guys at
RH seemed to have applied a patch to allow one to set affinity,
however, it might be that it is broken.  Guess I will have to contact
the RH people to get an update as to what they did/did not do.

Thanks!
Phy

On 2/18/07, Willy Tarreau <w@1wt.eu> wrote:
> Hi Phy !
>
> On Sun, Feb 18, 2007 at 06:02:17PM -0800, Phy Prabab wrote:
> > Hello everyone,
> >
> > I am trying to set affinity on a program to make sure I can get the
> > best use of the cache as possible and to eliminate as much noise as
> > possible with running my program.  I have tried unsuccessfully to set
> > affinity using sched_set/getaffinity and the CPU_SET macros.  In
> > particular, I can not seem to get the process to use affinity I
> > specify as in:
> >
> > int main () {
> >  cpu_set_t mask;
> >  cpu_set_t setmask;
> >  long long x;
> >  double foo;
> >  printf("Mask set to %08lx\n", sched_getaffinity(0, &mask));
> >  CPU_SET(1, &mask);
> >  if (sched_setaffinity(0, &mask) == -1) {
> >     printf("error setting affinity.");
> >  }
> >
> >  printf("Mask is reset to %08lx\n", sched_getaffinity(0, &mask));
> >  // do some long lasting calculations ....
> >
> >  return;
> > }
> >
> > No mater what I do, the process is never bond to the processor in
> > question as exposed by this little appy and by cat /proc/<pid>/cpu.
> > Is this just impossible to do?
> >
> > Ah, the kernel I am using is RH 2.4.21-37.ELsmp.
>
> I don't know for RH kernel, but the affinity syscalls are not in 2.4
> mainline. You can apply the patch without much hassle if you want. It's
> in Robert Love's directory :
>
>  http://www.kernel.org/pub/linux/kernel/people/rml/cpu-affinity/v2.4/
>
> I believe you'll have to use an -ac patch for RHEL.
>
> > TIA!
> > Phy
>
> regards,
> Willy
>
>
