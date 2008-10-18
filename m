Return-Path: <linux-kernel-owner+w=401wt.eu-S1752168AbYJRFmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbYJRFmS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 01:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751188AbYJRFmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 01:42:05 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:37150 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbYJRFmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 01:42:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jIfcJBEDv8vAPhH1tFk4rbc6A9fvbQhEZZ/gHcL1pipFMPrrQx77A2zev9tOQLaGk0
         CXWFcYvbKIez8h+OOyDe3/I0/SPLlKrrnKx8TTzUuXe33KBreqdjOkJEBRjTjgmLCjy1
         1ueRlBjQPHMb88INtpTwQjFmy53DuxjsZgMcg=
Message-ID: <a36005b50810172242u2ffd1049n68d956dbcd6e3fc2@mail.gmail.com>
Date: Fri, 17 Oct 2008 22:42:01 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Kees Cook" <kees.cook@canonical.com>
Subject: Re: [PATCH v5] ELF: implement AT_RANDOM for glibc PRNG seeding
Cc: "Ulrich Drepper" <drepper@redhat.com>, "Jakub Jelinek" <jakub@redhat.com>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Roland McGrath" <roland@redhat.com>, linux-kernel@vger.kernel.org,
       libc-alpha@sourceware.org, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <20081003175917.GX10632@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081001222706.68E7E1544B4@magilla.localdomain>
	 <20081003004340.GF32682@tyan-ft48-01.lab.bos.redhat.com>
	 <20081003052938.GS10632@outflux.net>
	 <20081002225718.6a0d803a@infradead.org> <48E5BAC6.9070007@redhat.com>
	 <20081003145054.GU10632@outflux.net>
	 <20081003145754.GH32682@tyan-ft48-01.lab.bos.redhat.com>
	 <20081003173313.GW10632@outflux.net> <48E65964.5020809@redhat.com>
	 <20081003175917.GX10632@outflux.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 3, 2008 at 10:59 AM, Kees Cook <kees.cook@canonical.com> wrote:
> While discussing[1] the need for glibc to have access to random bytes
> during program load, it seems that an earlier attempt to implement
> AT_RANDOM got stalled.  This implements a random 16 byte string, available
> to every ELF program via a new auxv AT_RANDOM vector.
>
> [1] http://sourceware.org/ml/libc-alpha/2008-10/msg00006.html
>
> Signed-off-by: Kees Cook <kees.cook@canonical.com>
> ---
>  fs/binfmt_elf.c        |   12 ++++++++++++
>  include/linux/auxvec.h |    6 +++---
>  2 files changed, 15 insertions(+), 3 deletions(-)

This version is OK with me as long as the get_random_bytes call is
producing 16 reasonably random bytes.  If the random data generation
is changed at some point I'd want to have very strong PRNG for
binaries which have AT_SECURE set.

Acked-by: Ulrich Drepper <drepper@redhat.com>
