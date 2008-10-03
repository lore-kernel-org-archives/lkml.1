Return-Path: <linux-kernel-owner+w=401wt.eu-S1753190AbYJCOY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190AbYJCOY2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 10:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752807AbYJCOYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 10:24:18 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:37109 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796AbYJCOYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 10:24:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=iALApIyGCi91GUjgnjcU8DkhiROUXFvNmGWtY5CEamDPM6GDEIdggb/ITBRufR2wmA
         AXk0+xoIYoeIUb51Cy2RIVL9Kp4IEzfYZkdWpxfxgYPYIuXc/TYE7suV9IYbz9M0D6Y8
         l+YgHw+MPkxVsd0f0PgUOkBZub9ZUsPfxuAeA=
Message-ID: <48E62AF7.5040008@gmail.com>
Date: Fri, 03 Oct 2008 16:23:51 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] x86: fix virt_addr_valid() with CONFIG_DEBUG_VIRTUAL=y
 (try 2)
References: <20081003140720.GA14261@localhost.localdomain>
In-Reply-To: <20081003140720.GA14261@localhost.localdomain>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum napsal(a):
> How about this? It would apply to tip/x86/mm-debug. Untested.

It is wrong in my eyes -- it's workarounding of the real problem rather than
fixing. virt_addr_valid() should be fixed/augmented to the full virtual
address domain instead or not used for the purpose you need in kmemcheck.

As it is now, it should be used only on direct mapping addresses (more
concrete: kernel image space and physical mapping) and it returns
semi-random values on the rest -- with CONFIG_DEBUG_VIRTUAL=y it screams
instead of returning a bogus value.
