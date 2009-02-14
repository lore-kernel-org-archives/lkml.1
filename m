Return-Path: <linux-kernel-owner+w=401wt.eu-S1753494AbZBNUCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbZBNUCr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 15:02:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbZBNUCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 15:02:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40346 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbZBNUCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 15:02:38 -0500
Message-ID: <49972355.3000707@zytor.com>
Date: Sat, 14 Feb 2009 12:02:29 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alexander van Heukelum <heukelum@fastmail.fm>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/6] x86 tip asm ENTRY,ENDPROC cleanup
References: <20090213215017.959278111@gmail.com> <1234567411.13034.1300286953@webmail.messagingengine.com> <49961178.6040101@zytor.com> <1234611775.19975.1300340003@webmail.messagingengine.com>
In-Reply-To: <1234611775.19975.1300340003@webmail.messagingengine.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander van Heukelum wrote:
> 
> Hi Peter,
> 
> I see. But that would be new behaviour. I would propose to use
> completely separate macro's to handle frame-setup code generation,
> and keep ENTRY/GLOBAL/END/ENDPROC only for setting metadata and
> alignment. I think it's worth it to spell out code-generating
> macro's explicitly: there are not that many asm functions, and
> quite a few of them would need special handling. I think noone
> wants to see an ENDPROC_NOFRAMETEARDOWN ;).
> 
> The common-case example would look like this.
> 
> GLOBAL(c_callable_function)
>         ENTER
>         [asm-code]
>         LEAVE
>         ret
> ENDPROC(c_callable_function)
> 

I guess I'm a bit concerned about people omitting them, but it's equally
concerning that people use the wrong macros, so yes, it's probably the
better thing in the long run.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

