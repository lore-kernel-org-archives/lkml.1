Return-Path: <linux-kernel-owner+w=401wt.eu-S1759904AbZB0VJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759904AbZB0VJo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 16:09:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756244AbZB0VJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 16:09:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59305 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755366AbZB0VJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 16:09:34 -0500
Message-ID: <49A855B7.4090204@zytor.com>
Date: Fri, 27 Feb 2009 13:05:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] x86: add brk allocation for very, very early allocations
References: <49A829CE.9020509@goop.org> <49A84C5A.3020304@kernel.org>
In-Reply-To: <49A84C5A.3020304@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> 
> it seems reserve _brk_end is some late?
> 
> init_memory_mapping(0,...) could get some for direct mapping page table. and it could start from _end...
> 

That would make sense.  init_memory_mapping() needs to know what not to
step on, and that would include the brk at this stage.  For 64-bit mode,
Xen is the only user of !PSE, and so may be particularly vulnerable to
this issue (because of massively larger direct mapping tables.)

This reminds me... is your intent that the BRK is permanent (unless
explicitly freed on a page by page basis) or part of the init memory
that is flushed?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

