Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589Ab0CLIjU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 03:39:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36877 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756280Ab0CLIjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 03:39:18 -0500
Message-ID: <4B99FD4D.4090206@redhat.com>
Date: Fri, 12 Mar 2010 10:37:33 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org
Subject: Re: [BUGFIX] Fix AES-NI CTR optimization compiling failure with gas
 2.16.1
References: <1268377307.1640.491.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1268377307.1640.491.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2010 09:01 AM, Huang Ying wrote:
> Andrew Morton reported that AES-NI CTR optimization failed to compile
> with gas 2.16.1, the error message is as follow:
>
> arch/x86/crypto/aesni-intel_asm.S: Assembler messages:
> arch/x86/crypto/aesni-intel_asm.S:752: Error: suffix or operands invalid for `movq'
> arch/x86/crypto/aesni-intel_asm.S:753: Error: suffix or operands invalid for `movq'
>
> To fix this, a gas macro is defined to assemble movq with 64bit
> general purpose registers and XMM registers. The macro will generate
> the raw .byte sequence for needed instructions.
>
>    

Eventually you'll port the entire assembler into macros, as instructions 
are introduced more frequently that people upgrade their assemblers.  
Maybe we should disable the new features and warn people (and distros) 
to upgrade their tools instead.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

