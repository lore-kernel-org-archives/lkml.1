Return-Path: <linux-kernel-owner+w=401wt.eu-S1757930AbYLFQXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757930AbYLFQXJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 11:23:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754735AbYLFQWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 11:22:55 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:30386 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589AbYLFQWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 11:22:54 -0500
Message-ID: <ac3eb2510812060816h4401c78bj6d656d0d5721024@mail.gmail.com>
Date: Sat, 6 Dec 2008 17:16:06 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Evgeniy Polyakov" <zbr@ioremap.net>
Subject: Re: Runaway loop with the current git.
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <20081206160927.GA498@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081205180350.GA25236@ioremap.net>
	 <20081205181610.518ecd13@lxorguk.ukuu.org.uk>
	 <ac3eb2510812051032g6b5ea866q30f097d765854196@mail.gmail.com>
	 <20081205192755.GA27712@ioremap.net>
	 <20081205193432.290a6f1a@lxorguk.ukuu.org.uk>
	 <20081205211223.GA8075@ioremap.net>
	 <ac3eb2510812051317q79ca88e9ya876ffb94162eeca@mail.gmail.com>
	 <20081205212428.GB8075@ioremap.net>
	 <ac3eb2510812051810x8cf4256lf9fd31b15b9e0552@mail.gmail.com>
	 <20081206160927.GA498@ioremap.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 6, 2008 at 17:09, Evgeniy Polyakov <zbr@ioremap.net> wrote:
> On Sat, Dec 06, 2008 at 03:10:33AM +0100, Kay Sievers (kay.sievers@vrfy.org) wrote:
>> Can you add something like:
>>   +++ b/kernel/kmod.c
>>   @@ -108,6 +108,7 @@ int request_module(const char *fmt, ...)
>>                   return -ENOMEM;
>>           }
>>
>>   +       printk("XXX call modprobe %s %s[%u]\n", module_name,
>> current->comm, task_pid_nr(current));
>>
>> It may show which process is looking for /dev/console and causes
>> modprobe to run, and maybe we get an idea what's going on. It may at
>> least show if it's a /dev/console problem.
>
> Its a modprobe with different pids tries to load char-major-5 and
> char-major-5-1 in the infinite loop.

So the loop is probably a modprobe itself that tries to access
/dev/console. Is there a different argument for the very first
modprobe which is called? Which may be the one that triggers the loop.

Kay
