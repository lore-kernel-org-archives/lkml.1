Return-Path: <linux-kernel-owner+w=401wt.eu-S1755990AbYBJNTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990AbYBJNTV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 08:19:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbYBJNTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 08:19:09 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:13715 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbYBJNTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 08:19:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tr6kwyxRWSVnfyD+z1pAXEz+ZN/CbOmQinzDFnIdVpUvLnR6np5/PJZl1/WcU8NJClL1+xy+TvmQltIVl7/+TP/aBZzC8YkBUK1AaYDZ/wfkxWBfE+ag1Mz6Cggnv3LWb4GHg7fAjyOR43Vw6aOmPjzdBZKdkxQHM1YFr26IaZw=
Message-ID: <9a8748490802100519h5921ce61pd90d6bec604b5c87@mail.gmail.com>
Date: Sun, 10 Feb 2008 14:19:06 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Marcin Slusarz" <marcin.slusarz@gmail.com>
Subject: Re: [3/6] kgdb: core
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@zip.com.au>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Jason Wessel" <jason.wessel@windriver.com>
In-Reply-To: <20080210124629.GA12200@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080210071331.GC3851@elte.hu> <20080210124629.GA12200@joi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2008, Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
> On Sun, Feb 10, 2008 at 08:13:31AM +0100, Ingo Molnar wrote:
...
> > +
> > +             if (CACHE_FLUSH_IS_SAFE) {
> > +                     if (current->mm && addr < TASK_SIZE) {
> > +                             flush_cache_range(current->mm->mmap_cache,
> > +                                             addr, addr + BREAK_INSTR_SIZE);
> > +                     } else {
> > +                             flush_icache_range(addr, addr +
> > +                                             BREAK_INSTR_SIZE);
> > +                     }
> > +             }
> unneeded braces (here and in many other places)
>

While they are not strictly needed, I for one would argue they should
probably stay.

if (foo)
  bar();

is not always safe in case bar() is a macro.

if (foo) {
  bar();
}

is always safe and is more robust when the code gets changed later
since you don't accidentally end up with someone mistakenly turning it
into

if (foo)
  bar();
  baz();


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
