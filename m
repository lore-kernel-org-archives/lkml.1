Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662Ab0BRQyA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 11:54:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39514 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758521Ab0BRQx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 11:53:59 -0500
Message-ID: <4B7D7060.1080908@zytor.com>
Date: Thu, 18 Feb 2010 08:52:48 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Luca Barbieri <luca@luca-barbieri.com>
CC: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/10] x86-32: use SSE for atomic64_read/set if available
References: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com>	 <1266406962-17463-10-git-send-email-luca@luca-barbieri.com>	 <87eikj54wp.fsf@basil.nowhere.org>	 <ff13bc9a1002180153g308b0f3dxb59959936d1e343b@mail.gmail.com>	 <20100218101156.GE5964@basil.fritz.box> <ff13bc9a1002180227j70e0748ag49d88c3034e3900d@mail.gmail.com>
In-Reply-To: <ff13bc9a1002180227j70e0748ag49d88c3034e3900d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2010 02:27 AM, Luca Barbieri wrote:
>> So why don't you simply use normal asm inputs/outputs?
> I do, on the caller side.
> 
> In the callee, I don't see any other robust way to implement parameter
> passing in ebx/esi other than global register variables (without
> resorting to pure assembly, which would prevent reusing the generic
> atomic64 implementation).

This really sounds like the wrong optimization.  These functions aren't
exactly all that complex in assembly (which would also allow them to be
simple cli/do stuff/sti), and instead relying on gcc features which may
or may not be well supported on x86 is inviting breakage down the line.

That is particularly damaging, since the remaining 486-class users tend
to be deeply embedded and thus we only find problems later.

	-hpa
