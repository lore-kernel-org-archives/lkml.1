Return-Path: <linux-kernel-owner+w=401wt.eu-S1750984AbXBTJse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750984AbXBTJse (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 04:48:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750974AbXBTJsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 04:48:33 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:36194 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbXBTJsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 04:48:32 -0500
Message-ID: <45DAC3E1.1020305@hitachi.com>
Date: Tue, 20 Feb 2007 18:48:17 +0900
From: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@osdl.org>, kernel list <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Robin Holt <holt@sgi.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>,
       "Hideo AOKI@redhat" <haoki@redhat.com>
Subject: Re: [PATCH 0/4] coredump: core dump masking support v3
References: <45D5B2E3.3030607@hitachi.com> <20425.1171638534@redhat.com>
In-Reply-To: <20425.1171638534@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

David Howells wrote:

> Kawai, Hidehiro <hidehiro.kawai.ez@hitachi.com> wrote:
> 
>>To avoid the above situation we can limit the core file size by
>>setrlimit(2) or ulimit(1). But this method can lose important data
>>such as stack because core dumping is terminated halfway.
>>So I suggest keeping shared memory segments from being dumped for
>>particular processes.
> 
> A better way might be to place the shared memory segments last if that's
> possible (I'm not sure ELF supports out-of-order segments).

Placing the shared memory segments last and limiting by ulimit -c
is one of the solutions.  But there is no guarantee that the memory
segments other than anonymous shared memory are always dumped.
So your idea cannot alternate my suggesting feature.
But if your idea has a merit which my idea doesn't have, I try to
consider coexistence of both idea.

 
>>Because the shared memory attached to processes is common in them, we don't
>>need to dump the shared memory every time.
> 
> So there's no guarantee that they'll be dumped at all...  I'm not sure there's
> any way around that, however.

Indeed.  However, some people don't want to dump anonymous shared memory
at all.  Taking into account this requirement, I don't guarantee that.
But this feature allows per-process setting.  So if you want to dump
the shared memory at least once, you can manage to do that in userland.

Thanks,
-- 
Hidehiro Kawai
Hitachi, Ltd., Systems Development Laboratory

