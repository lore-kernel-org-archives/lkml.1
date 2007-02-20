Return-Path: <linux-kernel-owner+w=401wt.eu-S932205AbXBTJpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205AbXBTJpg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 04:45:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932804AbXBTJpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 04:45:36 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:33727 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932205AbXBTJpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 04:45:35 -0500
Message-ID: <45DAC32B.4030603@hitachi.com>
Date: Tue, 20 Feb 2007 18:45:15 +0900
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
Subject: Re: [PATCH 3/4] coredump: ELF-FDPIC: enable to omit anonymous shared
    memory
References: <45D5B483.3020502@hitachi.com> <45D5B2E3.3030607@hitachi.com> 
    <20368.1171638335@redhat.com>
In-Reply-To: <20368.1171638335@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thank you for your comments.

David Howells wrote:

>> static int elf_fdpic_dump_segments(struct file *file, struct mm_struct *mm,
>>-				   size_t *size, unsigned long *limit)
>>+				   size_t *size, unsigned long *limit,
>>+				   unsigned int omit_anon_shared)
> 
> Why are you passing it as an extra argument when you could just use
> mm->coredump_omit_anon_shared here:
> 
>>+		if (!maydump(vma, omit_anon_shared))

> I wouldn't worry, were I you, about the setting changing whilst it's being
> used.  If you are worried about that, you can probably do some locking against
> that.

Core dumping is separated two phases, one is the phase of writing
headers, the other is the phase of writing memory segments.  If the
coredump_omit_anon_shared setting is changed between these two phases,
a corrupted core file will be generated because the offsets written
in headers don't match their bodies.  So we need to use the same
setting in both phases.

I think that locking makes codes complex and generates overhead.
So I wouldn't like to use lock as far as possible.  I think passing
the flag as an extra argument is the simplest implementation to
avoid the core file corruption.

Thanks,
-- 
Hidehiro Kawai
Hitachi, Ltd., Systems Development Laboratory

