Return-Path: <linux-kernel-owner+w=401wt.eu-S1759864AbZEHCig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759864AbZEHCig (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 22:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753230AbZEHCi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 22:38:26 -0400
Received: from tundra.namei.org ([65.99.196.166]:53158 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662AbZEHCi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 22:38:26 -0400
Date: Fri, 8 May 2009 12:37:30 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Adam Langley <agl@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       markus@google.com, linux-security-module@vger.kernel.org
Subject: Re: [RFC 1/1] seccomp: Add bitmask of allowed system calls.
In-Reply-To: <20090507221447.GE28770@elte.hu>
Message-ID: <alpine.LRH.2.00.0905081208480.2761@tundra.namei.org>
References: <396556a20805301217k293e5718h6bbf02b234897235@europa> <20090507221447.GE28770@elte.hu>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 May 2009, Ingo Molnar wrote:

> > In general, I believe that ftrace based solutions cannot safely 
> > validate arguments which are in user-space memory when multiple 
> > threads could be racing to change the memory between ftrace and 
> > the eventual copy_from_user. Because of this, many useful 
> > arguments (such as the sockaddr to connect, the filename to open 
> > etc) are out of reach. LSM hooks appear to be the best way to 
> > impose limits in such cases. (Which we are also experimenting 
> > with).
> 
> That assessment is incorrect, there's no difference between safety 
> here really.
> 
> LSM cannot magically inspect user-space memory either when multiple 
> threads may access it. The point would be to define filters for 
> system call _arguments_, which are inherently thread-local and safe.

LSM hooks are placed so that they can access objects safely, e.g. after 
copy_from_user() and with all apropriate kernel locks for that object 
held, and also with all security-relevant information available for the 
particular operation.

You cannot do this with system call interception: it's an inherently racy 
and limited mechanism (and very well known for being so).

I'm concerned that we're seeing yet another security scheme being designed 
on the fly, without a well-formed threat model, and without taking into 
account lessons learned from the seemingly endless parade of similar, 
failed schemes.

Please refer to (for example):

- "Traps and Pitfalls: Practical Problems in System Call Interposition 
  Based Security Tools" by Tal Garfinkel.

    http://www.stanford.edu/~talg/papers/traps/abstract.html

- "Exploiting Concurrency Vulnerabilities in System Call Wrappers" by 
  Robert Watson.

    http://www.watson.org/~robert/2007woot/




-- 
James Morris
<jmorris@namei.org>
