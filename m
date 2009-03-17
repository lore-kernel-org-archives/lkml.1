Return-Path: <linux-kernel-owner+w=401wt.eu-S1756261AbZCQVWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261AbZCQVWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 17:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754928AbZCQVWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 17:22:03 -0400
Received: from ozlabs.org ([203.10.76.45]:39467 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754855AbZCQVWB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 17:22:01 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [PATCH] module: fix refptr allocation and release order
Date: Wed, 18 Mar 2009 07:51:55 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "systemtap-ml" <systemtap@sources.redhat.com>
References: <200903171250.16585.rusty@rustcorp.com.au> <49BF17F4.7040908@cosmosbay.com>
In-Reply-To: <49BF17F4.7040908@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903180751.55665.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 March 2009 13:54:36 Eric Dumazet wrote:
> Rusty Russell a écrit :
> > From: Masami Hiramatsu <mhiramat@redhat.com>
> > 
> > Impact: fix ref-after-free crash on failed module load
> > 
> > Fix refptr bug: Change refptr allocation and release order not to access a module
> > data structure pointed by 'mod' after freeing mod->module_core.
> > This bug will cause kernel panic(e.g. failed to find undefined symbols).
> > 
> > This bug was reported on systemtap bugzilla.
> > http://sources.redhat.com/bugzilla/show_bug.cgi?id=9927
> > 
> > Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> > Cc: Eric Dumazet <dada1@cosmosbay.com>
> > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> 
> My original patch did not have this problem, because I used a local variable
> to hold refptr.
> 
> http://www.archivum.info/linux-kernel@vger.kernel.org/2008-05/msg07400.html
> 
> A simpler patch could just use a local variable again, since we are very
> late in rc phase ?

Right, it was my mistake.  But the extra #ifdef is still ugly: moving the code
is a larger patch, but it's not complicated.

Thanks,
Rusty.
