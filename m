Return-Path: <linux-kernel-owner+w=401wt.eu-S1761641AbZATBwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761641AbZATBwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 20:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756098AbZATBwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 20:52:04 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57744 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754912AbZATBwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 20:52:03 -0500
Message-ID: <49752E11.20209@cn.fujitsu.com>
Date: Tue, 20 Jan 2009 09:51:13 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/4] cgroup:add css_is_populated
References: <20090115192120.9956911b.kamezawa.hiroyu@jp.fujitsu.com>	 <20090115192712.33b533c3.kamezawa.hiroyu@jp.fujitsu.com>	 <20090116120001.f37e1895.kamezawa.hiroyu@jp.fujitsu.com> <6599ad830901191741j4668f529s97ee6e896b0c011d@mail.gmail.com>
In-Reply-To: <6599ad830901191741j4668f529s97ee6e896b0c011d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Thu, Jan 15, 2009 at 7:00 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> Li-san, If you don't like this, could you give me an idea for
>> "How to check cgroup is fully ready or not" ?
>>
>> BTW, why "we have a half filled direcotory - oh well" is allowed....
> 
> That's pretty much inherited from the original cpusets code. It
> probably should be cleaned up, but unless the system is totally hosed
> it seems pretty unlikely for creation of a few dentries to fail.
> 

Yes, but I can see a potential problem. If we have subsystem foo and bar,
and both of them have a control file with exactly the same name, like
foo.stat & bar.stat. Now we mount them with -o noprefix, and then one
of the stat file will fail to be created, without any warnning or notification
to the user.

