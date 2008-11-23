Return-Path: <linux-kernel-owner+w=401wt.eu-S1752689AbYKWXmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbYKWXmt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 18:42:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751310AbYKWXmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 18:42:42 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:54730 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbYKWXml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 18:42:41 -0500
Date: Sun, 23 Nov 2008 17:43:24 -0600
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Chris Smowton <chris.smowton@cl.cam.ac.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Robust shared memory for unrelated processes
Message-ID: <20081123234324.GF12687@hallyn.com>
References: <4929DC4A.4020905@cl.cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4929DC4A.4020905@cl.cam.ac.uk>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Chris Smowton (chris.smowton@cl.cam.ac.uk):
> Hello all,
>
> First of all, my apologies if this is the wrong list for this suggestion; I 
> haven't posted here before so I might accidentally break some local 
> conventions :)
>
> With that said, my question/suggestion relates to sharing memory between 
> processes which are *not* in a parent-child relationship.
>
> Suppose for simplicity's sake that one wishes to share a sizable piece of 
> memory with a single other process with which one is already in contact 
> (say, by a Unix domain socket).
>
> It seems to me that one cannot do this without introducing the risk of the 
> shared section not being deallocated until the system next boots, for the 
> following reasons:
>
> 1. Suppose I use SysV style SHM. Then I must find a free key, create a 
> section with that key, and communicate that key to my partner process so 
> that he can also open the section. I cannot issue an IPC_RMID during this 
> time, as that will render the key immediately unavailable. If I am 
> SIGKILL'd at any time between creating the section and receiving 
> confirmation that my partner has opened it, the section will persist until 
> reboot. This is a large window of opportunity and a very bad thing.

Ah, but if your app is started in a new IPC namespace, then when the
app dies, the namespace will be released and the section will be freed.

Now both of the processes will need to be started in the same child
ipc namespace, as you currently can't enter an existing ipcns.  If
that is a problem, I'm sure it can be addressed somehow.

-serge
