Return-Path: <linux-kernel-owner+w=401wt.eu-S1762575AbXGSLug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762575AbXGSLug (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 07:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbXGSLu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 07:50:26 -0400
Received: from depni.sinp.msu.ru ([213.131.7.21]:58026 "EHLO depni.sinp.msu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753796AbXGSLuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 07:50:25 -0400
To: Andi Kleen <ak@suse.de>
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [2/58] x86_64: Tell gcc to only align stack to 8 bytes
References: <200707191154.642492000@suse.de>
	<20070719095445.DC94514E04@wotan.suse.de>
From: Serge Belyshev <belyshev@depni.sinp.msu.ru>
Date: Thu, 19 Jul 2007 15:50:20 +0400
In-Reply-To: <20070719095445.DC94514E04@wotan.suse.de> (Andi Kleen's message of "Thu\, 19 Jul 2007 11\:54\:45 +0200 \(CEST\)")
Message-ID: <87wswwsjcz.fsf@depni.sinp.msu.ru>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/23.0.0 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <ak@suse.de> writes:

> Don't need 16 byte alignment because kernel doesn't use SSE2
>
...
>  cflags-y += -maccumulate-outgoing-args
> +cflags-y += -mpreferred-stack-boundary=4
>  

>From gcc manpage:

       -mpreferred-stack-boundary=num
           Attempt to keep the stack boundary aligned to a 2 raised to num
           byte boundary.  If -mpreferred-stack-boundary is not specified, the
           default is 4 (16 bytes or 128 bits), except when optimizing for
           code size (-Os), in which case the default is the minimum correct
           alignment (4 bytes for x86, and 8 bytes for x86-64).

So -mpreferred-stack-boundary=4 is the default and to align stack
to 8 bytes you want -mpreferred-stack-boundary=3, not 4, IIUC.
