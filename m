Return-Path: <linux-kernel-owner+w=401wt.eu-S1755500AbYAHXoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500AbYAHXoO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 18:44:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbYAHXn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 18:43:58 -0500
Received: from nz-out-0506.google.com ([64.233.162.229]:55335 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbYAHXn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 18:43:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EMiCbjicBGP4PacOW6kXPcybPxOc19IFJKDDEBr0m93pZjdohzc//eND9/1IJ4Vxcgxb0IUgK2pnsRYXrX0xeBJAJrOGYLUA8DfM/t/I3lVeGCxMFhj1OpC8A1elz1fPYrGChW0FYD4unGRkRk80yh3ZOXuJ0kEObz/rijni9As=
Message-ID: <4d8e3fd30801081543l57add8bei48052bdf68730474@mail.gmail.com>
Date: Wed, 9 Jan 2008 00:43:52 +0100
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [JANITOR PROPOSAL] Switch ioctl functions to ->unlocked_ioctl II
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       gorcunov@gmail.com
In-Reply-To: <20080108230636.GC2117@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080108164015.GC31504@one.firstfloor.org>
	 <4d8e3fd30801081158j3e7292d0i939776342015b12d@mail.gmail.com>
	 <20080108204214.GA2117@one.firstfloor.org>
	 <20080108230636.GC2117@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 9, 2008 12:06 AM, Andi Kleen <andi@firstfloor.org> wrote:
> > I would suggest to only work on files that compile. e.g. do a
> >
> > make allyesconfig
> > make -j$[$(grep -c processor /proc/cpuinfo)*2] &1 |tee LOG             (will probably take a long time)
> >
> > first and then only modify files when are mentioned in "LOG"
>
> Actually since this will probably take very long on a slower machine you can refer to
>
> http://halobates.de/allyes/

Thank you Andi.

> for some allyes buildlogs of recent kernels for i386 and x86-64. A trick to quickly check
> if something compiles is also to do
>
> make allyesconfig
> make path/to/file.o
>
> That won't catch linker errors, but if you don't have warnings there are normally no
> linker errors either.

I did grep for "struct file_operations" in mm:

paolo@paolo-desktop:~/linux-2.6/mm$ grep "struct file_operations" *
shmem.c:static const struct file_operations shmem_file_operations;
shmem.c:static const struct file_operations shmem_file_operations = {
swapfile.c:static const struct file_operations proc_swaps_operations = {

Am I right in saying that both the files don't need to be modified?

There is nothing like:
struct file_operations xyz_ops = {
       ...
       .ioctl = xyz_ioctl
};

in there.

So I guess I need a smarter trick to find out which files need to be modified
as you previously suggested.

Ciao,
-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
