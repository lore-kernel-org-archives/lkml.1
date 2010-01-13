Return-Path: <linux-kernel-owner+w=401wt.eu-S1755038Ab0AMIyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038Ab0AMIyB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 03:54:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754840Ab0AMIyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 03:54:00 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:33533 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384Ab0AMIx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 03:53:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=YmqKRVApqFquBgPXATCEJCHibejIy+gkU04RDSKhxYmTgMA1dKZ3J3wX8k38NuAdnk
         UcYf8NLfprkGIH5b96th4gC30Y8x3Khgxl4Zn0+ioN2HRSq7kcbvbWHbpLbC8XWoV2D3
         4OnLEGEBicEf3JAJeVkLZZkg10PwoXFgfaQxU=
Message-ID: <4B4D8A24.4070108@gmail.com>
Date: Wed, 13 Jan 2010 03:53:56 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Michael Chan <mchan@broadcom.com>
Subject: Re: [PATCH 1/2] net: tcp_header_len_th and tcp_option_len_th
References: <4B44FE3C.6060809@gmail.com> <4B450065.4010108@gmail.com> <4B4C519E.2090207@gmail.com> <4B4CB46C.8020502@gmail.com> <4B4CB712.8030806@gmail.com>
In-Reply-To: <4B4CB712.8030806@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> I type my Changelog text, add my signature, then copy/paste patch from external editor
> (this editor must preserve tabulations of course)
> 
That doesn't work properly on a Mac, copying from BBEdit to Thunderbird.

BBEdit preserves tabs and even understands and preserves Unix LF (and
I've been using it for a Unix editor since it was included with Xinu in
early '90s), but the MacOS copy and paste seems to mangle it.

I'll try again someday with Thunderbird 3, when it's had time to mature.


> About cast games, maybe following way is the cleanest one.
> 
> int tcp_options_len_th(struct tcphdr *th)
> {
> 	return tcp_header_len_th(th) - sizeof(*th);
> }
> 
If you'd have been one of my C students, you'd have failed the exam
question.  That's unsigned int tcp_header_len_th() -- subtracting an
untyped constant could be a negative number (stored in an unsigned).
Then demotion to int (which many compilers truncate to a very large
positive number).

It's one of the reasons that folks used to do all this with macros, so
that the types and truncation were handled well by the compiler.

Of course, this is an inline function, which is more like macros.  I've
not studied how gcc works internally since egcs.

Let's keep (int)(th->doff * 4) - sizeof(*th) -- self documenting, and
should work with a wide variety of compilers.
