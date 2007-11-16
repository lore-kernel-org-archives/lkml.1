Return-Path: <linux-kernel-owner+w=401wt.eu-S1752152AbXKPF3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152AbXKPF3q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 00:29:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751038AbXKPF3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 00:29:38 -0500
Received: from nz-out-0506.google.com ([64.233.162.234]:3450 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbXKPF3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 00:29:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=c08JSEab1HhIVutpzOEyJOOehrOdOL1LPa96pJN92/y7vr03MA0y+KEbafEfw62MvkrO/tjSCoYj6gqmR40qZV18qjvGgJJmD15wirHuyICLcSvDBERkaumQiTOWYY5mvlN+ApWz8VpvZbS3chnN9yk7Lu829Tu+ZL5U+96+m6w=
Message-ID: <64bb37e0711152129l104752d1nb2422ef5aabae8e6@mail.gmail.com>
Date: Fri, 16 Nov 2007 06:29:36 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc2-mm1
Cc: jblunck@suse.de, linux-kernel@vger.kernel.org, bfields@fieldses.org,
       trond.myklebust@fys.uio.no
In-Reply-To: <20071115133458.967ca5d7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>
	 <64bb37e0711141116h5ea9ed8cs7f2afbabe73f07bb@mail.gmail.com>
	 <20071114122939.7b4ee194.akpm@linux-foundation.org>
	 <64bb37e0711141448h15c667dbn4496870dd64a0457@mail.gmail.com>
	 <20071115173627.GG25521@hasse.suse.de>
	 <64bb37e0711151324k2a10e683k506c50126ad1978f@mail.gmail.com>
	 <20071115133458.967ca5d7.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 15, 2007 10:34 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 15 Nov 2007 22:24:12 +0100
> "Torsten Kaiser" <just.for.lkml@googlemail.com> wrote:
>
> > The problem with the first bisect-try was, that everything between
> > bisect-good: r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename
> > and
> > bisect-bad: use-struct-path-in-struct-svc_export
> > did not compile like this:
> >
> >   CC [M]  fs/nfsd/vfs.o
> > fs/nfsd/vfs.c: In function 'nfsd_rename':
> > fs/nfsd/vfs.c:1695: error: request for member 'mnt' in something not a
> > structure or union
>
> argh.  I'd incorrectly worked out that
> nfsd-fix-wrong-mnt_writer-count-in-rename.patch was a fix against
> r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename.patch however
> it is in fact a fix against use-struct-path-in-struct-svc_export.patch.
>
> My life sucks.
>

I think the placement was correct, but the patch itself was made
against a tree that already contained the changes from
use-struct-path-in-struct-svc_export.patch.
nfsd-fix-wrong-mnt_writer-count-in-rename.patch should have used the
old naming ex_mnt and only use-struct-path-in-struct-svc_export.patch
should have changed it to ex_path.mnt.

Torsten
