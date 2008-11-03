Return-Path: <linux-kernel-owner+w=401wt.eu-S1754925AbYKCIHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925AbYKCIHu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 03:07:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754548AbYKCIHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 03:07:43 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:21823 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543AbYKCIHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 03:07:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=MTv/+DmpXk5hA3YelZ/qePnGM+boza0KxWoCgQ0jF1r4rRxSpNPR314MvM7Eyqxo1M
         O0+sZv5TKdEglgMB4M4QtRXuHcw2B0OX72q9OEfE77V8Kf0wRhtFV8mmvUA6FaB1fC7W
         hUu7Turp9mSqhAoWsFBpMs7SLHP8Ou769Qf6g=
Message-ID: <b2cc26e40811030007w48c3e632v219b72fec1139b40@mail.gmail.com>
Date: Mon, 3 Nov 2008 09:07:40 +0100
From: "Olaf van der Spek" <olafvdspek@gmail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: epoll behaviour after running out of descriptors
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0811021445260.9451@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b2cc26e40811010938k3864c48j45ce55af09516302@mail.gmail.com>
	 <Pine.LNX.4.64.0811021047300.9451@alien.or.mcafeemobile.com>
	 <b2cc26e40811021051kc748db3x44231dc0c085a8d6@mail.gmail.com>
	 <Pine.LNX.4.64.0811021117050.9451@alien.or.mcafeemobile.com>
	 <b2cc26e40811021120p1fa19892m4be6e00785b79289@mail.gmail.com>
	 <Pine.LNX.4.64.0811021122530.9451@alien.or.mcafeemobile.com>
	 <b2cc26e40811021241t17a4fd02k32234b9e6b578b3b@mail.gmail.com>
	 <Pine.LNX.4.64.0811021258250.9451@alien.or.mcafeemobile.com>
	 <b2cc26e40811021417o38f9b171ka669961d93b9025c@mail.gmail.com>
	 <Pine.LNX.4.64.0811021445260.9451@alien.or.mcafeemobile.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 2, 2008 at 11:49 PM, Davide Libenzi <davidel@xmailserver.org> wrote:
> At the time of the first EMFILE, you've filled up the fd space, but not
> the kernel listen backlog. Additions to the backlog, triggers new events,

Shouldn't ET only fire again *after* you drained the queue? When
accept returns EMFILE, you did not drain the queue.

> that you see after the first EMFILE. At a given point, the backlog is
> full, so no new half connections are dropped in there, so no new events
> are generated.

The backlog is 128 entries though, I don't see that many EMFILEs.

> Again, sleeping on (EMFILE && ET) is bad mojo,

It's not always best to free up descriptors right away.

> and nowhere is written that
> events should be generated in the EMFILE->no-EMFILE transitions.

That's true, but I'm saying that this might be handy to have.
