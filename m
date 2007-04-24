Return-Path: <linux-kernel-owner+w=401wt.eu-S1030185AbXDXLPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030185AbXDXLPU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 07:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030188AbXDXLPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 07:15:20 -0400
Received: from wr-out-0506.google.com ([64.233.184.224]:33652 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030185AbXDXLPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 07:15:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mve4glj3ZcoOazqwHn5wQJf8/GqO4rTJWt+ppIYjqrP+v5LVO/lIGtgpya/mTxFmQv0RnsHLEpFuymiBs23zcShWl9sjm1Nw+oSzfVexh6XdPNEK5Huza6Q0CAnlzYLxEXDve3pSI51hd+j4UYHV+ndNtZAEcSsTpwWzppQ/Vjg=
Message-ID: <1158166a0704240415i4cb2e29ep1a556d3aa379476c@mail.gmail.com>
Date: Tue, 24 Apr 2007 13:15:17 +0200
From: "Denis Vlasenko" <vda.linux@googlemail.com>
To: "Theodore Tso" <tytso@mit.edu>, "Eric Hopper" <hopper@omnifarious.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Question about Reiser4
In-Reply-To: <20070424011753.GD1663@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <462C4D32.4000909@redhat.com> <462C5034.9090403@redhat.com>
	 <Pine.LNX.4.64.0704230640540.25153@server.thyself>
	 <20070423010445.454eda63.akpm@linux-foundation.org>
	 <20070423135216.GA2744@omnifarious.org>
	 <20070423225640.GA1663@thunk.org> <462D46DF.4090802@zytor.com>
	 <20070424001934.GC1663@thunk.org> <462D4FE1.5040406@zytor.com>
	 <20070424011753.GD1663@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Theodore Tso wrote:
> >
> > One of the big problems of using a filesystem as a DB is the system
> > call overheads.  If you use huge numbers of tiny files, then each
> > attempt read an atom of information from the DB takes three system
> > calls --- an open(), read(), and close(), with all of the overheads in
> > terms of dentry and inode cache.
> >
>
> Now, to be fair, there are probably a number of cases where
> open/lseek/readv/close and open/lseek/writev/close would be worth doing
> as a single system call.  The big problem as far as I can see involves
> EINTR handling; such a system call has serious restartability implications.
>
> Of course, there are Ingo's syslets...

I definitely would like open/readv/close syscall a lot.
Actually, a set of four syscalls

open/readv/close
open/pread/close
open/writev/close
open/pwrite/close

will allow to reduce syscall overhead for a number of cases.
--
vda
