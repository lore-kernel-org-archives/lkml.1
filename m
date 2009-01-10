Return-Path: <linux-kernel-owner+w=401wt.eu-S1755212AbZAJJfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbZAJJfi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 04:35:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbZAJJfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 04:35:23 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:64475 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbZAJJfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 04:35:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=TtsP9HQmp3j937iR/Ss/IZxxLDw0lTBQfunLkOkvaOKlGOQ+XIotoajq6S5nB6nHOo
         np3pO7TVWfY1hGq1WxZSQdlC1PXb6BX8wWxsyTB6EQ9WLW62ToRW5truzexFtSz/4qdm
         dCiTyTCBGnS7PQCuNDBOZNl0Oq3WilJQ4FHZc=
Message-ID: <f19298770901100135m7cd9c6a1k52f92e66e5b41b79@mail.gmail.com>
Date: Sat, 10 Jan 2009 12:35:18 +0300
From: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
To: "Harvey Harrison" <harvey.harrison@gmail.com>
Subject: Re: [PATCH] Disable branch profiling macros when sparsed.
Cc: "David Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, rostedt@goodmis.org
In-Reply-To: <1231571906.5714.30.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090110052727.5471.3654.stgit@zaytsev.su>
	 <20090109.221348.166902734.davem@davemloft.net>
	 <1231571906.5714.30.camel@brick>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2009 at 10:18, Harvey Harrison
<harvey.harrison@gmail.com> wrote:
> On Fri, 2009-01-09 at 22:13 -0800, David Miller wrote:
>> From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
>> Date: Sat, 10 Jan 2009 08:57:28 +0300
>>
>> > The macros produce lots of unneeded warnings when
>> > recursive if(({ .. if() {..} ..})) {..} and such
>> > are substituted. And there is no point in sparsing
>> > them anyway. This is useful if someone decides to
>> > sparse an allyesconfig kernel.
>> >
>> > Signed-off-by: Alexey Zaytsev <alexey.zaytsev@gmail.com>
>>
>> If even sparse can't handle these things, it's no surprise
>> how many gcc bogus warning problems we've run into because
>> of this hairy if() macro.
>
> It's not that sparse can't handle it, the warning is valid,
> _____r and ______f are shadowed when these get nested.  It
> gets even worse when interacting with likely/unlikely tracing
> as that chose the same identifiers too.  So there the noise
> could be drastically reduced changing the different identifiers
> for the if () and __branch_check macros, but nesting will always
> warn.
>
> I've just been setting this to no in my allyesconfig sparse
> runs....just wait until kmemtrace gets to mainline, then it
> gets really bad :(
>

I don't really understand what is bad here. The 'unlikely' and 'if'
trace implementation looks quite elegant to me. Yes, they generate
10kbyte spaghetti monsters (in C) for a simple WARN_ON_ONCE(),
but probably we should just remove a few unlekely() from the WARN_*
code, and I'm not sure it's even worth it. There would be no direct
speedup.

And it took only one line to disable.
