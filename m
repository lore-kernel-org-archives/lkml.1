Return-Path: <linux-kernel-owner+w=401wt.eu-S1758243AbZASDF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243AbZASDF5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 22:05:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757479AbZASDFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 22:05:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:34953 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757330AbZASDFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 22:05:48 -0500
Message-ID: <4973EE03.2060106@kernel.org>
Date: Mon, 19 Jan 2009 12:05:39 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] x86-64: Remove the PDA
References: <73c1f2160901181651w3dff5e2co762b767168416c92@mail.gmail.com>	 <1232326345-3534-1-git-send-email-brgerst@gmail.com>	 <1232326345-3534-2-git-send-email-brgerst@gmail.com>	 <1232326345-3534-3-git-send-email-brgerst@gmail.com>	 <1232326345-3534-4-git-send-email-brgerst@gmail.com>	 <4973E30D.3030102@kernel.org> <73c1f2160901181852q1c063011lf9d4588ce9a19dd1@mail.gmail.com>
In-Reply-To: <73c1f2160901181852q1c063011lf9d4588ce9a19dd1@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 19 Jan 2009 03:05:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Brian.

Brian Gerst wrote:
>> As discussed before, the above chunks do drop one #ifdef CONFIG_SMP
>> but it does add a obscure relocation and please note that it's
>> different from early_gdt_descr.  early_gdt_descr is needed to bring up
>> the cpu so there's no other way to do it but to relocate it in
>> assembly.  If you absolutely have to relocate irq_stack_ptr early,
>> please do it in C code in head64.c but then again irq_stack_ptr is not
>> even necessary till traps_init() which is way after per cpu area
>> setup.  So, the above two chunks are not necessary && even if they go
>> in, they don't have much to do with this patch.
> 
> I'll give you that this particular variable doesn't need early
> adjustment currently.  I'd prefer if you left the ifdef off the first
> hunk, though.  A comment will suffice to document that the initial
> value is going to be overwritten later on SMP.

Yeah, maybe.  I don't know.  If we ever get to a point where we can
fully initialize per cpu area for cpu0, things like this can probably
go away, but for now, I just thought it would be better to make it
clear that UP and SMP are taking different initialization paths &&
that was how the code looked like before this patch, so...  But no big
deal one way or another, right?

Thanks.

-- 
tejun
