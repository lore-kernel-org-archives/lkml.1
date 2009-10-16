Return-Path: <linux-kernel-owner+w=401wt.eu-S1760144AbZJPPXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760144AbZJPPXF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 11:23:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbZJPPXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 11:23:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185AbZJPPXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 11:23:02 -0400
Subject: Re: [PATCH] mm/nommu.c: Fix improperly call of security API in mmap
From: Eric Paris <eparis@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: graff.yang@gmail.com, linux-kernel@vger.kernel.org,
       gyang@blackfin.uclinux.org, akpm@linux-foundation.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Graff Yang <graf.yang@analog.com>,
       linux-security-module@vger.kernel.org
In-Reply-To: <6207.1255706090@redhat.com>
References: <7e0fb38c0910160801o50346a5cm763d79cab98272a5@mail.gmail.com>
	 <1255516134-4838-1-git-send-email-graff.yang@gmail.com>
	 <18475.1255529305@redhat.com>  <6207.1255706090@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Oct 2009 11:21:03 -0400
Message-Id: <1255706463.15182.84.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-16 at 16:14 +0100, David Howells wrote:
> Eric Paris <eparis@parisplace.org> wrote:
> 
> > I really don't like seeing such irrelevant (that's not the right word,
> > but I can't think what is) ifdefs creeping down into the security
> > layer as LSM authors are likely to mess them up in the future.  I'd
> > probably rather see the addr_only argument changed into a flags field.
> >  One for addr_only and one flag for not_addr.  The nommu case could
> > just set the not_addr flag and it's obvious how the LSMs (or
> > capabilities if !CONFIG_SECURITY) should handle it, also works if some
> > other future need arises...
> 
> A better way still, might be to deny the possibility of CONFIG_SECURITY if
> CONFIG_MMU=n.  After all, security is sort of pointless when a userspace
> program can just edit the kernel at a whim.

That would still call cap_file_mmap() and wouldn't solve your problem.

-Eric

