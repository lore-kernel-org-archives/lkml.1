Return-Path: <linux-kernel-owner+w=401wt.eu-S1755192AbZHCUAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbZHCUAc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 16:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755138AbZHCUAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 16:00:31 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:46712 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134AbZHCUAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 16:00:31 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Sergey Senozhatsky <sergey.senozhatsky@mail.by>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Subject: Re: [PATCH 2/2] tty-ldisc: turn ldisc user count into a proper refcount
References: <20090802120120.GA3097@localdomain.by>
	<alpine.LFD.2.01.0908020940530.3352@localhost.localdomain>
	<20090802190514.GA3278@localdomain.by>
	<alpine.LFD.2.01.0908021254580.3352@localhost.localdomain>
	<87k51l9apo.fsf@devron.myhome.or.jp>
	<alpine.LFD.2.01.0908021423490.3352@localhost.localdomain>
	<20090802234851.3fd1ac2c@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0908021654010.3352@localhost.localdomain>
	<alpine.LFD.2.01.0908031047010.3208@localhost.localdomain>
	<alpine.LFD.2.01.0908031055400.3208@localhost.localdomain>
	<alpine.LFD.2.01.0908031058330.3208@localhost.localdomain>
Date: Tue, 04 Aug 2009 05:00:27 +0900
In-Reply-To: <alpine.LFD.2.01.0908031058330.3208@localhost.localdomain> (Linus
	Torvalds's message of "Mon, 3 Aug 2009 11:11:19 -0700 (PDT)")
Message-ID: <87d47cfz1g.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> Whatever. The patch _looks_ sensible to me. The only users of ldisc->users 
> are:
>  - get_ldisc() - atomically increment the count
>
>  - put_ldisc() - atomically decrements the count and releases if zero
>
>  - tty_ldisc_try_get() - creates the ldisc, and sets the count to 1.
>    The ldisc should then either be released, or be attached to a tty.
>
> Comments? Testing?

This works for me. And it seems there is no refcount leak in this
shutdown case.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
