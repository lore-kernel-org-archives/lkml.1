Return-Path: <linux-kernel-owner+w=401wt.eu-S1759451AbXF0TOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759451AbXF0TOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 15:14:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbXF0TN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 15:13:58 -0400
Received: from web30501.mail.mud.yahoo.com ([68.142.200.114]:35986 "HELO
	web30501.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751426AbXF0TN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 15:13:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=ddoCkfgVPoa37fDEnNIqsdcP+1siUHrWlUQDXCODuTADTSY/EFmW4UZwLxu8LsGkFMlZO6b/AFHXrwu87Vb+o2t0TG3OQrWlc/YVbyUVeDxPLttUo5DyMNE21Kpb2VG57nMw9cinyfkCp2+6JFmrSzuzL0v1U8HISORem7oG8a0=;
X-YMail-OSG: 2_sWBU4VM1mVvhu2SndsAsKOwH5DRQMEULJiHFRSZnxTmHw4eIb5RqjfbkEfQMXyvimf0qG_.g--
Date: Wed, 27 Jun 2007 12:13:57 -0700 (PDT)
From: Casey Leedom <casey_leedom@yahoo.com>
Subject: Re: ZERO_PAGE() vs. loadable modules in Redhat 4.4 i386 kernels ...
To: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0706271956430.30942@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <498725.24237.qm@web30501.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- Hugh Dickins <hugh@veritas.com> wrote:

> I can't speak for Red Hat 4.4; but in general, you should be passing the
> write flag to get_user_pages if you're going to modify the content of
> those pages, which will then allocate the hierarchy needed and break
> COW where necessary.

  yes, that would definitely be the case if I were doing a DMA read but in this
case I'm doing a DMA write.  I could force the kernel to instantiate zero'ed
pages for the entire range but that would significantly impact performance.

> If that doesn't suit you (e.g. it's supposed to
> be a readonly area in userspace), then you proably shouldn't be using
> get_user_pages at all, but letting userspace mmap your driver pages
> into its space instead.  Definitely don't play empty_zero_page games.

  Hhrrrmmm, I'm not sure I understand what you're saying here.  In our case the
user application just does a write() on a socket.  Our driver is doing a DMA
directly from user pages out to the interface.  We have fallback timeout code
if the DMA takes longer than a certain length of time where we mark the pages
that haven't yet been transfered as COW so we can return early to the user
application without violating Linux write() semantics.  It sounds like you're
advocating major changes to the application which wouldn't be useful.  My
appologies if I'm misinterpreting your comment.

Casey
