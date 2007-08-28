Return-Path: <linux-kernel-owner+w=401wt.eu-S1763745AbXH1UBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763745AbXH1UBB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 16:01:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753958AbXH1UAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 16:00:53 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:19224 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbXH1UAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 16:00:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=cs6XsPfDESD/U9HPLMxaHnT8fHqXIPbFfH1FZdPEo1+u9SGZWFc5zrN2NYlr1tOVK3647IVQrA7FcuwABLTt2F3jnTLXIRetxL+TZPXvTGWorxS0q4XhP4Bypj60t18gkaxgL+BmiLjtIVow/MLPCFPAikayjn7EY9w6JxGVS94=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Subject: Re: How to find out how many other processes share VM with $PID?
Date: Tue, 28 Aug 2007 21:00:41 +0100
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org
References: <200708271256.31874.vda.linux@googlemail.com> <200708271426.50675.vda.linux@googlemail.com> <388259805.10631@ustc.edu.cn>
In-Reply-To: <388259805.10631@ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708282100.41443.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 August 2007 01:10, Fengguang Wu wrote:
> > > There is a nice LWN article on this issue:
> > >         ELC: How much memory are applications really using?
> > >         http://lwn.net/Articles/230975/
> > >
> > > Another helpful patch could be:
> > >         maps: PSS(proportional set size) accounting in smaps
> > >         http://lkml.org/lkml/2007/8/19/23
> >
> > Thanks a lot, very useful pages indeed.
> >
> > However they still don't explain how I can avoid counting memory
> > twice for /proc/PID1 and /proc/PID2 when PID2 is a child of PID1,
> > created with CLONE_VM.
> >
> > The example: I allocate 1234k, dirty it, then clone with CLONE_VM.
> > I will seemingly have two processes, each using 1234k, _privately_
> > (i.e., pages are not shown as shared in smaps) -
> > which is technically correct, pages are not shared with other VMs,
> > but they ARE shared by means of these two processes having the same VM!
> >
> > How userspace tools can figure out that these processes have shared VM?
> >
> > IOW: do we need "VMsharecount: N" in addition to "Threads: N"
> > in /proc/PID/status?
>
> A full solution would require two parameters, i.e. VmUsers/VmMagic.
>
> But please make sure the new lines won't break important tools like
> ps/top/pmaps/...

Should be safe - tools skip lines they do not recognize.
Ok, we have "Threads: N".

I can cook up a patch which adds count of processes
which share VM with us - it's just atomic_read(&current->mm->mm_users).

What name do you like? 

SharedVmCount: N
VmUsers: N
other?

--
vda
