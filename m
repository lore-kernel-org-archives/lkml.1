Return-Path: <linux-kernel-owner+w=401wt.eu-S1760218AbXJ2S4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760218AbXJ2S4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 14:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757226AbXJ2S4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 14:56:04 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:58006 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758736AbXJ2S4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 14:56:01 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 29 Oct 2007 11:55:58 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: David Schwartz <davids@webmaster.com>
cc: dada1@cosmosbay.com, Michael Kerrisk <mtk.manpages@googlemail.com>,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: epoll design problems with common fork/exec patterns
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKAEHCHNAC.davids@webmaster.com>
Message-ID: <Pine.LNX.4.64.0710291147180.3387@alien.or.mcafeemobile.com>
References: <MDEHLPKNGKAHNMBLJOLKAEHCHNAC.davids@webmaster.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Oct 2007, David Schwartz wrote:

> 
> Eric Dumazet wrote:
> 
> > Events are not necessarly reported "by descriptors". epoll uses an opaque
> > field provided by the user.
> >
> > It's up to the user to properly chose a tag that will makes sense
> > if the user
> > app is playing dup()/close() games for example.
> 
> Great. So the only issue then is that the documentation is confusing. It
> frequently uses the term "fd" where it means file. For example, it says:
> 
>               Q1     What  happens  if  you  add  the  same fd to an
> epoll_set
>                      twice?
> 
>               A1     You will probably get EEXIST.  However,  it  is
> possible
>                      that  two  threads  may  add the same fd twice. This is
> a
>                      harmless condition.
> 
> This gives no reason to think there's anything wrong with adding the same
> file twice so long as you do so through different descriptors. (One can
> imagine an application that does this to segregate read and write operations
> to avoid a race where the descriptor is closed from under a writer due to
> handling a fatal read error.) Obviously, that won't work.

I agree, that is confusing. However, you can safely add two different file 
descriptors pointing to the same file*, with different event masks, and 
that will work as expected.




> And this part:
> 
>               Q6     Will  the  close of an fd cause it to be removed from
> all
>                      epoll sets automatically?
> 
>               A6     Yes.
> 
> This is incorrect. Closing an fd will not cause it to be removed from all
> epoll sets automatically. Only closing a file will. This is what caused the
> OP's confusion, and it is at best imprecise and, at worst, flat out wrong.

OTOH you cannot list *every* possible scenario in a man page, otherwise 
you end up writing a book instead of a man page. I will try to find some 
time with Michael to refine the man page.



> PS: It is customary to trim individuals off of CC lists when replying to a
> list when the subject matter of the post is squarely inside the subject of
> the list. If the person CC'd was interested in the list's subject, he or she
> would presumably subscribe to the list. Not everyone wants two copies of
> every post. Not everyone wants a personal copy of every sub-thread that
> results from a post they make. In the past few years, I've received
> approximately an equal number of complaints about trimming CC's on posts to
> LKML and not trimming CC's on such posts.

Does anyone that in 2007 still did not manage to find a way to avoid dups 
in hitting his mailbox, deserve any consideration at all?
OTOH many ppl, like myself, uses To and Cc header to direct email to 
proper folders, where they are treated with a different level of 
attention. And your stripp-all-headers mania screws that up badly.



- Davide


