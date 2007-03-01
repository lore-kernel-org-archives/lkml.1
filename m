Return-Path: <linux-kernel-owner+w=401wt.eu-S1751010AbXCAMff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751010AbXCAMff (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 07:35:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbXCAMfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 07:35:34 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:33463 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbXCAMfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 07:35:33 -0500
Message-ID: <45E6C888.4050300@hitachi.com>
Date: Thu, 01 Mar 2007 21:35:20 +0900
From: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: Markus Gutschke <markus@google.com>
Cc: Andrew Morton <akpm@osdl.org>, kernel list <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Robin Holt <holt@sgi.com>,
       dhowells@redhat.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>,
       "Hideo AOKI@redhat" <haoki@redhat.com>
Subject: Re: [PATCH 0/4] coredump: core dump masking support v3
References: <45D5B2E3.3030607@hitachi.com> <45DFB1C7.1030205@google.com>
In-Reply-To: <45DFB1C7.1030205@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Markus Gutschke wrote:

> Kawai, Hidehiro wrote:
> 
>> This patch series is version 3 of the core dump masking feature,
>> which provides a per-process flag not to dump anonymous shared
>> memory segments.
> 
> I just wanted to remind you that you need to be careful about dumping
> the [vdso] segment no matter whether you omit other segments. I didn't
> actually try running your patches, and if the kernel doesn't actually
> consider this segment anonymous and shared, things might already work
> fine as is.

Thank you for your advice and sorry for not replying soon.

Fortunately, the latest kernel uses VM_ALWAYSDUMP flag to always dump
the vdso segment.  My patchset doesn't change this behavior.  So we
don't need to worry about the vdso segment.

 
> As an alternative to your kernel patch, you could achieve the same goal
> in user space, by linking my coredumper
> http://code.google.com/p/google-coredumper/ into your binaries and
> setting up appropriate signal handlers. An equivalent patch for
> selectively omitting memory regions would be trivial to add.

As far as I can see, google-coredumper has more flexibility.
Can google-coredumper satisfy the following requirements easily?

Requirements are:
  (1) a user can change the core dump settings _anytime_
      - sometimes want to dump anonymous shared memory segments and
        sometimes don't want to dump them
  (2) a user can change the core dump settings of _any processes_
      (although permission checks are performed)
      - in a huge application which forks many processes, a user
        hopes that some processes dump anonymous shared memory
        segments and some processes don't dump them

And reliability of the core dump feature is also important.


> While this
> does give you more flexibility, it of course has the drawback of
> requiring you to change your applications, so there still is some
> benefit in a kernelspace solution.

And all the software vendors don't necessarily apply
google-coredumper.  If the vendor doesn't apply it, the user will
be bothered by huge core dumps or the buggy application which
remains unfixed.  So I believe that in kernel solution is still
needed.

Thanks,
-- 
Hidehiro Kawai
Hitachi, Ltd., Systems Development Laboratory

