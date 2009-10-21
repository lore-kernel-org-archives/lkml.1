Return-Path: <linux-kernel-owner+w=401wt.eu-S1752929AbZJUAKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbZJUAKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 20:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbZJUAKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 20:10:52 -0400
Received: from mail-iw0-f178.google.com ([209.85.223.178]:56744 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbZJUAKv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 20:10:51 -0400
MIME-Version: 1.0
In-Reply-To: <x4963a9obw7.fsf@segfault.boston.devel.redhat.com>
References: <47c554d90910201458of5dc16eg33940584026bc959@mail.gmail.com>
	 <x49ljj5og8q.fsf@segfault.boston.devel.redhat.com>
	 <47c554d90910201634n68b359c1n501ed5669deb07be@mail.gmail.com>
	 <x4963a9obw7.fsf@segfault.boston.devel.redhat.com>
Date: Tue, 20 Oct 2009 17:10:55 -0700
Message-ID: <47c554d90910201710s1be91d45u1b71600fe0cfeb04@mail.gmail.com>
Subject: Re: libaio asynchronous syscall io_getevents blocks on error
From: Zubin Dittia <zubin@tintri.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, Jeff, this makes sense.  In order to get error codes for all
I/Os that are being submitted, I'll have to loop calling io_submit on
successively smaller portions of the initial array of requests, each
time trimming off the ones that have been successfully submitted.
-Zubin

On Tue, Oct 20, 2009 at 4:59 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Zubin Dittia <zubin@tintri.com> writes:
>
>> But this does bring up the interesting question of how to know which
>> of the I/Os I submitted had an error, and what the error was.  Does it
>
> If io_submit returned N, then the N+1 iocb had an error.
>
>> PS: It does seem a little strange that io_submit returns an error if
>> the first IOCB is invalid but not when any of the other IOCBs are
>> invalid (this appears to be the case, at least according to the man
>> page).
>
> It makes sense that it tells you how many it could successfully submit.
> If it can't submit any, you get the error from the first I/O.
>
> Cheers,
> Jeff
>
