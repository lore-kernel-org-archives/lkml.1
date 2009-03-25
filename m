Return-Path: <linux-kernel-owner+w=401wt.eu-S1759232AbZCYQYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759232AbZCYQYp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 12:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755308AbZCYQYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 12:24:36 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:34161 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879AbZCYQYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 12:24:36 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 25 Mar 2009 09:23:21 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: nicolas sitbon <nicolas.sitbon@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: epoll_ctl and const correctness
In-Reply-To: <84a01a8b0903250545n799a8727o1faad60c8eaf372e@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0903250921230.15216@makko.or.mcafeemobile.com>
References: <84a01a8b0903250545n799a8727o1faad60c8eaf372e@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Mar 2009, nicolas sitbon wrote:

> Currently, the prototype of epoll_ctl is :
> 
> int epoll_ctl(int epfd, int op, int fd, struct epoll_event *event);
> 
> I searched in the man of epoll_ctl and google, and it seems that the
> structure pointed to by event isn't modify, valgrind confirms this
> behaviour, so am I wrong? or the good prototype is
> 
> int epoll_ctl(int epfd, int op, int fd, struct epoll_event const *event);

According to the current ctl operations, yes. But doing that would prevent 
other non-const operations to be added later on.


- Davide


