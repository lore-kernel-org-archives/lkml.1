Return-Path: <linux-kernel-owner+w=401wt.eu-S1754868AbZCIS3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbZCIS3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 14:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754013AbZCIS3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 14:29:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49881 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbZCIS3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 14:29:05 -0400
Message-ID: <49B55FBB.7090606@zytor.com>
Date: Mon, 09 Mar 2009 11:28:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: put initial_pg_tables into .bss -v4
References: <1235785882-17580-1-git-send-email-jeremy@goop.org> <1235785882-17580-4-git-send-email-jeremy@goop.org> <86802c440902272302n3787b2bex3741b46a372a19b0@mail.gmail.com> <49A8E235.6010900@goop.org> <20090228071534.GB9351@elte.hu> <49A8EA1A.50802@kernel.org> <49A8ED3D.1060704@kernel.org> <49A8F319.3030802@goop.org> <49A9E392.6090004@kernel.org> <49AA47D2.4020804@kernel.org> <49AA5356.3050602@zytor.com> <49AACEB3.5050206@kernel.org> <49AB1A5C.6040300@zytor.com> <49AB2E69.1010201@kernel.org> <49B4D03D.7030205@kernel.org> <49B538AB.9080006@zytor.com> <49B5534D.6090109@kernel.org>
In-Reply-To: <49B5534D.6090109@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> 
> it just estimates initial_pg_tables size, and make _end a little bigger (1M), so boot loader could have idea of correct size of vmlinux aka the uncompressed size of in kernel.
> 
> I assume brk patches could estimate the extra size that it needs too.
> 

Yes, and I have made that point several times in this thread already.

I really like the brk interface because it's a clean, general-purpose 
allocator.

We can create a brk segment in vmlinux (and even bound the brk to catch 
overflows, instead of randomly failing) to advertise the presence of the 
brk.

	-hpa

