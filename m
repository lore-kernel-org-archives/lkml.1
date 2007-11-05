Return-Path: <linux-kernel-owner+w=401wt.eu-S1754677AbXKEGmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677AbXKEGmt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 01:42:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbXKEGmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 01:42:40 -0500
Received: from mail8.dotsterhost.com ([66.11.233.1]:49352 "HELO
	mail8.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751170AbXKEGmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 01:42:40 -0500
Message-ID: <472EBB5A.8030402@crispincowan.com>
Date: Sun, 04 Nov 2007 22:42:34 -0800
From: Crispin Cowan <crispin@crispincowan.com>
Organization: Crispin's Labs
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: simon@fire.lp0.eu, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to static
 interface
References: <20071022210956.31f7bbcf@laptopd505.fenrus.org>	<20071023051642.GA3908@sequoia.sous-sol.org>	<471E9260.6000704@goop.org>	<20071023220649.5a76af82@laptopd505.fenrus.org>	<55615.simon.1193226629@5ec7c279.invalid> <200710272308.GCH56742.OHLVMSFFFQJOtO@I-love.SAKURA.ne.jp>
In-Reply-To: <200710272308.GCH56742.OHLVMSFFFQJOtO@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> I think there are two other problems regarding LSM.
>
> (1) There is only one "struct security_ops" structure in the system.
>
> (2) There is only one "void *security" field in "struct task_struct".
>
>
> Years ago, there was only one MAC implementation (i.e. SELinux)
> in the mainline kernel.
> But now, there are many MAC (or access control/tracking) implementations
> waiting for inclusion into the mainline kernel.
> The competition for occupying "struct security_ops" has started.
>
> My idea is that, why not create chains of "struct security_ops"
> (i.e. linked list of "struct security_ops")
> and allow choosing which chain to use for per a "struct task_struct" basis
> (i.e. add "struct security_ops" to "struct task_struct").
>   
That idea was in the Stacker module, and it was tabled until there is
more than one upstream LSM. In particular, it requires 2 or more LSMs
that actually make sense to stack together. IMHO TOMOYO/AppArmor/SELinux
are all exclusive of one another (in a running kernel) and real stacking
is still pending useful component intrusion prevention modules. Such
modules can be built, they just have not yet been built.

> TOMOYO Linux is having difficulty that TOMOYO Linux unlikely be able to use
> "struct security_ops" since SELinux is occupying it.
>   
Just disable SELinux and load TOMOYO. Oh, you can't because someone has
made modules not be loadable :(  Hmmm, perhaps someone could fix that by
reverting the static interface patch ... :)

> May be we should consider stackable LSM again?
>   
Exactly. Stacker was shelved, so to speak :) because of the lack of
in-kernel modules. Soon it will be time to reconsider that.

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin
CEO, Mercenary Linux		   http://mercenarylinux.com/
	       Itanium. Vista. GPLv3. Complexity at work

