Return-Path: <linux-kernel-owner+w=401wt.eu-S1754829AbXJ1VE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbXJ1VE4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 17:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbXJ1VEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 17:04:49 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:2051 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbXJ1VEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 17:04:48 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <dada1@cosmosbay.com>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: epoll design problems with common fork/exec patterns
Date: Sun, 28 Oct 2007 14:04:49 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKAEHCHNAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
Importance: Normal
In-Reply-To: <47245784.10209@cosmosbay.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Sun, 28 Oct 2007 14:05:43 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Sun, 28 Oct 2007 14:05:44 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Eric Dumazet wrote:

> Events are not necessarly reported "by descriptors". epoll uses an opaque
> field provided by the user.
>
> It's up to the user to properly chose a tag that will makes sense
> if the user
> app is playing dup()/close() games for example.

Great. So the only issue then is that the documentation is confusing. It
frequently uses the term "fd" where it means file. For example, it says:

              Q1     What  happens  if  you  add  the  same fd to an
epoll_set
                     twice?

              A1     You will probably get EEXIST.  However,  it  is
possible
                     that  two  threads  may  add the same fd twice. This is
a
                     harmless condition.

This gives no reason to think there's anything wrong with adding the same
file twice so long as you do so through different descriptors. (One can
imagine an application that does this to segregate read and write operations
to avoid a race where the descriptor is closed from under a writer due to
handling a fatal read error.) Obviously, that won't work.

And this part:

              Q6     Will  the  close of an fd cause it to be removed from
all
                     epoll sets automatically?

              A6     Yes.

This is incorrect. Closing an fd will not cause it to be removed from all
epoll sets automatically. Only closing a file will. This is what caused the
OP's confusion, and it is at best imprecise and, at worst, flat out wrong.

DS

PS: It is customary to trim individuals off of CC lists when replying to a
list when the subject matter of the post is squarely inside the subject of
the list. If the person CC'd was interested in the list's subject, he or she
would presumably subscribe to the list. Not everyone wants two copies of
every post. Not everyone wants a personal copy of every sub-thread that
results from a post they make. In the past few years, I've received
approximately an equal number of complaints about trimming CC's on posts to
LKML and not trimming CC's on such posts.


