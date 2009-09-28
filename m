Return-Path: <linux-kernel-owner+w=401wt.eu-S1752464AbZI1QOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464AbZI1QOF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 12:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751811AbZI1QOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 12:14:04 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58865 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbZI1QOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 12:14:03 -0400
Message-ID: <a0ea21a7cfe313202e2b51510aa5435a.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0909281637160.25798@sister.anvils>
References: <4AB9A0D6.1090004@crca.org.au>
    <20090924100518.78df6b93.kamezawa.hiroyu@jp.fujitsu.com>
    <4ABC80B0.5010100@crca.org.au>
    <20090925174009.79778649.kamezawa.hiroyu@jp.fujitsu.com>
    <4AC0234F.2080808@crca.org.au>
    <20090928120450.c2d8a4e2.kamezawa.hiroyu@jp.fujitsu.com>
    <20090928033624.GA11191@localhost>
    <20090928125705.6656e8c5.kamezawa.hiroyu@jp.fujitsu.com>
    <Pine.LNX.4.64.0909281637160.25798@sister.anvils>
Date: Tue, 29 Sep 2009 01:14:03 +0900 (JST)
Subject: Re: No more bits in vm_area_struct's vm_flags.
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Hugh Dickins" <hugh.dickins@tiscali.co.uk>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Wu Fengguang" <fengguang.wu@intel.com>,
       "Nigel Cunningham" <ncunningham@crca.org.au>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Mon, 28 Sep 2009, KAMEZAWA Hiroyuki wrote:
>>
>> What I dislike is making vm_flags to be long long ;)
>
> Why?
I'm sorry if my "dislike" sounds too strong.

Every time I see long long in the kernel, my concern is
"do I need spinlock to access this for 32bit arch ? is it safe ?".
(And it makes binary=>disassemble=>C (by eyes) a bit difficult)
Then, I don't like long long personally.

Another reason is some other calls like test_bit() cannot be used against
long long. (even if it's not used _now_)

Maybe vm->vm_flags will not require extra locks because
it can be protected by bigger lock as mmap_sem. Then, please make it
to be long long if its's recommended.

keeping vm_flags to be 32bit may makes vma_merge() ugly.
If so, long long is  a choice.

Thanks,
-Kame


> Hugh
>


