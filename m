Return-Path: <linux-kernel-owner+w=401wt.eu-S1946424AbXD3RA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946424AbXD3RA3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 13:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946474AbXD3RA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 13:00:28 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:3037 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946402AbXD3RAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 13:00:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=bW92Hm//KELxgLIxzOin1npqSw8/K1fxf8AjyFvI4b5dYx0kCFlhguu396EnnqX0y3IJ1eatEEDKj4N9OmPvUskOTv2tZ3ADxc0hkc2hV8G31p0fe+wKvVc0Mof8s4qt6+Atj6WZJeRkT0R2Pa01T1jA+juR/F9cYhQ8Go7igps=
Message-ID: <f158dc670704301000p27e22637p73ec6654812a54b9@mail.gmail.com>
Date: Mon, 30 Apr 2007 11:00:20 -0600
From: "Latchesar Ionkov" <lucho@ionkov.net>
To: "Christoph Hellwig" <hch@infradead.org>,
       "Latchesar Ionkov" <lionkov@gmail.com>, "Andrew Morton" <akpm@osdl.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "V9FS Developers" <v9fs-developer@lists.sourceforge.net>
Subject: Re: [PATCH] 9p: create separate 9p client interface
In-Reply-To: <20070430161318.GA29321@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f158dc670704300832l36889bf2kfa4480addbe8cfb2@mail.gmail.com>
	 <20070430161318.GA29321@infradead.org>
X-Google-Sender-Auth: bb17cf9aa7d4b2da
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 4/30/07, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Apr 30, 2007 at 09:32:41AM -0600, Latchesar Ionkov wrote:
> > Create a separate 9P client interface that can be used outside the VFS
> > layer. In addition to VFS, the new interface can be used to export the
> > authentication channel or from other interfaces.
>
> And what exact users would that be?  We have a huge dislike for putting
> abstractions in just for the abstractions sake, so if you want this
> merged you'd better present a highly useful client to that interface.

In the current implementation the 9p VFS layer uses directly the
low-level 9p messages. It intermixes the logic required by VFS with
managing some data structures (v9fs_fid for example) that belong to
9P. This makes the VFS code harder to understand and modify.
Separating the low-level 9p interface makes the VFS operations shorter
and easier to understand.

Another scenario that we need separate interface for is exporting the
authentication channels to user space so more than one user can be
authenticated. The work on finishing the authentication will take some
more time, but there are other changes that Eric is working on and
that will also benefit from this change.

The interface that this patch creates is internal to 9p and involves
mainly moving code from  the vfs_* files to a separate file. fs/9p is
less than 50 LOC bigger than the previous version.

> Also the non-filesystem interface code shouldn't live in fs/ but
> rather in net/9p/

That makes sense, thanks. I can split the code and put the low-level
transport/multiplexer/9pclient(and eventually Eric can add his
9pserver) in a net/9p directory.

Thanks,
    Lucho
