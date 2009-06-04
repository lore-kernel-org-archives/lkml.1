Return-Path: <linux-kernel-owner+w=401wt.eu-S1755242AbZFDWxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbZFDWxv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 18:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbZFDWxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 18:53:44 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:41189 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbZFDWxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 18:53:43 -0400
From: Goswin von Brederlow <goswin-v-b@web.de>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Goswin von Brederlow <goswin-v-b@web.de>,
       Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org
Subject: Re: include/linux/aio_abi.h and IOCB_CMD_POLL
References: <87d49k6h45.fsf@frosties.localdomain>
	<E1MCCnb-0005Bc-09@pomaz-ex.szeredi.hu>
	<87hbyw6n9b.fsf@frosties.localdomain>
	<alpine.DEB.1.10.0906040814360.21635@makko.or.mcafeemobile.com>
Date: Fri, 05 Jun 2009 00:53:43 +0200
In-Reply-To: <alpine.DEB.1.10.0906040814360.21635@makko.or.mcafeemobile.com>
	(Davide Libenzi's message of "Thu, 4 Jun 2009 08:19:36 -0700 (PDT)")
Message-ID: <87zlcnwqyw.fsf@frosties.localdomain>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.22 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Provags-ID: V01U2FsdGVkX19pvl4u5J+2c1XkkBHDDWaLo39Rr3Z8TxE5e9n+
	crf/nmK1IgBSd+jvqYaeJFbG566Frwd8Hmt/Hc+JgYLc9NX5QH
	s3KLPkAXQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi <davidel@xmailserver.org> writes:

> On Thu, 4 Jun 2009, Goswin von Brederlow wrote:
>
>> Miklos Szeredi <miklos@szeredi.hu> writes:
>> 
>> > On Thu, 04 Jun 2009, Goswin von Brederlow wrote:
>> >> 3) Are there any alternatives to libaio that don't use threads and
>> >>    support polling?
>> >
>> > There are the poll, select and epoll interfaces that block, but are
>> > able to multiplex events from many file descriptors.
>> 
>> Unfortunately libaio does not use an fd to pass events between user
>> and kernel space so one can't use poll, select or epoll to wait for
>> /dev/fuse or libaio to have some work pending. And none of them
>> replace libaio functionality in respect to read/write.
>
> You can use the eventfd bridge between epoll/poll/select and AIO, that is 
> available by quite some time.
> This is an old example I made when the patch was posted:
>
> http://www.xmailserver.org/eventfd-aio-test.c
>
> This uses direct syscall interface, but you get the idea on how to do that 
> with libaio (that I never used).

Thanks. That example explains it nicely. There really should be
comments in libaio.h and an /usr/share/doc/libaio/examples/.

In case you wonder the libaio just wraps the system calls and provides
helpers in libaio.h. Basically the first 200 lines of the example are
libaio.h. Not 1:1 but nearly. The only difference is that io_prep_* do
not take an eventfd argument but there is

static inline void io_set_eventfd(struct iocb *iocb, int eventfd)

instead.


Now I have 2 ways of doing this. Always with the choices. :)

MfG
        Goswin
