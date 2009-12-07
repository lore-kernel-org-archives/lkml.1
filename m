Return-Path: <linux-kernel-owner+w=401wt.eu-S935017AbZLGKKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935017AbZLGKKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 05:10:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934964AbZLGKKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 05:10:37 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:54804 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934997AbZLGKKe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 05:10:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=I5/5zVTLF2UJypwV39B2dd6bxYdMPUnLr6j/RE4DBkuqthHBEKqKsJU2iRcMZ2bv9V
         2QhTGslM3Z68pV5RV+AZlBkQg5nm8TY2xJfX4nZHDMVIdAfYhwQmJXW9MNVMQqjRvxQk
         IPFpX52Du7rqrIEe+VpxLNUG/aItD5ylyl4gM=
MIME-Version: 1.0
In-Reply-To: <14959.1259948697@redhat.com>
References: <1244854869-2563-1-git-send-email-vapier@gentoo.org> 
	<14959.1259948697@redhat.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 7 Dec 2009 05:10:20 -0500
Message-ID: <8bd0f97a0912070210j5e1b56deg4d175b4a3758f0b9@mail.gmail.com>
Subject: Re: [uClinux-dev] [PATCH/RFC] FDPIC: add hook for arches to customize 
	program header parsing
To: David Howells <dhowells@redhat.com>
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

On Fri, Dec 4, 2009 at 12:44, David Howells wrote:
> Mike Frysinger <vapier@gentoo.org> wrote:
>> The Blackfin port has custom program header flags/addresses for
>> automatically loading regions into the dedicated on-chip SRAM.  So add a
>> hook for ports to leverage.
>
> Now that I've ACK'd this, I feel I'm going to have to NAK it.  I'm not against
> the general concept, but:
>
>> +             do_munmap(mm, *maddr, phdr->p_memsz + *disp);
>
> There needs to be a mapping covering the SRAM region for the purposes of the
> debugger.  Do you have a chardev covering the SRAM device?  Perhaps through
> MTD?

SRAM is accessed directly by kernel/user space.  there is no device
indirection nor are there any mappings.
-mike
