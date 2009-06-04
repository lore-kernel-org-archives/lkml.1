Return-Path: <linux-kernel-owner+w=401wt.eu-S1755824AbZFDPZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824AbZFDPZt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 11:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbZFDPZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 11:25:42 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:53190 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbZFDPZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 11:25:41 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 4 Jun 2009 08:19:36 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Goswin von Brederlow <goswin-v-b@web.de>
cc: Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org
Subject: Re: include/linux/aio_abi.h and IOCB_CMD_POLL
In-Reply-To: <87hbyw6n9b.fsf@frosties.localdomain>
Message-ID: <alpine.DEB.1.10.0906040814360.21635@makko.or.mcafeemobile.com>
References: <87d49k6h45.fsf@frosties.localdomain> <E1MCCnb-0005Bc-09@pomaz-ex.szeredi.hu> <87hbyw6n9b.fsf@frosties.localdomain>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Jun 2009, Goswin von Brederlow wrote:

> Miklos Szeredi <miklos@szeredi.hu> writes:
> 
> > On Thu, 04 Jun 2009, Goswin von Brederlow wrote:
> >> 3) Are there any alternatives to libaio that don't use threads and
> >>    support polling?
> >
> > There are the poll, select and epoll interfaces that block, but are
> > able to multiplex events from many file descriptors.
> 
> Unfortunately libaio does not use an fd to pass events between user
> and kernel space so one can't use poll, select or epoll to wait for
> /dev/fuse or libaio to have some work pending. And none of them
> replace libaio functionality in respect to read/write.

You can use the eventfd bridge between epoll/poll/select and AIO, that is 
available by quite some time.
This is an old example I made when the patch was posted:

http://www.xmailserver.org/eventfd-aio-test.c

This uses direct syscall interface, but you get the idea on how to do that 
with libaio (that I never used).


- Davide


