Return-Path: <linux-kernel-owner+w=401wt.eu-S1760172AbZB0VUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760172AbZB0VUB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 16:20:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756777AbZB0VTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 16:19:53 -0500
Received: from gw.goop.org ([64.81.55.164]:57524 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753576AbZB0VTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 16:19:52 -0500
Message-ID: <49A858E8.3070707@goop.org>
Date: Fri, 27 Feb 2009 13:19:36 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] x86: add brk allocation for very, very early allocations
References: <49A829CE.9020509@goop.org> <49A84C5A.3020304@kernel.org> <49A855B7.4090204@zytor.com>
In-Reply-To: <49A855B7.4090204@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> That would make sense.  init_memory_mapping() needs to know what not to
> step on, and that would include the brk at this stage.  For 64-bit mode,
> Xen is the only user of !PSE, and so may be particularly vulnerable to
> this issue (because of massively larger direct mapping tables.)
>   

Yep.

> This reminds me... is your intent that the BRK is permanent (unless
> explicitly freed on a page by page basis) or part of the init memory
> that is flushed?
>   

Permanent.  I'm using it to allocate things which are the moral 
equivalent of the kernel pagetables.

    J
