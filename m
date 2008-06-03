Return-Path: <linux-kernel-owner+w=401wt.eu-S1757363AbYFCLjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363AbYFCLjV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 07:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbYFCLjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 07:39:11 -0400
Received: from ik-out-1112.google.com ([66.249.90.183]:52739 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbYFCLjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 07:39:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=f2GfXn9CP77Obtmfonw30HXk4DmG0EQMcSMLWo/HWALyTBaix23Cf63HVX9eweT50+FODk/HRPpDi8Xhgci6WMJPSIceK5XxnPZl0fRnKgwHUKi/ImhHEarqxYDPnh9xEkVThotizA5wWrvE8j6WevGeJVSr9UaU5FWkOKyVlFA=
Message-ID: <cfd18e0f0806030439n5a11fa4aocd6251ffab66b6dd@mail.gmail.com>
Date: Tue, 3 Jun 2008 13:39:07 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Jamie Lokier" <jamie@shareable.org>
Subject: Re: [PATCH] utimensat() non-conformances and fixes [v3]
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, "Miklos Szeredi" <miklos@szeredi.hu>,
       drepper@redhat.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-man@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20080603113018.GA27955@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <482D4665.4050401@gmail.com>
	 <E1Jx3Gw-0002eA-55@pomaz-ex.szeredi.hu> <48401E7E.9090304@gmail.com>
	 <cfd18e0f0806030405u1c32b114pa0fdd979f36f87fb@mail.gmail.com>
	 <E1K3URo-0005sj-JW@pomaz-ex.szeredi.hu>
	 <20080603112221.GW28946@ZenIV.linux.org.uk>
	 <cfd18e0f0806030427p22a274dev746e1656662f34f6@mail.gmail.com>
	 <20080603113018.GA27955@shareable.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 3, 2008 at 1:30 PM, Jamie Lokier <jamie@shareable.org> wrote:
> Michael Kerrisk wrote:
>> > FWIW, I very much doubt that you are right wrt required
>> > permissions, though.  AFAICS, intent here is "if you can write to
>> > file, you can touch the timestamps anyway" and having descriptor
>> > opened for write gives that, current permissions be damned.
>>
>> The standard is pretty clear on this point:
>>
>> [[
>> Only a process with the effective user ID equal to the user ID of the
>> file, or with write access to the file, or with appropriate privileges
>> may use futimens( ) or utimensat( ) with a null pointer as the times
>> argument or with both tv_nsec fields set to the special value
>> UTIME_NOW.
>> ]]
>>
>> The crucial words here are "a process ... with write access to the
>> file" -- in other words, the permissions are determined by the
>> process's credentials, not by the access mode of the file descriptor.
>> I was not 100% sure on that to start with, so I did check it out with
>> one of the folk at The Open Group, to make sure of my understanding.
>
> Is there anything else where the file descriptor's access mode allows
> doing things on Linux, but the standard requires a permissions check
> each time?

Jamie,

I can't think of examples offhand -- but I'm also not quite sure what
your question is about.  Could you say a little more?

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
