Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab0CCBav (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 20:30:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50410 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752335Ab0CCBat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 20:30:49 -0500
Date: Tue, 2 Mar 2010 17:29:50 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, zippel@linux-m68k.org, mingo@elte.hu,
       akpm@linux-foundation.org, geert@linux-m68k.org, elendil@planet.nl,
       cloos@jhcloos.com
Subject: Re: [PATCH] kconfig: place git SHA1 in .config output if in SCM
In-Reply-To: <20100303011858.GA17651@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.00.1003021725170.3616@localhost.localdomain>
References: <20100303011858.GA17651@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 2 Mar 2010, Paul E. McKenney wrote:
> +		env = getenv(SRCTREE);
> +		if (env) {
> +			sprintf(cmdline,
> +				"%s/scripts/setlocalversion %s 2> /dev/null",
> +				env, env);
> +			slv = popen(cmdline, "r");

I suspect this does various bad things if there are spaces or special 
characters in $SRCTREE.

It would be a lot safer to uses fork/execve rather than something 
that interprets a shell command line.

Of course, I didn't check that all our old users of SRCTREE are safe 
either, but at least docproc.c (the one I _did_ check) uses 'execvp()' and 
'fopen()' that both take real filenames, not a shell string.

			Linus
