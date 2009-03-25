Return-Path: <linux-kernel-owner+w=401wt.eu-S1762659AbZCYR1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762659AbZCYR1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 13:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756877AbZCYR1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 13:27:09 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:52208 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756326AbZCYR1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 13:27:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=h8mWewSVHHoi9gRaQZmqmAVH29p9DpdVfM71YrPEPujMSCDmQZRtCZm0HUbOev22SP
         YwwzuKBB9D1f1DLdf+NcrAh73SW+Rlgi1xCj/ykrmLFn6Rum4hjhDeffzyjz9sJ+xcoO
         Ue0qDJBwynZtsj6VxVkrfMctSsrHWqHw5oCqM=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.0903250921230.15216@makko.or.mcafeemobile.com>
References: <84a01a8b0903250545n799a8727o1faad60c8eaf372e@mail.gmail.com>
	 <alpine.DEB.1.10.0903250921230.15216@makko.or.mcafeemobile.com>
Date: Wed, 25 Mar 2009 18:27:03 +0100
Message-ID: <84a01a8b0903251027p18fceee4h813f4d9616245a2d@mail.gmail.com>
Subject: Re: epoll_ctl and const correctness
From: nicolas sitbon <nicolas.sitbon@gmail.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok for "const correctness", but:
do you keep track of the structure event after the call to epoll_ctl or no?
I mean I found some codes that reuse this structure for multiple call
to epoll_ctl but with different file descriptor, is this allowed?

struct epoll_event ev = {.fd = STDIN_FILENO, .data.fd = STDIN_FILENO};
/* <= one structure for 2 calls */
epoll_ctl(epfd, EPOLL_CTL_ADD, STDIN_FILENO, &ev);
ev.fd = STDOUT_FILENO;
ev.data.fd = STDOUT_FILENO;
epoll_ctl(epfd, EPOLL_CTL_ADD, STDOUT_FILENO, &ev);

Other question:
int epoll_create(int size);

can you please, explain me why size is an int and not a size_t or at
least an unsigned integer?

thanks.

2009/3/25 Davide Libenzi <davidel@xmailserver.org>:
> On Wed, 25 Mar 2009, nicolas sitbon wrote:
>
>> Currently, the prototype of epoll_ctl is :
>>
>> int epoll_ctl(int epfd, int op, int fd, struct epoll_event *event);
>>
>> I searched in the man of epoll_ctl and google, and it seems that the
>> structure pointed to by event isn't modify, valgrind confirms this
>> behaviour, so am I wrong? or the good prototype is
>>
>> int epoll_ctl(int epfd, int op, int fd, struct epoll_event const *event);
>
> According to the current ctl operations, yes. But doing that would prevent
> other non-const operations to be added later on.
>
>
> - Davide
>
>
>
