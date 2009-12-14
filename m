Return-Path: <linux-kernel-owner+w=401wt.eu-S1758849AbZLNXwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758849AbZLNXwT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 18:52:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754660AbZLNXv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 18:51:59 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:49425 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657AbZLNXv6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 18:51:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=QIUTdG+9Cj2ZEpv8Fvpd4JuwgJBDFjHr/bxqRESUiR+rhVSKekbbfO+VYVxBV3jFTV
         tyd3PcdpZbSA4o5C7UfJX1ZfyoRh53tAa91S9i06w+iHf2bAXQ9ZQ4yCKjDnxPyaPh/d
         1+kMC1fUe2EtaCwTS4IvelVY+ttGhOyKbe0DY=
MIME-Version: 1.0
In-Reply-To: <20091210135821.6325.90645.stgit@warthog.procyon.org.uk>
References: <20091210135755.6325.78149.stgit@warthog.procyon.org.uk> 
	<20091210135821.6325.90645.stgit@warthog.procyon.org.uk>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 14 Dec 2009 18:51:37 -0500
Message-ID: <8bd0f97a0912141551k735a20c3q8ac5d02fcfef13b1@mail.gmail.com>
Subject: Re: [PATCH 6/7] NOMMU: Use copy_*_user_page() in access_process_vm()
To: David Howells <dhowells@redhat.com>
Cc: lethal@linux-sh.org, jie.zhang@analog.com, stefani@seibold.net,
       gerg@snapgear.com, uclinux-dev@uclinux.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 08:58, David Howells wrote:
> From: Jie Zhang <jie.zhang@analog.com>
>
> The MMU code uses the copy_*_user_page() variants in access_process_vm()
> rather than copy_*_user() as the former includes an icache flush.  This is
> important when doing things like setting software breakpoints with gdb.
> So switch the NOMMU code over to do the same.
>
> This patch makes the reasonable assumption that copy_from_user_page() won't
> fail - which is probably fine, as we've checked the VMA from which we're
> copying is usable, and the copy is not allowed to cross VMAs.  The one case
> where it might go wrong is if the VMA is a device rather than RAM, and that
> device returns an error which - in which case rubbish will be returned rather
> than EIO.
>
> Signed-off-by: Jie Zhang <jie.zhang@analog.com>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> Signed-off-by: David Howells <dhowells@redhat.com>

btw, there are also:
Acked-by: David McCullough <david_mccullough@mcafee.com>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Acked-by: Greg Ungerer <gerg@uclinux.org>
-mike
