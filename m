Return-Path: <linux-kernel-owner+w=401wt.eu-S1754736AbYKBWRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbYKBWRV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 17:17:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752920AbYKBWRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 17:17:12 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:15669 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829AbYKBWRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 17:17:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=td+3/Jt2Z3bffJLazyO2H/eZB4V7GK7pC7b5Ha9E55V2cM+BlAR2GVnE3DtXcuazl0
         6wPF/S1RYIRA6sjX/HYX2hXeRlzfamK1p2cI9KkMAeKIOxWSJRiUtAUQ9z4XeylvLDOC
         62r9EhuHEvxZIJ2vBzorZvrfpYLP60D26uOEQ=
Message-ID: <b2cc26e40811021417o38f9b171ka669961d93b9025c@mail.gmail.com>
Date: Sun, 2 Nov 2008 23:17:07 +0100
From: "Olaf van der Spek" <olafvdspek@gmail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: epoll behaviour after running out of descriptors
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0811021258250.9451@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b2cc26e40811010938k3864c48j45ce55af09516302@mail.gmail.com>
	 <Pine.LNX.4.64.0811021022120.9451@alien.or.mcafeemobile.com>
	 <b2cc26e40811021033r115225e2x4747a17fc2b30256@mail.gmail.com>
	 <Pine.LNX.4.64.0811021047300.9451@alien.or.mcafeemobile.com>
	 <b2cc26e40811021051kc748db3x44231dc0c085a8d6@mail.gmail.com>
	 <Pine.LNX.4.64.0811021117050.9451@alien.or.mcafeemobile.com>
	 <b2cc26e40811021120p1fa19892m4be6e00785b79289@mail.gmail.com>
	 <Pine.LNX.4.64.0811021122530.9451@alien.or.mcafeemobile.com>
	 <b2cc26e40811021241t17a4fd02k32234b9e6b578b3b@mail.gmail.com>
	 <Pine.LNX.4.64.0811021258250.9451@alien.or.mcafeemobile.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 2, 2008 at 10:17 PM, Davide Libenzi <davidel@xmailserver.org> wrote:
>> Wouldn't the port space require about 20+ k connects? This issue
>> happens after 1 k.
>
> The reason for "When accept returns EMFILE, I call epoll_wait and accept
> and it returns with another EMFILE." is because your sockets-close logic
> is broken.

It's not broken, it's designed that way. It's designed to hit the
descriptor limit and then close all sockets some time after.

> You get an event for the listening fd, you go call accept(2)
> and in one or two passes you fill up the avail fd space, then you go back
> calling epoll_wait(), and yet back to accept(2). This w/out triggering the
> file-close-relief code (yes, you fill up 1K fds *before* 30 seconds). Of
> course you get another EMFILE.

The second EMFILE doesn't make sense, epoll_wait shouldn't signal the
socket as ready again, right?
