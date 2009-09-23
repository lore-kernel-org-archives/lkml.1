Return-Path: <linux-kernel-owner+w=401wt.eu-S1754454AbZIWHdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454AbZIWHdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 03:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754315AbZIWHds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 03:33:48 -0400
Received: from exprod5og105.obsmtp.com ([64.18.0.180]:40755 "EHLO
	exprod5og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293AbZIWHdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 03:33:47 -0400
Message-ID: <4AB9CF44.1030301@ge.com>
Date: Wed, 23 Sep 2009 09:33:24 +0200
From: Enrik Berkhan <Enrik.Berkhan@ge.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: =?UTF-8?B?0JzQsNGA0Log0JrQvtGA0LXQvdCx0LXRgNCz?= 
	<socketpair@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: splice between non-pipe (tcp socket) fds
References: <b8f627e0909212323mbeb0fd1yba25aafb58ef686b@mail.gmail.com>
In-Reply-To: <b8f627e0909212323mbeb0fd1yba25aafb58ef686b@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 23 Sep 2009 07:33:28.0894 (UTC) FILETIME=[24E2BDE0:01CA3C20]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Марк Коренберг wrote:
> I want splice() to work with two tcp sockets().I think to implement
> this. Two questions:

This works already by introducing a pipe between the two:

while (0 < (len = splice(sock1, 0, pipe, 0, max_len, some_flags)))
   splice(pipe, 0, sock2, 0, len, some_flags);

Just like with read(2) and write(2), but without copy to/from userspace.

> 1. Is any work in this direction?
> 2. Why this functionality does not implemented now? any difficulties?
> 
> I think API should consist of 2 main functions:
> 1. detach available buffers from fd1 (and save info in some struct)
> 2. attach buffers to fd2 (from this struct)
> this functions should be called under some lock to guarantee
> atomicity. if something happen, return buffers back to original file.

What about full duplex?

> At now, I think that the most quick way to acheive my results,  is to
> create intermediate temporary pipe inside kernel and splice from
> non-pipe fd to pipe, and than from pipe to second non-pipe fd.

Have a look at the "sendfile emulation" in fs/splice.c. Maybe you can
generalize that in some way or the other.

Enrik

