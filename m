Return-Path: <linux-kernel-owner+w=401wt.eu-S1755832AbZGGEkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832AbZGGEkG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 00:40:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbZGGEjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 00:39:55 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:43125 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbZGGEjz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 00:39:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=jeKdSvj4W0Xs8YLCPhTFnQ+2cmaNk7HViZmIIQiPlcKI9Qb8YWUuTeYF8fmfy90Cjk
         s5tWgqb8IW8OihiJVpKMpBEh1nrxNq0w5S4KSaJf4Sevb7hk6JiqGDMvWXnU3j1OCNMf
         NTyKcQCp63IWfXAJV7ItIAoiY39wOJ2uUcTw8=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Albert ARIBAUD <albert.aribaud@free.fr>
Subject: Re: PROPOSAL: extend pipe() to support NULL argument.
Date: Tue, 7 Jul 2009 06:43:56 +0200
User-Agent: KMail/1.8.2
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Changli Gao <xiaosuo@gmail.com>,
       Amerigo Wang <xiyou.wangcong@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20090703015554.GB5880@cr0.nay.redhat.com> <412e6f7f0907030259m5556ee2fobbb58d377bce4d17@mail.gmail.com> <4A4DDD54.9030206@free.fr>
In-Reply-To: <4A4DDD54.9030206@free.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200907070643.56394.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 July 2009 12:28, Albert ARIBAUD wrote:
> Changli Gao a écrit :
> 
> > Yea, in many cases, max fd number must be enlarged. More fds means
> > more memory. Although memory is cheaper today, we have to do our best
> > to save money.
> 
> Sorry for interrupting, but I don't see how pipe could return a single fd, 
> considering there are two (partly) independent ends, each being read (resp. 
> written) in their own time, and an fd has only one "current read/write 
> position" IIUC.
> 
> If the proposal is to have two independent positions (one for reads and one 
> for writes) for a single fd, then I am not sure the gain in the number of 
> fds used is worth the loss in the increased size of the fd structure.
> 
> Am I missing something?

As I understand it, the proposal is to make pipe(NULL) return a fd,
which can be read from and written to. Whatever you write
is remembered, and can be retrieved by reads later.

standard pipe(two_fds) returns two fds. One is only used for writes.
Another is only used for reads. Which may be wasteful in some
situations (like, if you have thousands of pipes).

There is no trick I know of which may be used to "combine"
these two fds into one, close second one and thus save one fd table slot.

-- 
vda
