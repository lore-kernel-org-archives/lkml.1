Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab0CEQid (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 11:38:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51542 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752194Ab0CEQib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 11:38:31 -0500
Date: Fri, 5 Mar 2010 08:30:38 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Daniel Stone <daniel@fooishbar.org>
cc: "Carlos R. Mafra" <crmafra2@gmail.com>, Ben Skeggs <skeggsb@gmail.com>,
       Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, dri-devel@lists.sf.net,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Making Xorg easier to test (was Re: [git pull] drm request 3)
In-Reply-To: <20100305161143.GG2505@tempa>
Message-ID: <alpine.LFD.2.00.1003050819490.3788@localhost.localdomain>
References: <21d7e9971003041125x1aee3b3ew1e407ca6695e10fc@mail.gmail.com> <alpine.LFD.2.00.1003041142250.3751@localhost.localdomain> <21d7e9971003041406n53d9cae0h53374abf3dca494e@mail.gmail.com> <alpine.LFD.2.00.1003041554490.3751@localhost.localdomain>
 <1267748927.3496.6.camel@nisroch> <20100305064955.GA6453@elte.hu> <84144f021003042306w2e017efbva2be364c1c4980a7@mail.gmail.com> <20100305074407.GC19703@elte.hu> <20100305100030.GA4970@Pilar.aei.mpg.de> <alpine.LFD.2.00.1003050726520.3788@localhost.localdomain>
 <20100305161143.GG2505@tempa>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 5 Mar 2010, Daniel Stone wrote:
> 
> FWIW, Option "ModulePath" in xorg.conf lets you more or less do this;
> the usual approach is to install your new server + drivers into a
> separate prefix.

The thing is, Xorg has - and I think for _very_ good reasons - deprecated 
using xorg.conf at all. So most people don't even have one (I certainly 
don't), and wouldn't know how to create one in the first place.

And yeah, I used to happily edit timing lines and make up non-standard 
modes for my monitor, but I have to admit that I never _ever_ want to 
touch that file ever again. Last time I tried to, it was to set DPI to be 
something sane, but these days X gets even that right automatically, and 
no longer does the insane "set DPY by size of the screen" thing any more.

And I think all of the reasons xorg.conf is basically being deprecated are 
valid for this case too. Switching between kernels is - in this case, due 
to the whole API change - effectively the same as switching the graphics 
card in the machine, but without even the ability to _name_ the cards and 
share a xorg.conf for the two cases (not that I think that you could do 
different ModulePath's per display anyway).

So yeah, you could "switch between kernels, start out in init 3, edit 
xorg.conf appropriately, switch to init 5", but once you start doing that, 
you might as well just switch a symlink around instead - it's easier.

So I don't think xorg.conf is a help.

				Linus
