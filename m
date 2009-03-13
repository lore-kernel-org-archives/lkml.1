Return-Path: <linux-kernel-owner+w=401wt.eu-S1759916AbZCMWer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759916AbZCMWer (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 18:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757343AbZCMWei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 18:34:38 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:42279 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbZCMWeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 18:34:37 -0400
X-AuthUser: davidel@xmailserver.org
Date: Fri, 13 Mar 2009 15:34:05 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Jeff Moyer <jmoyer@redhat.com>,
       Avi Kivity <avi@redhat.com>, linux-aio <linux-aio@kvack.org>,
       zach.brown@oracle.com, Benjamin LaHaise <bcrl@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH] fs: fput() can be called from interrupt context
In-Reply-To: <alpine.DEB.1.10.0903120625340.6040@makko.or.mcafeemobile.com>
Message-ID: <alpine.DEB.1.10.0903131533010.13254@makko.or.mcafeemobile.com>
References: <x49bpsaelwa.fsf@segfault.boston.devel.redhat.com> <49B54143.1010607@redhat.com> <x49sklmd1fo.fsf@segfault.boston.devel.redhat.com> <49B57CB0.5020300@cosmosbay.com> <49B875F7.3030305@cosmosbay.com> <49B87CFE.4000701@cosmosbay.com>
 <49B89B22.7080303@cosmosbay.com> <20090311224712.fb8db075.akpm@linux-foundation.org> <49B8A75E.6040409@cosmosbay.com> <20090311233903.f036027a.akpm@linux-foundation.org> <alpine.DEB.1.10.0903120625340.6040@makko.or.mcafeemobile.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Mar 2009, Davide Libenzi wrote:

> On Wed, 11 Mar 2009, Andrew Morton wrote:
> 
> > > Take the time to check how fs/aio.c handle the fput(req->ki_filp) case
> > > (or read my 2nd patch, it should spot the thing)
> > 
> > Well yes, a kludge like that seems a bit safer.
> > 
> > It's somewhat encouraging that we're apparently already doing fput()
> > from within keventd (although how frequently?).  There might be
> > problems with file locking, security code, etc from doing fput() from
> > an unexpected thread.  And then there are all the usual weird problem
> > with using the keventd queues which take a long time to get discovered.
> 
> Would it be a huge problem, performance-wise, to stop making ->f_count 
> tricks in __aio_put_req, and always offload to fput_work the task of 
> releasing the requests?
> If that's a huge problem, IMO the lower impact fix would be to use 
> aio_fput_routine to loop into a second list, releasing the eventual 
> eventfd file*. There's no need, IMO, to turn the whole fput() into 
> IRQ-callable just for this case, when we can contain it into the 
> particular KAIO+eventfd usage.

Eric, are you working on this or should I? I missed where the conversation 
between you and Andrew is, at this point, WRT this issue.


- Davide


