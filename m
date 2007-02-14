Return-Path: <linux-kernel-owner+w=401wt.eu-S932275AbXBNN02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275AbXBNN02 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 08:26:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932274AbXBNN02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 08:26:28 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:41107 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932275AbXBNN01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 08:26:27 -0500
Message-ID: <45D30DEA.4020309@hitachi.com>
Date: Wed, 14 Feb 2007 22:26:02 +0900
From: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
Cc: Robin Holt <holt@sgi.com>, akpm@osdl.org, linux-kernel@vger.kernel.org,
       dhowells@redhat.com, alan@lxorguk.ukuu.org.uk,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>,
       "Hideo AOKI@redhat" <haoki@redhat.com>
Subject: Re: [PATCH 0/4] coredump: core dump masking support v2
References: <45BA0A93.30004@hitachi.com> 
    <20070126152907.GB30950@lnx-holt.americas.sgi.com> 
    <45BEF582.7080004@hitachi.com> 
    <20070130124417.GA7320@lnx-holt.americas.sgi.com> 
    <45C08E33.9030300@hitachi.com> <20070203124853.GA4191@elf.ucw.cz>
In-Reply-To: <20070203124853.GA4191@elf.ucw.cz>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm sorry that I couldn't reply you sooner.

Pavel Machek wrote:
>>Okay, I'll adopt your idea in the next version.
>>I'm going to provide the proc entry as follows:
>>
>>  (1) /proc/<pid>/core_flags/flags
>>  (2) /proc/<pid>/core_flags/omit_anon_shared
>>
>>(1) is the same as current core_flags. It is for expert users.
>>(2) corresponds to one bit in (1).
>>If (2) is set to 1, anonymous shared memory of the process is never
>>dumped.
> 
> Now, that's what I call an ugly interface.

I considered for a while, and then I decided not to use the
above-stated interfaces. Instead, I'll create just one proc entry
to access to one core dump flag:
  /proc/<pid>/coredump_omit_anonymous_shared

I think it is simple enough.
Would you think it is still ugly?

 
> Can we simply add ulimit with boolean value, that says dump
> anon_shared... or not? It will be simpler and faster, because you'll
> not need locking.

Yes, using ulimit will be simpler and faster, but less flexible.
The core dump flags can be changed only before running the program.
If the user modifies the program, the user will be able to change the
flags anytime. But the user can't always modify the program.

I need the ability to change the core dump flags anytime.


Thanks,
-- 
Hidehiro Kawai
Hitachi, Ltd., Systems Development Laboratory

