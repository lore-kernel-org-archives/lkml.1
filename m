Return-Path: <linux-kernel-owner+w=401wt.eu-S1756184AbZCXGrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbZCXGrQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 02:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751958AbZCXGrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 02:47:00 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:55074 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbZCXGq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 02:46:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HTXb7/eou1tieywccL1kMwowEGseTW4brlnZCXzZxDQ5O8cyFcunCFIO58gSwPKLCk
         oCOUSgo29vTMT7BxQkhGWhO3qBmHG0kERHVfMKS1uxPPfyl6X+qDKnmcKxYq9m3INLZ0
         fyeksNKZxcc7wgidDik9JIf3UEQfGOkwdnovg=
MIME-Version: 1.0
In-Reply-To: <49C87B87.4020108@krogh.cc>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain>
	 <49C87B87.4020108@krogh.cc>
Date: Mon, 23 Mar 2009 23:46:57 -0700
Message-ID: <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com>
Subject: Re: Linux 2.6.29
From: David Rees <drees76@gmail.com>
To: Jesper Krogh <jesper@krogh.cc>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 11:19 PM, Jesper Krogh <jesper@krogh.cc> wrote:
> I know this has been discussed before:
>
> [129401.996244] INFO: task updatedb.mlocat:31092 blocked for more than 480
> seconds.

Ouch - 480 seconds, how much memory is in that machine, and how slow
are the disks? What's your vm.dirty_background_ratio and
vm.dirty_ratio set to?

> Consensus seems to be something with large memory machines, lots of dirty
> pages and a long writeout time due to ext3.

All filesystems seem to suffer from this issue to some degree.  I
posted to the list earlier trying to see if there was anything that
could be done to help my specific case.  I've got a system where if
someone starts writing out a large file, it kills client NFS writes.
Makes the system unusable:
http://marc.info/?l=linux-kernel&m=123732127919368&w=2

Only workaround I've found is to reduce dirty_background_ratio and
dirty_ratio to tiny levels.  Or throw good SSDs and/or a fast RAID
array at it so that large writes complete faster.  Have you tried the
new vm_dirty_bytes in 2.6.29?

> At the moment this the largest "usabillity" issue in the serversetup I'm
> working with. Can there be done something to "autotune" it .. or perhaps
> even fix it? .. or is it just to shift to xfs or wait for ext4?

Everyone seems to agree that "autotuning" it is the way to go.  But no
one seems willing to step up and try to do it.  Probably because it's
hard to get right!

-Dave
