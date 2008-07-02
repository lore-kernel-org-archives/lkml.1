Return-Path: <linux-kernel-owner+w=401wt.eu-S1757087AbYGBObg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757087AbYGBObg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 10:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754418AbYGBObJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 10:31:09 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:49072 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209AbYGBObH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 10:31:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=M4y/X+bp38PP4DJYZBRq13ErSpSwuRP/ql1O71nAxT6rwrYOXExOlh8yvKPCCnMuCD
         kdZIfoS9i9YJ+MCVcpbh82tPJ7sNIeLWDobVNRT8lv+tyOJdFp36nhjWOK+XlHBmQAZQ
         ExlCMCFZC2GiLRKJh3AQxpyVV2xFBnGHr92WI=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Vitaly Mayatskikh <v.mayatskih@gmail.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] Introduce copy_user_handle_tail routine
References: <m37icazgt0.fsf@gravicappa.englab.brq.redhat.com>
	<alpine.LFD.1.10.0806281108240.4371@hp.linux-foundation.org>
	<m3lk0ngdo5.fsf@gravicappa.englab.brq.redhat.com>
	<alpine.LFD.1.10.0806300835220.28533@hp.linux-foundation.org>
	<m3fxqsjt22.fsf_-_@gravicappa.englab.brq.redhat.com>
	<486B8B6C.2050109@firstfloor.org>
Date: Wed, 02 Jul 2008 16:31:03 +0200
In-Reply-To: <486B8B6C.2050109@firstfloor.org> (Andi Kleen's message of "Wed,
	02 Jul 2008 16:06:36 +0200")
Message-ID: <m37ic4jr2w.fsf@gravicappa.englab.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> get/put user are macros and it's normally not a good idea to use ++ in macro
> arguments because they might expand multiple times.
>
> sizeof(char) is always 1
>
> Also hopefully there's no sign extension anywhere with the signed char

I have tested it a lot. I don't know of any fail scenario at the moment.

> Overall you could write it much simpler with a rep ; movs I think,
> like traditional linux did.

rep movs can fail.

> Similar problem with ++
>
> If zerorest is ever 0 then retesting it on every iteration seems
> somewhat dumb.

If zerorest is 0, this cycle will never be executed.

>
> I think a simple memset would be actually ok, i don't think we ever zero
> anything that faults. That would be obviously racy anyways. If the zero
> are supposed to override something  then a racing user thread could always
> catch it.

Linus wanted this routine to be extremely dumb. This is the reason why tail
handling was moved from assembly to C. Yeah, my original patches were in
assembly and on the top of your realization.

-- 
wbr, Vitaly
