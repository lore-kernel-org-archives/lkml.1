Return-Path: <linux-kernel-owner+w=401wt.eu-S1760911AbYFDTNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760911AbYFDTNm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 15:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036AbYFDTNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 15:13:31 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:55345 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbYFDTNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 15:13:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:sender:to:subject:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references:x-google-sender-auth;
        b=IZxVG/23ujbbuJ0q/RzF/KWVDJZLZ/68vfdGQkrdr8Qj34yWZU6ef9MC3I4FoE0/ow
         FW7XvHkPNCTFI7KdtqxiME80WuylYUrtAWPOVJvkFxB7qVZr6BSFPmr96gsVObJARYZC
         E9ez91dLqfnxX4LLrO9mjoNzVb08BaO1FWLS8=
Message-ID: <76bd70e30806041213l685aee07q510d1037d012b0a1@mail.gmail.com>
Date: Wed, 4 Jun 2008 15:13:25 -0400
From: "Chuck Lever" <chuck.lever@oracle.com>
Reply-To: chucklever@gmail.com
To: "Dave Jones" <davej@redhat.com>, "Chuck Lever" <chuck.lever@oracle.com>,
       "Trond Myklebust" <Trond.Myklebust@netapp.com>, chucklever@gmail.com,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: Re: NFS oops in 2.6.26rc4
In-Reply-To: <20080604182015.GA20074@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080527190419.GA14577@redhat.com>
	 <76bd70e30805301059v461e8f0eocc38b6fe36dd3b21@mail.gmail.com>
	 <20080530182126.GB32480@redhat.com>
	 <1212172308.8579.20.camel@localhost>
	 <20080530190314.GC32480@redhat.com>
	 <CEA741EF-8E34-40FD-82A8-747AE1B6E78F@oracle.com>
	 <20080604141958.GA14148@redhat.com>
	 <E1135064-06EA-405C-A967-DFB1DC9F0418@oracle.com>
	 <20080604182015.GA20074@redhat.com>
X-Google-Sender-Auth: ddf65d0834984e76
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 4, 2008 at 2:20 PM, Dave Jones <davej@redhat.com> wrote:
> On Wed, Jun 04, 2008 at 02:13:08PM -0400, Chuck Lever wrote:
>  >
>  > On Jun 4, 2008, at 10:19 AM, Dave Jones wrote:
>  >
>  > > On Fri, May 30, 2008 at 03:37:01PM -0400, Chuck Lever wrote:
>  > >
>  > >>> Something else of note which I hadn't seen before, usually things
>  > >>> lock
>  > >>> up just after that first oops. For some reason, today it survived
>  > >>> a little longer, but things really went downhill fast.
>  > >>> It survived a 'dmesg ; scp dmesg davej@gelk', and then wedged solid.
>  > >>> So as well as the oops, it seems we're corrupting memory too.
>  > >>> For reference, this kernel has both SLUB_DEBUG and PAGEALLOC_DEBUG
>  > >>> enabled.
>  > >>
>  > >> I haven't seen this kind of problem here with .26, but yes, it does
>  > >> look like something is clobbering memory during an NFS mount.
>  > >>
>  > >> I introduced some NFS mount parsing changes in this commit range:
>  > >>
>  > >>   2d767432..82d101d5
>  > >>
>  > >> A quick bisect should show which, if any of these, is the guilty
>  > >> party.  If any of these are the problem, I suspect it's 3f8400d1.
>  > >
>  > > I didn't get time to try this out yet (hopefully tomorrow).
>  > > In the meantime, we've just gotten word of another user seeing memory
>  > > corruption with nfs - https://bugzilla.redhat.com/show_bug.cgi?id=449958
>  >
>  > 449958 could very well be the same problem.  The stack traceback is a
>  > lot cleaner than the one you originally sent, but there are a lot of
>  > similarities.  (I doubt this is related to symlinks, as the comment
>  > suggests).
>  >
>  > Is commit 86d61d863 applied to the current rawhide kernel?
>
> That kernel was .26rc4.git2, so unless it's only gone in in the last day
> or two, yes.  (Bandwidth impaired right now, and no local git repo to check)

Argh, I was afraid of that.  I expected that commit to improve things.
 Maybe it did, but this is a different problem?  You're going to force
me to actually think about this.  :-)

In any event, a bisect would be helpful here, when you can.  I will
also stare at the traceback in 449958 and see if anything new jumps
out.  It's certainly taken the heat off of the NFS client; it looks
like an rpcbind issue.

-- 
Chuck Lever
chuck[dot]lever[at]oracle[dot]com
