Return-Path: <linux-kernel-owner+w=401wt.eu-S1758189AbZDGTbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189AbZDGTbI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 15:31:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757010AbZDGTas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 15:30:48 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:54067 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758493AbZDGTar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 15:30:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=arFKKSlD+NDrtV1VeU4DM//bQgVdx/FbQrVmpi2tTsaEH9b8ySBGcj+zI/1qG8t3Ls
         e2Tewasvee0Vw4/BhZndyCJAQ6RUMYLt0mSLnhNl2Lw3pHPUbSBMw943RR+sRbC0plzy
         1Z9oCMhTgLWoXHFc2+JmIJL8P4FfZxefS9mR4=
MIME-Version: 1.0
In-Reply-To: <20090407182157.GW3204@webber.adilger.int>
References: <20090407062356.GA1336463@fiona.linuxhacker.ru>
	 <20090407173248.GC31824@shareable.org> <49DB8F8E.9010605@garzik.org>
	 <20090407175617.GF31824@shareable.org>
	 <20090407182157.GW3204@webber.adilger.int>
Date: Tue, 7 Apr 2009 12:30:45 -0700
Message-ID: <a36005b50904071230h4850b5e3q2ad72a8e8babe09a@mail.gmail.com>
Subject: Re: Attempt at "stat light" implementation
From: Ulrich Drepper <drepper@gmail.com>
To: Andreas Dilger <adilger@sun.com>
Cc: Jamie Lokier <jamie@shareable.org>, Jeff Garzik <jeff@garzik.org>,
       Oleg Drokin <green@linuxhacker.ru>, linux-fsdevel@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 7, 2009 at 11:21 AM, Andreas Dilger <adilger@sun.com> wrote:
> There is one in OS/X called getattrlist, but it is quite complex and
> would require attribute handling wildly different than what the kernel
> and *nix applications are doing:
>
> http://www.manpagez.com/man/2/getattrlist/

I think this is overkill.  There are two different tasks to do:

- speed up stat by providing a subset of the information

- provide a mechanism to get arbitrary attribute support and efficient
ways to get to it


Trying to force both of these tasks into one interface will partially
defeat the purpose of the first, creating a fast stat replacement.  I
think these should be different interfaces (if the second type is
needed at all).

As for making the interface extendable.  In all the years there hasn't
really been much need to extend the stat structure (ignoring extended
attributes).  So, I'd not be worried about using a simple 32-bit
bitmask to select the fields to include in the fast stat.
