Return-Path: <linux-kernel-owner+w=401wt.eu-S1764536AbXKNU4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764536AbXKNU4Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 15:56:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761969AbXKNUzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 15:55:24 -0500
Received: from py-out-1112.google.com ([64.233.166.183]:29461 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761478AbXKNUzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 15:55:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HFlUy15IM/sg+AO5eGzXA1yRYBObyhgOvkX3uvtxzc3T4MYaoI/3Kq40ooG+KmyOox8uyZ39yLWpTJWhLEyKQFn07oTzJqLq++ZmxDoKtZJBoY5VfIMQ/jqoX+NzAzc16LgAaQ/xVcEpqdpeP8VF6y3e1BSuR1aaJQ081XBZ8Vc=
Message-ID: <64bb37e0711141255p4f54e055s76fd2f61ed105961@mail.gmail.com>
Date: Wed, 14 Nov 2007 21:55:11 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc2-mm1
Cc: linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>,
       "Trond Myklebust" <trond.myklebust@fys.uio.no>
In-Reply-To: <20071114122939.7b4ee194.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>
	 <64bb37e0711141116h5ea9ed8cs7f2afbabe73f07bb@mail.gmail.com>
	 <20071114122939.7b4ee194.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 14, 2007 9:29 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 14 Nov 2007 20:16:09 +0100 "Torsten Kaiser" <just.for.lkml@googlemail.com> wrote:
>
> > On Nov 14, 2007 2:59 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > >
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc2/2.6.24-rc2-mm1/
> >
> > Breaks nfsv4 in a rather funny way:
> >
> > treogen ~ # cd /usr/portage/x
> > treogen x # touch bla
> > touch: cannot touch `bla': File exists
> > treogen x # mkdir bla
> > treogen x # touch bla/bla
> > touch: cannot touch `bla/bla': File exists
> > treogen x # ls -lad *
> > drwxr-xr-x 2 root root 6 Nov 14 20:03 bla
> > treogen x # ls -la *
> > total 0
> > drwxr-xr-x 2 root root  6 Nov 14 20:03 .
> > drwxr-xr-x 3 root root 16 Nov 14 20:03 ..
> > treogen x #
> >
> > So I can create new directories, but not new files. Reading files works normal.
> >>
> > The client is 2.6.24-rc2-mm1, the server 2.6.22-gentoo-r9.
> > The fstab-line from the client:
> > 192.168.2.4:/portage    /usr/portage            nfs4
> > rw,noatime,nodiratime,intr 0 0
> >
> > 2.6.23-mm1 as client worked, some 2.6.24-rc1-git? also.
>
> hm.  I guess that means I get to do yet another git-bisect.  Either the nfs
> changes or r-o-bind-mounts, I bet.

treogen mm-test # git bisect good
Bisecting: 1245 revisions left to test after this
[4d88b06571b9d45e9cb52d8ad5dbf196ba280ff3] git-scsi-misc

I'm working on it... ;)

Torsten
