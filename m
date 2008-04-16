Return-Path: <linux-kernel-owner+w=401wt.eu-S1765788AbYDPPGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765788AbYDPPGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 11:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757017AbYDPPGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 11:06:09 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:15075 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755252AbYDPPGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 11:06:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mE1vOwbcFyVZkgUP0d06QCTXGFIrasNO/d92SHHJdaJGf5Kht4/lR2XESvsxceRDijxMGYSy2zlfMzGVzOFKpTkUH2ts4v2a70SnygUCrInvDrrTY/N7QkIGDYVLyNoJ/V4TOg0M0EfWpG0quwePPvQvyTxX9u/9FYqv5rnioCk=
Message-ID: <804dabb00804160806o39a2c89eg8d3a3387beb7b5cb@mail.gmail.com>
Date: Wed, 16 Apr 2008 23:06:05 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>
Subject: Re: RFC: Self-snapshotting in Linux
Cc: "Scott Lovenberg" <scott.lovenberg@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <db1091b2-68a6-4f71-800e-c4df6f8641ca@m44g2000hsc.googlegroups.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ajbvb-3Ur-21@gated-at.bofh.it> <ajd42-7Gt-49@gated-at.bofh.it>
	 <db1091b2-68a6-4f71-800e-c4df6f8641ca@m44g2000hsc.googlegroups.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/16/08, Alan Jenkins <alan-jenkins@tuffmail.co.uk> wrote:
> Scott Lovenberg wrote:
>
> > Peter Teoh wrote:
>  > Maybe you load up another kernel to handle the snapshot, and then hand
>  > the system back to it afterwards?  What do you think?
>
>
> Isn't that just what Ying Huans kexec-based hibernation does?
>

This list is awesome.   After I read up on this kexec-based hibernation thing:

http://kerneltrap.org/node/11756

I realized it is about the same idea.   Some differences though:

My original starting point was VMWare's snapshot idea.   Drawing an
analogy from there, the idea is to freeze and restore back entire
kernel + userspace application.   For integrity reason, filesystem
should be included in the frozen image as well.

Currently, what we are doing now is to have a bank of Norton
Ghost-based images of the entire OS and just selectively restoring
back the OS we want to work on.   Very fast - less than 30secs the
entire OS can be restored back.   But problem is that it need to be
boot up - which is very slow.   And there userspace state cannot be
frozen and restored back.

VMWare images is slow, and cannot meet bare-metal CPU/direct hardware
access requirements.   There goes Xen's virtualization approach as
well.

Another approach is this (from an email by Scott Lovenberg) - using
RELOCATABLE kernel (or may be not?????I really don't know, but idea is
below):

a.   Assuming we have 32G (64bit hardware can do that) of memory, but
we want to have 7 32-bit OS running (not concurrently) - so then
memory is partition into 8 x 4GB each - the lowest 4GB reserved for
the current running OS.   Each OS will be housed into each 4G of
memory.   When each OS is running, it will access its own partition on
the harddisk/memory, security concerns put aside.   Switching from one
OS to another OS is VOLUNTARILY done by the user - equivalent to that
of "desktop" feature in Solaris CDE. Restoring back essentially is
just copying from each of the 4GB into the lowest 4GB memory range.
Because only the lowest 4gb is used, only 32 bit instruction is
needed, 64bit is needed only when copying from one 4GB memory
partition into the lowest 4GB region, and vice versa.   And together
with using  partitioning of harddisk for each OS, switching among the
different OS kernel should be in seconds, much less than 1 minute,
correct?

Technically, does the above sound feasible?


-- 
Regards,
Peter Teoh
