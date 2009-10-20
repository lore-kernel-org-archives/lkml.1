Return-Path: <linux-kernel-owner+w=401wt.eu-S1752980AbZJTXeC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980AbZJTXeC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 19:34:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751601AbZJTXeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 19:34:01 -0400
Received: from mail-iw0-f178.google.com ([209.85.223.178]:34747 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbZJTXeA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 19:34:00 -0400
MIME-Version: 1.0
In-Reply-To: <x49ljj5og8q.fsf@segfault.boston.devel.redhat.com>
References: <47c554d90910201458of5dc16eg33940584026bc959@mail.gmail.com>
	 <x49ljj5og8q.fsf@segfault.boston.devel.redhat.com>
Date: Tue, 20 Oct 2009 16:34:04 -0700
Message-ID: <47c554d90910201634n68b359c1n501ed5669deb07be@mail.gmail.com>
Subject: Re: libaio asynchronous syscall io_getevents blocks on error
From: Zubin Dittia <zubin@tintri.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 20, 2009 at 3:25 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Zubin Dittia <zubin@tintri.com> writes:
>
>> I'm writing a program that uses the kernel's io_submit/io_getevents
>> system calls.  What I would like to be able to do is submit N
>> operations for i/o on different files, and then call io_getevents with
>> min_nr = nr = N and a timeout of NULL, so that I can block until all N
>> operations have completed.  This works great, except when one of the
>> operations has an error (eg., if one of the descriptors is invalid).
>> In this case, the call to io_getevents appears to block indefinitely.
>> Shouldn't an error on one of the submitted operations count as a
>> completion event for that operation, so I can check the error code
>> when the call returns?  Any help would be appreciated.
>
> Did you check the return value of io_submit?
>
> Cheers,
> Jeff
>


Duh.  I was just checking to see if it returned a negative error, but
not checking to see if it accepted fewer than all the I/Os I
submitted.

But this does bring up the interesting question of how to know which
of the I/Os I submitted had an error, and what the error was.  Does it
mean I have to call io_submit once for each I/O operation; if so, then
why does io_submit take an array argument at all?

Thanks for your help,
-Zubin

PS: It does seem a little strange that io_submit returns an error if
the first IOCB is invalid but not when any of the other IOCBs are
invalid (this appears to be the case, at least according to the man
page).
