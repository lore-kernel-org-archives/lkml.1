Return-Path: <linux-kernel-owner+w=401wt.eu-S1755791AbYDQEZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791AbYDQEZo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 00:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750815AbYDQEZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 00:25:34 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:46212 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbYDQEZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 00:25:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=F31K97pTLaKOhhrzdFGFIVFuxVLZyGz+AV/Mi54TaVf6kWN3hY38FPHR2KD4OrFnQX8Qsi/A/YlTUbOZCR6Zv35yQU9YCQXjkJmhCm8pUgGfaCLaWb2xwwgxk2OGE5vwOaEZMaleoTC3EZ+S6khQ+XQ0wkq6SP0e0XdRxj4lSAk=
Message-ID: <aa79d98a0804162125u45bde1edq550acf51784a5b5@mail.gmail.com>
Date: Thu, 17 Apr 2008 08:25:32 +0400
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Trond Myklebust" <trond.myklebust@fys.uio.no>
Subject: Re: [patch 1/3] NFS: fix potential NULL pointer dereference
Cc: bfields@fieldses.org, neilb@suse.de, ibm-acpi@hmh.eng.br,
       len.brown@intel.com, kkeil@suse.de, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1208378428.8598.12.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080416174421.442716301@gmail.com>
	 <48063bc9.2234440a.747d.09ea@mx.google.com>
	 <1208369492.5376.9.camel@heimdal.trondhjem.org>
	 <20080416181336.GA7657@cvg>
	 <1208372123.5376.43.camel@heimdal.trondhjem.org>
	 <aa79d98a0804161319l4be9bb12k7bacae815b1d6d9c@mail.gmail.com>
	 <1208378428.8598.12.camel@heimdal.trondhjem.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2008 at 12:40 AM, Trond Myklebust
<trond.myklebust@fys.uio.no> wrote:
>
>  On Thu, 2008-04-17 at 00:19 +0400, Cyrill Gorcunov wrote:
>  > Trond, I've just pointed the problem and its solution (which is seems
>  > to be a bit ugly, according to the rest nfs coding principle). So if
>  > you prefer to have such a check in 'walk_path' function - just say me
>  > that. You choose :) Thanks for comments
>
>
> > > So? The defensive coding principle is that you perform validity checks
>  > > when the pointer is created. Otherwise, we could equally well have added
>  > > the NULL deref check to nfs4_path_walk()...
>
>  No, your fix was correct, it was just incomplete.
>
>  The point I was making above was that defensive programming means that
>  _all_ these validity/NULL pointer checks should really be done in
>  nfs4_validate_mount_data and nfs_validate_mount_data. We shouldn't rely
>  on checks in other parts of the code.
>
>  In fact, as an example: it looks to me as if the lack of a
>  nfs_server.hostname, leads to a lack of nfs_client->cl_hostname, which
>  will eventually cause an Oops if you 'cat /proc/fs/nfsfs/servers', or if
>  you hit the printk in nfs_update_inode(), or various other dprintk()s.
>
>  Trond
>
>

Thanks Trond, I'll remake it ASAP (but can't guarantie that it will be soon ;)
