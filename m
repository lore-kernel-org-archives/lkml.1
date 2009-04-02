Return-Path: <linux-kernel-owner+w=401wt.eu-S932634AbZDBGlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634AbZDBGlv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 02:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbZDBGlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 02:41:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62928 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750975AbZDBGlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 02:41:42 -0400
Message-ID: <49D45DAC.2060508@cn.fujitsu.com>
Date: Thu, 02 Apr 2009 14:39:40 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@intellilink.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, arozansk@redhat.com,
       jmoyer@redhat.com, oz-kernel@redhat.com, dhaval@linux.vnet.ibm.com,
       balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, akpm@linux-foundation.org,
       menage@google.com, peterz@infradead.org
Subject: Re: [RFC] IO Controller
References: <1236823015-4183-1-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1236823015-4183-1-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> Hi All,
> 
> Here is another posting for IO controller patches. Last time I had posted
> RFC patches for an IO controller which did bio control per cgroup.
> 
> http://lkml.org/lkml/2008/11/6/227
> 
> One of the takeaway from the discussion in this thread was that let us
> implement a common layer which contains the proportional weight scheduling
> code which can be shared by all the IO schedulers.
> 
  
  Hi Vivek,

  I did some tests on my *old* i386 box(with two concurrent dd running), and notice 
  that IO Controller doesn't work fine in such situation. But it can work perfectly 
  in my *new* x86 box. I dig into this problem, and i guess the major reason is that
  my *old* i386 box is too slow, it can't ensure two running ioqs are always backlogged.
  If that is the case, I happens to have a thought. when an ioq uses up it time slice, 
  we don't expire it immediately. May be we can give a piece of bonus time for idling 
  to wait new requests if this ioq's finish time and its ancestor's finish time are all 
  much smaller than other entities in each corresponding service tree.

-- 
Regards
Gui Jianfeng

