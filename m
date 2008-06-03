Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbYFCH3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbYFCH3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 03:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbYFCH3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 03:29:14 -0400
Received: from main.gmane.org ([80.91.229.2]:42892 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228AbYFCH3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 03:29:13 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: [Question] about modules/inline benefits
Date: Tue, 03 Jun 2008 08:28:59 +0100
Message-ID: <g22rrs$6vp$1@ger.gmane.org>
References: <4844C4D9.8030502@gawab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: cpc1-cwma5-0-0-cust137.swan.cable.ntl.com
User-Agent: KNode/0.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Madru wrote:

> I've been compiling linus' git kernel (recompiling every -rc). I usually
> compile many features/drivers as modules. I was wondering what the
> benefits/drawbacks there are for modules compared to inlining.

I mentioned one difference on the kernel-testers list (
http://article.gmane.org/gmane.linux.kernel.kernel-testers/42 ) not so long
ago - inlining everything leads to a slightly quicker build and you can
skip the mkinitrd step if your system is simple enough. It also means you
can get away with only having to move one file to install a kernel (e.g. on
another machine).

I suspect that inlining leads to a fractionally faster boot but not so that
one would really notice.

Some distro userspace startup scripts become grouchy if they can't load 
particular modules.

Modules can sometimes be unloaded which can workaround other problems (e.g.
I have a wifi device that is broken after resuming from hibernate but when
it's a module the distro scripts will unload / reload it). Supposedly there
are no guarantees that all modules will have done perfect clean up when
unloaded though.

Modules can be blacklisted preventing them from being loaded in the first
place.

Modules allow you to support more hardware as there is a maximum size of the
core kernel image.

A module can be rebuilt without having to relink the whole kernel. This can
be a time saver.

Some features will only be selectable if something that has a choice of
being a module or inlined is inlined.

Some features are only available as modules.

Having module loading turned off can be seen as a step towards hardening the
kernel against certain types of rootkit (you would have to do other things
like locking down /dev/kmem though and it won't stop people ascending to
root via exploits but might mitigate the after effects).

Building things as modules versus building them inline can sometimes expose
bugs due to races not seen when using the other method.

-- 
Sitsofe | http://sucs.org/~sits/

