Return-Path: <linux-kernel-owner+w=401wt.eu-S1763607AbXJNUza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763607AbXJNUza (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 16:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754487AbXJNUzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 16:55:23 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:12244 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141AbXJNUzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 16:55:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:references:in-reply-to:mime-version:content-disposition:cc:content-type:content-transfer-encoding:message-id;
        b=Dv5/VDVV5c6A2ncEoEOfkyDlGrjhNeS7YZ7za+zxGFCxA2LvrkUxT+I4qG1YaIXZOlUffrWTj/8micCjwzIEIT3tpNSVcecVpGRj+zQsuPtniN3ePeT/NSHhLOi5c9qxk1mZ8d0jh/7zW8gh0f3PDu43RGP3Oa6i6CvpC0Bc+ng=
From: poison <rc.poison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: linux-2.6.23 - acting funny
Date: Sun, 14 Oct 2007 22:55:11 +0200
User-Agent: KMail/1.9.7
References: <200710111409.13854.bgrpt@toplitzer.net> <200710120053.20202.rc.poison@gmail.com> <20071012060516.GA26074@elte.hu>
In-Reply-To: <20071012060516.GA26074@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200710142255.11806.rc.poison@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi and thanks for your reply :)

On Friday 12 October 2007, you wrote:
> i have no quick ideas - the behavior you are seeing is quite unexpected.
> Could you try the current sched-devel code:
>
>  
> http://redhat.com/~mingo/cfs-scheduler/devel/sched-devel-combo-v2.6.23.patc
>h
Maybe I messed something up. I first applied that patch and tested. Then 
reversed the patch with patch -R ... but in both cases the output of the 
cfs-debug-info script contained:
Sched Debug Version: v0.05-v20

>
> since this version of CFS does various things differently then the one
> in v2.6.23, lets see whether perturbing it makes any difference to your
> throughput.
Without Hog: ~15MB/s
With Hog: ~19/MBs


>
> you could also try the scheduler backport to v2.6.22.10, at:
>
>   http://redhat.com/~mingo/cfs-scheduler/
with sched-cfs-v2.6.22.9-v22.patch applied to 2.6.22.10 (I didn't spot one for 
2.6.22.10):
Without Hog: ~14MB/s
With Hog: ~19MB/s

>
> that would establish whether it's the changes in scheduling that cause
> this or something else. Plus please enable CONFIG_SCHED_DEBUG and
> CONFIG_SCHEDSTATS and run this debug script while such a transfer is
> going on:
>
>   http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh
>
> and send me the resulting file.
I created one for each tested kernel with
$ while true; do echo test>/dev/null; done
running and without.

I'll send you the files in private.
Thanks for your time.

Regards,
 Andreas



