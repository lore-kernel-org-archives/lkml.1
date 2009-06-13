Return-Path: <linux-kernel-owner+w=401wt.eu-S933689AbZFMQlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933689AbZFMQlm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 12:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933587AbZFMQlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 12:41:17 -0400
Received: from mail-yx0-f192.google.com ([209.85.210.192]:44062 "EHLO
	mail-yx0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933581AbZFMQlO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 12:41:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ETR5uf7erYQJpUyv8k7SxVr/S4zHQBQWvp9pJYdVc3l0BodWunYKVV04qEbGIAmDwD
         WHB18MnYCgfKlA5jmv/ePY1NYg7unASeebcy3C7hGELwiUsmVHxeaMGx/UTyAqHkJhMB
         5SaHFdyN+2sgebKhlfghSlf+/7Do8tW1ke8NE=
MIME-Version: 1.0
In-Reply-To: <20090613161323.GC16220@shareable.org>
References: <1244854869-2563-1-git-send-email-vapier@gentoo.org> 
	<20090613161323.GC16220@shareable.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sat, 13 Jun 2009 12:40:45 -0400
Message-ID: <8bd0f97a0906130940j6b5e578bha8193f59d03c2f05@mail.gmail.com>
Subject: Re: [uClinux-dev] [PATCH/RFC] FDPIC: add hook for arches to customize 
	program header parsing
To: Jamie Lokier <jamie@shareable.org>
Cc: uClinux development list <uclinux-dev@uclinux.org>,
       linux-kernel@vger.kernel.org, Jie Zhang <jie.zhang@analog.com>,
       Greg Ungerer <gerg@uclinux.org>,
       uclinux-dist-devel@blackfin.uclinux.org,
       David McCullough <davidm@snapgear.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 13, 2009 at 12:13, Jamie Lokier wrote:
> Mike Frysinger wrote:
>> From: Jie Zhang <jie.zhang@analog.com>
>>
>> The Blackfin port has custom program header flags/addresses for
>> automatically loading regions into the dedicated on-chip SRAM.  So add a
>> hook for ports to leverage.
>
> What does this have to do with FDPIC?  I don't see anything that is
> specific to FDPIC about this code, other than FDPIC being the type of
> ELF used on Blackfin.  If an MMU were added to some future Blackfins,
> wouldn't this code be used for non-FDPIC ELF too?

no, because with a MMU, the memory would be virtualized and we could
handle it dynamically

> It looks like a way for certain special executables to load themselves
> into fixed regions of the on-chip SRAM - and promptly crash if another
> executable does the same.  Not so much a general executable format, as
> a hack to load something specific which should only be done once at a
> time.  What am I missing here?

the addresses are keys, not fixed and/or "real" addresses
-mike
