Return-Path: <linux-kernel-owner+w=401wt.eu-S1757265AbZELGaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265AbZELGaX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 02:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754984AbZELGaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 02:30:08 -0400
Received: from ti-out-0910.google.com ([209.85.142.191]:31403 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888AbZELGaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 02:30:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=V6M4fpO2mIQWbf6A4IAu5cK7v5MsuNFYQVHPsV9LSAz77ZiRtmLAk32G9PiNzDo9PM
         tCz/+0E6nEEm7KWMoL+ByYnP4UlFtGASj9t0hNA6dj1wkBJQIapdUxrU9XfRW3tZf9sS
         vM9Sn5ly+LmB8fQUdg7Ah6cPc192YiQFAmkpo=
MIME-Version: 1.0
In-Reply-To: <20090512052139.GE32535@wotan.suse.de>
References: <20090512052139.GE32535@wotan.suse.de>
Date: Tue, 12 May 2009 14:30:05 +0800
Message-ID: <2375c9f90905112330x53d75c5ag3693bf5576032608@mail.gmail.com>
Subject: Re: [patch] mm: madvise correct return code
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 1:21 PM, Nick Piggin <npiggin@suse.de> wrote:
> This is a pretty obscure case, but it doesn't hurt to follow standards
> if they're there. I can't imagine any real program relying on a 0 range
> madvise call with invalid behaviour *not* failing... We have this in
> SLES11 FWIW, and no problems reported.
> --


But it was not consistent with the man page... we should fix it.

>
> mm: madvise correct return code
>
> The posix_madvise() function succeeds (and does nothing) when called with
> parameters (NULL, 0, -1); according to LSB tests, it should fail with EINVAL
> because -1 is not a valid flag.
>
> When called with a valid address and size, it correctly fails.
>
> So perform an initial check for valid flags first.
>
> Reported-by: Jiri Dluhos <jdluhos@novell.com>
> Signed-off-by: Nick Piggin <npiggin@suse.de>

Reviewed-and-Tested-by: WANG Cong <xiyou.wangcong@gmail.com>
