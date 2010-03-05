Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab0CEQVQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 11:21:16 -0500
Received: from outbound-mail-158.bluehost.com ([67.222.39.38]:41495 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752640Ab0CEQVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 11:21:14 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=IOqns+QfDQN89hCmCMon3dhqGI7+F0QeUZw0083UwNab7o742nWojzwzi3Qj1vWOWdLNNohxp6G7m6Fz732O88l9lSuyynUiFrya1hGvBJN70VhxgLFKAXxR6NjY8OXE;
Date: Fri, 5 Mar 2010 08:21:27 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ben Skeggs <skeggsb@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@gmail.com>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
Message-ID: <20100305082127.5a4e3429@jbarnes-piketon>
In-Reply-To: <20100305074407.GC19703@elte.hu>
References: <alpine.LFD.2.00.1003041047400.3751@localhost.localdomain>
	<20100304105624.70fe845e@jbarnes-piketon>
	<alpine.LFD.2.00.1003041101390.3751@localhost.localdomain>
	<21d7e9971003041125x1aee3b3ew1e407ca6695e10fc@mail.gmail.com>
	<alpine.LFD.2.00.1003041142250.3751@localhost.localdomain>
	<21d7e9971003041406n53d9cae0h53374abf3dca494e@mail.gmail.com>
	<alpine.LFD.2.00.1003041554490.3751@localhost.localdomain>
	<1267748927.3496.6.camel@nisroch>
	<20100305064955.GA6453@elte.hu>
	<84144f021003042306w2e017efbva2be364c1c4980a7@mail.gmail.com>
	<20100305074407.GC19703@elte.hu>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Mar 2010 08:44:07 +0100
Ingo Molnar <mingo@elte.hu> wrote:
> It's a bit as if we split up the kernel into 'microkernel' components, did a 
> VFS ABI, MM ABI, drivers ABI, scheduler ABI, networking ABI and arch ABIs, and 
> then tried to develop them as separate components.
> 
> If we did then then Linux kernel development would slow down massively while 
> in reality everyone would _still_ have to have the latest and greatest source 
> checked out to do some real development work and to be able to implement 
> features that affect the whole kernel ...
> 
> Linux would become an epic fail of historic proportions if we ever did that.

This is a very good point, and something we've been wrestling with in
the gfx community.  Awhile back we separated the X drivers from the X
core; I feel this was a mistake for the reasons you mention above.
It's just plain harder to fix issues when you have to rev the ABI with
every change, make sure both the old/new and new/old combinations work,
and generally improve things like we do inside of Linux.

> [*]  I realize that it's possibly hard for Xorg to merge with mesa and the 
>      kernel for license reasons, but my technical observation still stands.

No we don't need to merge them fortunately.  With GEM and KMS we've
pushed two major bits of functionality into the kernel; bits that were
badly split between all portions of the stack before.  With EGL, we can
push a lot of what X did into Mesa.  There are even some projects to
make a very thin X driver or separate display server sit directly on
top of Mesa + EGL, unifying things further.  So I really think things
are getting better here, not worse (the nouveau issue here aside).

-- 
Jesse Barnes, Intel Open Source Technology Center
