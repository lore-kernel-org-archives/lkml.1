Return-Path: <linux-kernel-owner+w=401wt.eu-S1752807AbZBRKHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbZBRKHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 05:07:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbZBRKHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 05:07:00 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:62209 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751396AbZBRKG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 05:06:59 -0500
Subject: Re: [PATCH -mm] kmemleak: Fix section mismatch in kmemleak.c
From: Catalin Marinas <catalin.marinas@arm.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <b9df5fa10902131942q4670aa16s6c190fd99384943e@mail.gmail.com>
References: <b9df5fa10902131942q4670aa16s6c190fd99384943e@mail.gmail.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Wed, 18 Feb 2009 10:06:03 +0000
Message-Id: <1234951563.20374.43.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Feb 2009 10:06:07.0674 (UTC) FILETIME=[844DE9A0:01C991B0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-02-14 at 09:42 +0600, Rakib Mullick wrote:
> Impact: Section mismatch
> 
> The function kmemleak_alloc() is called from kernel allocators.
> kmemleak_alloc() calls log_early() but being log_early() marked as
> __init it causes following section mismatches. Being called from
> kernel allocators, kmemleak_allock() will be called after freeing up
> the init memory and log_early() will also called. So, unmarking __init
> from log_early() fixes the warning. If anything else please notice.

Thanks for the patch. There's nothing dangerous as kmemleak takes care
of not using the __init functions after it was initialised but I
couldn't find a way to free these functions/data and also avoid the
warning.

Anyway, that's fine as an interim patch but I think I'll just allocate
some pages dynamically for the early logging buffer so that we can free
them once initialised. I'll update the kmemleak branch sometime this
week.

Thanks.

-- 
Catalin

