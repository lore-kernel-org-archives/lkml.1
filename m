Return-Path: <linux-kernel-owner+w=401wt.eu-S1755284AbYHFMwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbYHFMwh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 08:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160AbYHFMwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 08:52:05 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:53919 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111AbYHFMwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 08:52:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=iJrPlWiR1wcW4KgNE/1KbEYgTZHmLWeQdpGQrujCru0W0Wlu5OlmujB4ztSuTwPuK3
         DFCIWMAuLJb6LKi7+630bFyoWPK/lFPy5xuAVCfghBR+qiR5tVD5oRFmsQPCa7zewLbx
         4YBDggTtfcDPqUqebbGooiJC1O2MdCHUX8k6Y=
Message-ID: <19f34abd0808060552g65d61647o7df045afccae9b3a@mail.gmail.com>
Date: Wed, 6 Aug 2008 14:52:01 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Subject: Re: [PATCH] blackfin/sram: use 'unsigned long' for irqflags
Cc: "Bryan Wu" <cooloney@kernel.org>, "Julia Lawall" <julia@diku.dk>,
       "Alexey Dobriyan" <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <8bd0f97a0808060514x5c9ed37exbf8f9852b5a0b55d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080806105836.GA2903@localhost.localdomain>
	 <8bd0f97a0808060405qf70ead2t2f2604802875197e@mail.gmail.com>
	 <19f34abd0808060428m1c317531v4a58679c4051c0e9@mail.gmail.com>
	 <8bd0f97a0808060514x5c9ed37exbf8f9852b5a0b55d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 6, 2008 at 2:14 PM, Mike Frysinger <vapier.adi@gmail.com> wrote:
>>>> The patch was generated using the Coccinelle semantic patch framework.
>>>
>>> spam ?
>>
>> Hm? I'm sorry, I don't understand what you mean by that. Do you think
>> the credit is undeserved?
>
> *shrug* ... i dont see other patches with things like:
> The patch was generated with git.
> The patch was generated with eclipse.
> The patch was generated with emacs.
> etc...
>
> we dont generally list all of the tools in the log message that was
> used in *creating* a patch since it doesnt really add any value when
> looking back historically at changes.

Hm. I agree that git/eclipse/emacs/etc. information is not very
useful. However...

For errors found with lockdep, we usually put either the lockdep
output in the commit message or say that it was found with lockdep.
Having this information in the log is useful because it also
establishes a track record for the tool which was used to discover/fix
the error.

Arguably, the semantic patch itself should be present in the log as
well. There are different practices here, but in this case, the patch
was quite long, and has already been included in a pending commit. Now
others may use the same semantic patch (or a variation of it) and
possibly find more "bad" code (possibly introduced after the semantic
patch was first applied!).

It seems that the practice of including a reference to the tool is
already widespread, though, for example:

    $ git log v2.6.26-rc2 | grep -ci 'semantic patch'
    72

    $ git log v2.6.26-rc2 | grep -ci coverity
    495

etc.


Vegard

PS: This is a bit of a sore spot for me having been directly involved
with the development of another such tool (kmemcheck). I will always
ask for kmemcheck to be credited in the log whenever it is used to
find and fix genuine programmer errors, simply because that's the best
way to measure its usefulness :-)

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
