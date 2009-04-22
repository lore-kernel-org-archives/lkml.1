Return-Path: <linux-kernel-owner+w=401wt.eu-S1753252AbZDVFVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbZDVFVw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 01:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbZDVFVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 01:21:42 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:65280 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878AbZDVFVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 01:21:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=rTZt39mfnXSGjmpu4oWanSKP7zS0rlrElpLVTCWxUTz1mOIEImqHY3ERhY6c8eqpqy
         8sOHZe4m+wu2z/ZtJR4t0kLSSI38SQbIMeJiVZBQYIS7kPKs+BTCdRr/37qkbvIpl0Jp
         q9AS9r8EQJ9zg8zRcQKTN5vFqHieV1N5nzmn0=
Subject: Re: [PATCH 3/3] tracing/filters: disallow newline as delimeter
From: Tom Zanussi <tzanussi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090421101619.GA19660@elte.hu>
References: <49ED8DD2.2070700@cn.fujitsu.com>
	 <49ED8DFD.9070909@cn.fujitsu.com> <20090421095705.GA15448@elte.hu>
	 <49ED9AC2.9000507@cn.fujitsu.com> <20090421100722.GA18486@elte.hu>
	 <49ED9C91.4070201@cn.fujitsu.com>  <20090421101619.GA19660@elte.hu>
Content-Type: text/plain
Date: Wed, 22 Apr 2009 00:21:38 -0500
Message-Id: <1240377698.6711.61.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-21 at 12:16 +0200, Ingo Molnar wrote:
> * Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
> > Ingo Molnar wrote:
> > > * Li Zefan <lizf@cn.fujitsu.com> wrote:
> > > 
> > >> Ingo Molnar wrote:
> > >>> * Li Zefan <lizf@cn.fujitsu.com> wrote:
> > >>>
> > >>>> I guess because user input is often ended with '\n' (like "echo 
> > >>>> xxx"), thus '\n' is used as a delimeter besides ' ', but we can 
> > >>>> just strip tailing spaces.
> > >>> Hm, how about:
> > >>>
> > >>> ( echo 'x'
> > >>>   echo '|| y' ) > filter
> > >>>
> > >>> type of scripts? Shouldnt the parser be permissive in general?
> > >>>
> > >> This patch doesn't forbid this usage: ;)
> > >>
> > >> ( echo 'parent_comm == a'
> > >>   echo '|| parent_comm == b' ) > filter
> > >>
> > >> This patch does forbid this usage:
> > >>
> > >> ( echo 'parent_comm'
> > >>   echo '=='
> > >>   echo 'a' ) > filter
> > > 
> > > Same argument though, no?
> > > 
> > 
> > Then I have no strong opinion on this. I'm fine to drop this patch.
> 
> I've applied the other two - no strong opinion either about this 
> patch. Tom, what do you think? (there's also some new parser in the 
> works i suspect)

I think it works ok as it is, so dropping this patch would be fine with
me.

I am working on a new parser; I'd hoped to have it finished by now, but
I seem to be continually distracted lately. :-(  At this point I have a
parser that basically works; the main thing it still needs and what I'm
working on now is a way to allow it to be easily extended to support
special-case handling for special types e.g. if a predicate field refers
to something that's a dev_t, the user should be able to specify 'device
== /dev/sda' or 'device == sda' or 'device == (8,1)' or 'device == 8:1',
so it should be relatively easy to add that kind of support to the
parser when there's a need for it.

Once that's done, I'll hook it all up and post it as soon as I can, at
the end of the week hopefully...

Tom

> 
> 	Ingo

