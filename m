Return-Path: <linux-kernel-owner+w=401wt.eu-S935203AbXJQRDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935203AbXJQRDe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 13:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762292AbXJQRD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 13:03:27 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:44410 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758730AbXJQRD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 13:03:26 -0400
Subject: Re: 2.6.23-git11 compile issues
From: Dave Hansen <haveblue@us.ibm.com>
To: Badari Pulavarty <pbadari@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Andi Kleen <ak@muc.de>
In-Reply-To: <1192635199.14504.2.camel@dyn9047017100.beaverton.ibm.com>
References: <1192635199.14504.2.camel@dyn9047017100.beaverton.ibm.com>
Content-Type: text/plain
Date: Wed, 17 Oct 2007 10:03:14 -0700
Message-Id: <1192640594.17464.37.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-10-17 at 08:33 -0700, Badari Pulavarty wrote:
> Known issue ?
...
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CC      arch/x86/kernel/asm-offsets.s
> In file included from arch/x86/kernel/asm-offsets_64.c:7,
>                  from arch/x86/kernel/asm-offsets.c:4:
> include/linux/crypto.h:20:24: error: asm/atomic.h: No such file or directory
> In file included from include/linux/types.h:14,
>                  from include/linux/prefetch.h:13,
>                  from include/linux/list.h:8,
>                  from include/linux/module.h:9,
>                  from include/linux/crypto.h:21,
>                  from arch/x86/kernel/asm-offsets_64.c:7,
>                  from arch/x86/kernel/asm-offsets.c:4:

I hit the same thing, and fixed it with mrproper as well.  I assume this
is a result of the x86 merge.

Andi, is there a way we can detect the old include directories, and
error out?  Otherwise, we're going to get a ton more of these reports
when people do incremental patching up to 2.6.24.  I've been doing
nightly incremental builds for a year or two, and I think this is the
first time it has actually required manual intervention.

-- Dave

