Return-Path: <linux-kernel-owner+w=401wt.eu-S1755282Ab0AMKAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab0AMKAX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:00:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753907Ab0AMKAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:00:22 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:57099 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235Ab0AMKAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:00:22 -0500
Message-ID: <4B4D99B0.8090102@gmail.com>
Date: Wed, 13 Jan 2010 11:00:16 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: William Allen Simpson <william.allen.simpson@gmail.com>
CC: Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Michael Chan <mchan@broadcom.com>
Subject: Re: [PATCH 1/2] net: tcp_header_len_th and tcp_option_len_th
References: <4B44FE3C.6060809@gmail.com> <4B450065.4010108@gmail.com> <4B4C519E.2090207@gmail.com> <4B4CB46C.8020502@gmail.com> <4B4CB712.8030806@gmail.com> <4B4D8A24.4070108@gmail.com>
In-Reply-To: <4B4D8A24.4070108@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Wed, 13 Jan 2010 11:00:17 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 13/01/2010 09:53, William Allen Simpson a écrit :
> Eric Dumazet wrote:
> 
>> About cast games, maybe following way is the cleanest one.
>>
>> int tcp_options_len_th(struct tcphdr *th)
>> {
>>     return tcp_header_len_th(th) - sizeof(*th);
>> }
>>
> If you'd have been one of my C students, you'd have failed the exam
> question.  That's unsigned int tcp_header_len_th() -- subtracting an
> untyped constant could be a negative number (stored in an unsigned).
> Then demotion to int (which many compilers truncate to a very large
> positive number).

Thats simply not true, you are very confused.

Once again you type too much text and ignore my comments.
I really would hate being your student, thanks God it wont happen in this life.

1) You wrote tcp_header_len_th(), you should know that it
returns an unsigned int.

2) You also should know that sizeof() is *strongly* typed (size_t),
not an "untyped constant".

unsigned int arg = some_expression;
size_t sz = sizeof(something)
int res = arg - sz;
return res;

is *perfectly* legal and very well defined by C standards.

It *will* return a negative value is arg < sz



> 
> It's one of the reasons that folks used to do all this with macros, so
> that the types and truncation were handled well by the compiler.
> 
> Of course, this is an inline function, which is more like macros.  I've
> not studied how gcc works internally since egcs.
> 
> Let's keep (int)(th->doff * 4) - sizeof(*th) -- self documenting, and
> should work with a wide variety of compilers.

So you wrote tcp_header_len_th(), but you keep (th->doff * 4) thing all over
the code...

The (int) cast it not only _not_ needed, its also confusing.

