Return-Path: <linux-kernel-owner+w=401wt.eu-S1761460AbZJPPoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761460AbZJPPoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 11:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761107AbZJPPoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 11:44:19 -0400
Received: from mail-yx0-f187.google.com ([209.85.210.187]:45985 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697AbZJPPoQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 11:44:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=TISCCkz+lflzq2/n/wkTvuFSw87oVFqB8dnIZfGExActOiyyj1WoeSigsX2zxQnJff
         wiq5aRUG5vKjZ6rfJIFWWZhpfkSsGEdC6UtMpGsEc1jiSTV0cP90egU+659kHD4I6rcl
         hOpCly2LvOLC8LtvGcZMhjaGwh6jn4ubRLUIM=
MIME-Version: 1.0
In-Reply-To: <6207.1255706090@redhat.com>
References: <1255516134-4838-1-git-send-email-graff.yang@gmail.com> 
	<18475.1255529305@redhat.com> <7e0fb38c0910160801o50346a5cm763d79cab98272a5@mail.gmail.com> 
	<6207.1255706090@redhat.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 16 Oct 2009 11:43:20 -0400
Message-ID: <8bd0f97a0910160843i1e95c543o842f91892f681214@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH] mm/nommu.c: Fix improperly call of 
	security API in mmap
To: David Howells <dhowells@redhat.com>
Cc: Eric Paris <eparis@parisplace.org>, graff.yang@gmail.com,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org, gyang@blackfin.uclinux.org,
       akpm@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 16, 2009 at 11:14, David Howells wrote:
> Eric Paris <eparis@parisplace.org> wrote:
>> I really don't like seeing such irrelevant (that's not the right word,
>> but I can't think what is) ifdefs creeping down into the security
>> layer as LSM authors are likely to mess them up in the future.  I'd
>> probably rather see the addr_only argument changed into a flags field.
>>  One for addr_only and one flag for not_addr.  The nommu case could
>> just set the not_addr flag and it's obvious how the LSMs (or
>> capabilities if !CONFIG_SECURITY) should handle it, also works if some
>> other future need arises...
>
> A better way still, might be to deny the possibility of CONFIG_SECURITY if
> CONFIG_MMU=n.  After all, security is sort of pointless when a userspace
> program can just edit the kernel at a whim.

except for MPU users, and arent some security restrictions useful when
talking about networked daemons ?
-mike
