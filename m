Return-Path: <linux-kernel-owner+w=401wt.eu-S1753385AbZK1Srl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbZK1Srl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 13:47:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752867AbZK1Srk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 13:47:40 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:35079 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbZK1Srj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 13:47:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=uUB04cvaJv4rwfqpfghSJz+9jcvWTdv4gkEtVjuAZDbSa0gWgPq3wUmeqaISwnUdZt
         6tyMnJO6gHZgJq3audPiiIbRJTJHFvtj6YMgl39xLJnQp0haP986P2+V25tnYnOq+12c
         5zl6XIKDzkUJsbORoaGxlncvXQdajUL8nOzsw=
MIME-Version: 1.0
In-Reply-To: <1259421863-12777-1-git-send-email-vapier@gentoo.org>
References: <1259421863-12777-1-git-send-email-vapier@gentoo.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sat, 28 Nov 2009 13:47:26 -0500
Message-ID: <8bd0f97a0911281047i25626fc5q622e06fa1d306441@mail.gmail.com>
Subject: Re: [uClinux-dev] [PATCH] FDPIC: respect PT_GNU_STACK exec markings 
	when creating NOMMU stack
To: uClinux development list <uclinux-dev@uclinux.org>
Cc: David Howells <dhowells@redhat.com>,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       Paul Mundt <lethal@linux-sh.org>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 28, 2009 at 10:24, Mike Frysinger wrote:
> The current code will load the stack size and markings, but then only use
> the markings in the MMU code path.  The NOMMU code path always passes EXEC
> to the mmap() call.  While this doesn't matter to most people during the
> run of the code, it causes a pointless icache flush when starting every
> FDPIC application and by default, that tends to be 128kB of waste.

for some raw numbers:
with my default FDPIC boot (inetd/syslog/watchdog), we icache flush
18,562,124 bytes.  with this stack fix, we cut off 3,538,944 bytes
(19% shrinkage).
-mike
