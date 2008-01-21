Return-Path: <linux-kernel-owner+w=401wt.eu-S1761320AbYAUPlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761320AbYAUPlU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 10:41:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753063AbYAUPlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 10:41:11 -0500
Received: from relay2.sgi.com ([192.48.171.30]:47115 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751920AbYAUPlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 10:41:10 -0500
Message-ID: <4794BD0F.3050701@sgi.com>
Date: Mon, 21 Jan 2008 07:41:03 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: akpm@linux-foundation.org, ak@suse.de, mingo@elte.hu, clameter@sgi.com,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, rusty@rustcorp.com.au
Subject: Re: [PATCH 1/7] Modules: Fold percpu_modcopy into module.c
References: <20080118182953.748071000@sgi.com>	<20080118182953.922370000@sgi.com> <20080121.000820.194841023.davem@davemloft.net>
In-Reply-To: <20080121.000820.194841023.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: travis@sgi.com
> Date: Fri, 18 Jan 2008 10:29:54 -0800
> 
>> percpu_modcopy() is defined multiple times in arch files. However, the only
>> user is module.c. Put a static definition into module.c and remove
>> the definitions from the arch files.
>>
>> Cc: Rusty Russell <rusty@rustcorp.com.au>
>> Cc: Andi Kleen <ak@suse.de>
>> Signed-off-by: Christoph Lameter <clameter@sgi.com>
>> Signed-off-by: Mike Travis <travis@sgi.com>
> 
> This doesn't build on sparc64.
> 
> The percpu_modcopy() removal from include/asm-sparc64/percpu.h
> leaked into patch #3 instead of being done here in patch #1
> where it belongs (so that this series is properly bisectable).
> 
> It also seems that the include/asm-x86/percpu_{32,64}.h defines
> aren't removed in this patch either.

Hi,

I think I have this fixed in the newest version.  Yes, it's been
a hat dance with some changes coming through the git-x86 patch
and others not.  I'll submit the new one shortly.

Thanks,
Mike
