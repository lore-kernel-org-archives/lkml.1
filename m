Return-Path: <linux-kernel-owner+w=401wt.eu-S1752100AbYIUMu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100AbYIUMu6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 08:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbYIUMuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 08:50:50 -0400
Received: from web32607.mail.mud.yahoo.com ([68.142.207.234]:46222 "HELO
	web32607.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751413AbYIUMut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 08:50:49 -0400
X-YMail-OSG: 2LLxVBEVM1lQXMvWNx_sv.iIkOS19ygck8yhhBi14iO2KsLfgTVAfyiCg5o9eAZ0wDCDf2Oos4UUiEH1QvraI69RYLgPCOUX_mndsSpTQ2Zl9mScTTt_JF4kacjhjZBjfvoyJMjO_BEWfMyKOxCW86z1qjz.JA--
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/1096.28 YahooMailWebService/0.7.218.2
Date: Sun, 21 Sep 2008 05:50:47 -0700 (PDT)
From: Martin Knoblauch <knobi@knobisoft.de>
Subject: Re: [RFC][Resend] Make NFS-Client readahead tunable
To: Chuck Lever <chucklever@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Banks <gnb@melbourne.sgi.com>,
       linux-nfs list <linux-nfs@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Peter zijlstra <a.p.zijlstra@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <968192.84087.qm@web32607.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----

> From: Chuck Lever <chucklever@gmail.com>
> To: Martin Knoblauch <knobi@knobisoft.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>; Greg Banks <gnb@melbourne.sgi.com>; linux-nfs list <linux-nfs@vger.kernel.org>; linux-kernel@vger.kernel.org; Peter zijlstra <a.p.zijlstra@chello.nl>
> Sent: Thursday, September 18, 2008 8:24:42 PM
> Subject: Re: [RFC][Resend] Make NFS-Client readahead tunable
> 
> On Thu, Sep 18, 2008 at 6:53 AM, Martin Knoblauch wrote:
> > ----- Original Message ----
> >
> >> From: Andrew Morton 
> >> To: Martin Knoblauch 
> >> Cc: Greg Banks ; linux-nfs list 
> ; linux-kernel@vger.kernel.org; Peter zijlstra 
> 
> >> Sent: Thursday, September 18, 2008 10:47:33 AM
> >> Subject: Re: [RFC][Resend] Make NFS-Client readahead tunable
> >>
> >> On Thu, 18 Sep 2008 01:38:57 -0700 (PDT) Martin Knoblauch
> >> wrote:
> >>
> >> > > No.  mount(8) will pass unrecognised options straight down into the
> >> > > filesystem driver.
> >> > >
> >> >
> >> >  Has that always been the case, or is it a recent change? I have to support
> >> RHEL4 userland, which is not really new.
> >>
> >> It's been that way for ever and ever.  It's how all these guys:
> >>
> >> y:/usr/src/25> grep Opt_ fs/*/super.c|wc
> >>     781    2626   33703
> >>
> >> get handled.
> >
> >  while that seems to be not to complicated, I seem to have a problem passing 
> the mount options to the kernel. They come down as mount data version "6". 
> Apparently mount(8) or mount.nfs(8) are doing the parsing and send down the 
> legacy data block. So, what is the minimum version of mount or mount.nfs that 
> pass the options down unaltered?
> 
> The mount command has passed a string of options to the kernel for
> particular file systems for a while, but the facility for the NFS
> client to parse a string of mount options in the kernel was added only
> recently -- at least 2.6.23 or 2.6.24 is required to support this.
> Before this, the mount command parsed these options.
>

 I understand that. Question remains, which version of the mount(8) or nfs.mount(8) command do I need to pass the options to the kernel.
 
> For RHEL 4, based on 2.6.9, you are stuck.  It uses a binary structure
> whose fields must match between the kernel and user space.  For RH
> enterprise kernels, the ABI cannot change in a given release, so RH
> wouldn't take a patch to change the data structure that mount uses.
> You would have to maintain such a change yourself, and build your own
> kernels and mount command after each RHEL 4 update is released.
> 

 For implementation/testing purposes I have some freedom in what userland I run. My systems are mainly RHEL4,  but I have long junked the 2.6.9 based kernels.

> I agree that a mount option would allow more fine-grained control over
> readahead.  A system wide parameter controlling readahead has always
> been a weakness.  Readahead, as implemented in the VFS, has a
> *per-file descriptor* context, however, which operates automatically
> (and can be tuned at run-time by an application with [mf]advise(2).
>

 The per-file descriptor stuff is not applicable in my case, as I do not have controll over programms acessing the files.
 
> As a future feature, this might work in better combination with the
> per-mount bdi changes proposed by Peter to provide maximal flexibility
> without exposing yet another confusing knob that could help some
> workloads but hurt others.
> 


 Thats why I am open to experiment, but need to know which userland tools support the direct passing of mount options to the NFS client.

Cheers
Martin

