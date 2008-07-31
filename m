Return-Path: <linux-kernel-owner+w=401wt.eu-S1753515AbYGaPJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515AbYGaPJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 11:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbYGaPJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 11:09:04 -0400
Received: from gw.goop.org ([64.81.55.164]:49486 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633AbYGaPJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 11:09:04 -0400
Message-ID: <4891D58E.1070308@goop.org>
Date: Thu, 31 Jul 2008 08:09:02 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Maxin John <maxin.john@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: regarding mprotect() implementation in 2.6.26 kernel
References: <9debc4410807310315n4da5beafh853a71f532420e9a@mail.gmail.com> <9debc4410807310324m4a76aaf5s253242e5cc2bb130@mail.gmail.com>
In-Reply-To: <9debc4410807310324m4a76aaf5s253242e5cc2bb130@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maxin John wrote:
> Dear Christoph Hellwig,
>
> ( I guess you are the right person to ask this question ?)
>
> The POSIX.2 specification of mprotect() says:
>
> errorno should be set as ENOMEM if the addresses in the range [addr,
> (addr + len)] are invalid for the address space of a process, or
> specify one or more pages which are not mapped.
>
> However, in the mprotect implementation  (asmlinkage long
> sys_mprotect(unsigned long start, size_t len, unsigned long prot)) in
> linux/mm/mprotect.c file, if we call mprotect() with start as NULL and
> len as 0, mprotect() returns 0 and it is not setting the errono.The
> following code confirms this behaviour.
>   

Address 0 is a valid process address.  And you've set the length to
zero, so you technically haven't referred to any memory at all, so it
doesn't matter what the address is.

    J
