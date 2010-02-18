Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab0BRStp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 13:49:45 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:47647 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761Ab0BRStn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 13:49:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=k6yl4if4LgM79j57VgHYFkqpLzLqGcXBK3cgL+d/1pOTxgkURDqDOexgwi3FK0J8mY
         67OTPUdBLO5PpFo3o5X4v+s/GrNFQD0eflvadz7Ye/OLUsDrc617THJfSk6D096D7eWC
         Hz2j9rkpgMD9fxZTa5akvU9FwLTf7RpGqgQMA=
MIME-Version: 1.0
In-Reply-To: <4B7D7060.1080908@zytor.com>
References: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com>
	 <1266406962-17463-10-git-send-email-luca@luca-barbieri.com>
	 <87eikj54wp.fsf@basil.nowhere.org>
	 <ff13bc9a1002180153g308b0f3dxb59959936d1e343b@mail.gmail.com>
	 <20100218101156.GE5964@basil.fritz.box>
	 <ff13bc9a1002180227j70e0748ag49d88c3034e3900d@mail.gmail.com>
	 <4B7D7060.1080908@zytor.com>
Date: Thu, 18 Feb 2010 19:49:41 +0100
X-Google-Sender-Auth: 78c06ef8b95e4c6e
Message-ID: <ff13bc9a1002181049v2605b442y9f33008548b58d48@mail.gmail.com>
Subject: Re: [PATCH 09/10] x86-32: use SSE for atomic64_read/set if available
From: Luca Barbieri <luca@luca-barbieri.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This really sounds like the wrong optimization.  These functions aren't
> exactly all that complex in assembly (which would also allow them to be
> simple cli/do stuff/sti), and instead relying on gcc features which may
> or may not be well supported on x86 is inviting breakage down the line.
>
> That is particularly damaging, since the remaining 486-class users tend
> to be deeply embedded and thus we only find problems later.

There is the downside of adding a whole 386/486-specific implementation.

It's not too hard though, and if we don't care about 486 SMP, it may
be a better option.
