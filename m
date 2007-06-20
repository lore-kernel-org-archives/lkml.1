Return-Path: <linux-kernel-owner+w=401wt.eu-S1759395AbXFTBWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759395AbXFTBWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 21:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757556AbXFTBWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 21:22:45 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:33980 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757388AbXFTBWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 21:22:45 -0400
X-Greylist: delayed 77928 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Jun 2007 21:22:44 EDT
Message-ID: <46788157.9030200@hitachi.com>
Date: Wed, 20 Jun 2007 10:22:31 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Tom Zanussi <zanussi@us.ibm.com>
Cc: David Wilder <dwilder@us.ibm.com>, linux-kernel@vger.kernel.org,
       systemtap@sources.redhat.com,
       Yumiko Sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi Oshima <soshima@redhat.com>, Hideo Aoki <haoki@redhat.com>
Subject: Re: [PATCH] relay-file-read-start-pos-fix.patch
References: <4676109F.8020202@us.ibm.com>  <467750E9.4090808@hitachi.com> <1182270325.30702.87.camel@ubuntu>
In-Reply-To: <1182270325.30702.87.camel@ubuntu>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tom Zanussi wrote:
> Hi,
> 
> I haven't had a chance to test it myself yet, but it looks ok to me,
> except for one problem noted below...

Hi,

Thank you so much!
I'm preparing how it can reproduce. I'll send it as soon as possible.

> Thanks for fixing it.
> 
>> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>>
>> ---
>>  kernel/relay.c |    8 ++++++--
>>  1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> Index: linux-2.6.22-rc4-mm2/kernel/relay.c
>> ===================================================================
>> --- linux-2.6.22-rc4-mm2.orig/kernel/relay.c	2007-06-13 20:22:02.000000000 +0900
>> +++ linux-2.6.22-rc4-mm2/kernel/relay.c	2007-06-18 23:00:54.000000000 +0900
>> @@ -812,7 +812,10 @@
>>  	}
>>
>>  	buf->bytes_consumed += bytes_consumed;
>> -	read_subbuf = read_pos / buf->chan->subbuf_size;
>> +	if (!read_pos)
>> +		read_subbuf = buf->subbufs_consumed;
> 
> I think this should be instead:
> 
> +		read_subbuf = buf->subbufs_consumed % n_subbufs;

Yes, you are right.
Thank you again.

-- 
Masami HIRAMATSU
Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
