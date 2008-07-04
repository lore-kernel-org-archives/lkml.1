Return-Path: <linux-kernel-owner+w=401wt.eu-S1758258AbYGDDTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758258AbYGDDTB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 23:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755741AbYGDDSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 23:18:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57780 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754398AbYGDDSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 23:18:51 -0400
Message-ID: <486D963E.60202@cn.fujitsu.com>
Date: Fri, 04 Jul 2008 11:17:18 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Libcg Devel Mailing List <libcg-devel@lists.sourceforge.net>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>, Peter Zijlstra <pzijlstr@redhat.com>,
       Kazunaga Ikeno <k-ikeno@ak.jp.nec.com>,
       Morton Andrew Morton <akpm@linux-foundation.org>,
       Thomas Graf <tgraf@redhat.com>, Rik Van Riel <riel@redhat.com>
Subject: Re: [RFC] How to handle the rules engine for cgroups
References: <20080701191126.GA17376@redhat.com> <20080703101957.b3856904.kamezawa.hiroyu@jp.fujitsu.com> <20080703155446.GB9275@redhat.com>
In-Reply-To: <20080703155446.GB9275@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Because "a child inherits parent's" rule is very strong, I think the amount
>> of events we have to check is much less than we get report. Can't we add some
>> filter/assumption here ?
>>
> 
> I am not sure if proc connector currently allows filtering of various
> events like fork, exec, exit etc. In a quick look it looks like it
> does not. But probably that can be worked out. Even then, it will just
> help reduce the number of messages queued for user space on that socket
> but will not take away the fact that messages can be dropped under
> memory pressure. 
> 

Proc connector doesn't support event filtering. We can easily add a
global event mask, but not straightforward to add per-socket event mask
if not impossible.

