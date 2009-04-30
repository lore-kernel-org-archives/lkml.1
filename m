Return-Path: <linux-kernel-owner+w=401wt.eu-S1761954AbZD3NmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761954AbZD3NmY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 09:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753656AbZD3NmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 09:42:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:37054 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbZD3NmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 09:42:13 -0400
Date: Thu, 30 Apr 2009 09:42:12 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 0/3] removing unwanted module configs
In-Reply-To: <20090430132605.GA5289@elte.hu>
Message-ID: <alpine.DEB.2.00.0904300932380.20374@gandalf.stny.rr.com>
References: <20090430030821.523327994@goodmis.org> <20090430071830.GC16737@elte.hu> <alpine.DEB.2.00.0904300908110.20374@gandalf.stny.rr.com> <20090430132605.GA5289@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 30 Apr 2009, Ingo Molnar wrote:
> 
> CONFIG_IKCONFIG=y would be a one-off thing, only to make the whole 
> concept self-hosting. If i boot a localyesconfig kernel, how does 
> the script figure out what is built in? It cannot, unless i provide 
> it the precise .config - but often that wont be provided. The script 
> should clone the environment it is running in really.

Does IKCONFIG get loaded in the running kernel if IKCONFIG_PROC is not 
set, or does it just sit in the vmlinux file.

Since this option can also be used for helping embedded developers (I used 
it for that) I would not want to bloat the kernel with running a script 
that is suppose to minimize it. But if IKCONFIG && !IKCONFIG_PROC does not 
add more data to the kernel, then I would be happy to turn it on by 
default.

I see I can use scripts/extract-ikconfig to get the config from the 
current image. Now which image should it try?

/boot/vmlinuz-`uname -r`
./vmlinux

I could have it first try /proc/config.gz and if it does not find it then
try the /boot kernel, if it does not find it or does not find a config 
file in it, it would then try ./vmlinux file. If it does not find the file 
or the config then it would just use the local .config.

-- Steve

