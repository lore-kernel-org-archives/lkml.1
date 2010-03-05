Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab0CEQLo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 11:11:44 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33916 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753605Ab0CEQLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 11:11:43 -0500
Date: Fri, 5 Mar 2010 16:13:11 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Luca Barbieri <luca.barbieri@gmail.com>
Cc: Daniel Stone <daniel@fooishbar.org>, David Miller <davem@davemloft.net>,
       skeggsb@gmail.com, airlied@linux.ie, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, dri-devel@lists.sf.net, mingo@elte.hu,
       torvalds@linux-foundation.org
Subject: Re: [git pull] drm request 3
Message-ID: <20100305161311.656711e0@lxorguk.ukuu.org.uk>
In-Reply-To: <ff13bc9a1003050756rca44e03uffbfa3090f96e0ac@mail.gmail.com>
References: <20100305123834.0d9c6277@lxorguk.ukuu.org.uk>
	<20100305.063718.211238119.davem@davemloft.net>
	<20100305151754.GB2505@tempa>
	<20100305.072612.186421758.davem@davemloft.net>
	<20100305154009.GC2505@tempa>
	<ff13bc9a1003050756rca44e03uffbfa3090f96e0ac@mail.gmail.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Mar 2010 16:56:10 +0100
Luca Barbieri <luca.barbieri@gmail.com> wrote:

> It seems to me that Linus' technical argument is indeed being mostly ignored.
> 
> While breaking the ABI is unfortunate, the real problem that Linus
> complained about is that you can't install several userspace versions
> side-by-side.

I think you need to be clearer about that. Your distribution packaging
may not support that out of the box. There are a variety of ways to do
almsot all of this including having entire parallel X installs for
development work.

All the X builds are modular, all the modular builds support --prefix=
with their autogen script. ld.so supports LD_LIBRARY_PATH and the shells
support PATH variables.

You can replace all or almost any part of X quite easily. There is also a
mechanism for versioning within DRM for a lot of stuff, and drivers use
flags to make it work nicely except for devel code (which is what Nouveau
is)

The fundamental problem you can't solve by versioning though is the exact
one here. A new kernel that requires version X of a driver won't help if
the newest version you have is X - 1.

Yeah perhaps Fedora should have pushed an update that was smart enough to
handle the Nouveau old/new ABI before the patch went upstream. Hindsight
is an exact science.

Alan
