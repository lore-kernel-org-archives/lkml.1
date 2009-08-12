Return-Path: <linux-kernel-owner+w=401wt.eu-S1752368AbZHLWQD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368AbZHLWQD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 18:16:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752325AbZHLWQC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 18:16:02 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:57239 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbZHLWQB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 18:16:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=P7eKK62SRBB2SnPQJlGKyfcdsGY65z95R//0BHVsANlkCcEE2aQ0xcCyzJpk0z5SVF
         OlqJeGym2PPCiKtrdukW2sC/brsF9K23yJFSq+R8wh3mTGaV8LFyVMu8vompuIhCBl9n
         A3Nw+ttHTJzi+CRnUiQMY5wla2hriscWN1lHw=
MIME-Version: 1.0
In-Reply-To: <c4e36d110908111410y29b922ceod6871fda2514f6e6@mail.gmail.com>
References: <c4e36d110908110542l3de51aaepcbd62c84b9848f2b@mail.gmail.com>
	 <alpine.DEB.1.10.0908111032110.30494@gentwo.org>
	 <c4e36d110908110752x253e30epb00cc71f4683052b@mail.gmail.com>
	 <alpine.DEB.1.10.0908111056550.30494@gentwo.org>
	 <c4e36d110908110832y21fba830ub8804613df571228@mail.gmail.com>
	 <20090811154853.GF2763@sgi.com>
	 <c4e36d110908111410y29b922ceod6871fda2514f6e6@mail.gmail.com>
Date: Thu, 13 Aug 2009 00:16:00 +0200
Message-ID: <c4e36d110908121516u504809e9y537e9babfa95df1d@mail.gmail.com>
Subject: Re: System freeze on reboot - general protection fault
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Robin Holt <holt@sgi.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Jesper Dangaard Brouer <hawk@comx.dk>,
       Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/11 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
> 2009/8/11 Robin Holt <holt@sgi.com>:
>> On Tue, Aug 11, 2009 at 05:32:16PM +0200, Zdenek Kabelac wrote:
>>> 2009/8/11 Christoph Lameter <cl@linux-foundation.org>:
>>> > On Tue, 11 Aug 2009, Zdenek Kabelac wrote:
>>> >
>>> >> Well - I've tried to switch from  'slub' allocator to  old 'slab'
>>> >> allocator and the problem is gone - shutdown goes without any problem.
>>> >>
>>> >> So it's probably related to 'slub' allocator only?
>>> >
>>> > The slab allocator does not have all the diagnostics of slub. The issue
>>> > may simply not be detected in slab. If you switch off diagnostics in slub
>>> > then everything will seem to work fine as well. But we need to figure out
>>> > what is going wrong here.
>>>
>>> Hmm - but there are few things -
>>>
>>> My machine runs  Fedora Rawhide. If I run the same kernel within KVM
>>> running Debian unstable I could easily reboot this guest machine
>>> without any problems.
>>>
>>> Also if I boot Rawhide only to single mode - I could also reboot
>>> machine without this oops.
>>> The problem seems to be - when I do full machine startup to the
>>> multiuser runlevel 3
>>
>> Try booting all the way and recording you output from lsmod.  Reboot
>> single user mode and modprobe each of the modules in that original lists.
>> Test shutdown from single user mode.  This might identify if it is one
>> of your loaded modules.  If so, effectively bisect the modprobes until
>> you find the offending module(s).
>>
>
>
> Ok - it appeared to be more complex - when I've been trying to get
> this oops on my laptop while not being connected via wired net - but
> to not bother here with details - the result is
>
> That if I remove nf_conntrack_ipv4.ko  - so it can not be loaded - the
> problem is gone.
> So it looks like the memory problem is related to netfiltering - there
> are multiple modules loaded as dependecy becuase of this - so it's
> hard to say exactly which module of them makes the trouble.
>
> I've checked for some recent commits in this area - and they seem to
> be actually important
> (i.e 941297f443f871b8c3372feccf27a8733f6ce9e9  16.Jul)
>
> I could probably try to revert some of them - but if someone has some
> ideas what could make these problems ?
>
> I've added authors of some recent conntrack commits to Cc: - maybe
> they might know?

I've tested v2.6.30 - and it's crashing in the same way - so any other
starting point where slub has the same detection mechanism and
conntrack module should be working reliable ?

Zdenek
