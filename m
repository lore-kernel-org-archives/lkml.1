Return-Path: <linux-kernel-owner+w=401wt.eu-S1757630AbXERNHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757630AbXERNHm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 09:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754960AbXERNHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 09:07:35 -0400
Received: from hobbit.corpit.ru ([81.13.94.6]:22562 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754443AbXERNHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 09:07:34 -0400
Message-ID: <464DA514.8030205@msgid.tls.msk.ru>
Date: Fri, 18 May 2007 17:07:32 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Anand Jahagirdar <anandjigar@gmail.com>
CC: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: Fork Bombing Attack
References: <25ae38200705170745t4a80e7eer413b3c2bb0c5a327@mail.gmail.com>	 <4051.1179414105@turing-police.cc.vt.edu> <25ae38200705180413s741cac1bw9fe0dc57cecc2a91@mail.gmail.com>
In-Reply-To: <25ae38200705180413s741cac1bw9fe0dc57cecc2a91@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anand Jahagirdar wrote:
[]
>           I found one more interesting thing on the same machine
> having FC6 distribution and Linux Kernel 2.6.18. i have set "ulimit -u
> 100". after setting this limit i tried to execute fork bombing program
> with guest account. after executing it
> 
> expected result:-  guest uesr should not able to fork another single
> process when it reaches to 100 processes count.
> 
> actual result :-  kernel allow me to create another processes without
> giving error. due to this i tried to execute same fork bombing program
> on another terminal with guest account and this fork bombing attack
> killed the box completely and machine needed reboot.

Do you know ulimits are a *process* property, not uid property?

That is, if, in some process of a giving user, you set ulimit value,
it does NOT affect other processes of the same user already running
at the same time, but only new processes forked off of this process
where you've set the limit.  Limits are inheritable from parent to
child, but not the reverse and especially they don't "migrate" to
"brothers" or "brothers-in-law".

> will any please tell me why this is so?

It's because of the way ulimit works - on Linux and on other systems.

When you set limit of number of processes in some session, you can't
fork more processes *in this session* if total number of processes of
this user is >= the limit value you set.  Other sessions are unaffected.

It's unclear what did you mean by ``i have set "ulimit -u 100"''.
Where did you set it?

Note also that when you log in (on a terminal, or over ssh, or using su
command), the limits are usually set to whatever specified for that user
in /etc/security/limits.conf - so for example, if you set a limit and
use su to change uid, your limit is reset.

/mjt
