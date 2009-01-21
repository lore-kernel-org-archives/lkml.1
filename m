Return-Path: <linux-kernel-owner+w=401wt.eu-S1763340AbZAUDbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763340AbZAUDbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 22:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755088AbZAUDbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 22:31:04 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51075 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108AbZAUDbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 22:31:03 -0500
Date: Wed, 21 Jan 2009 12:29:52 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Greg KH <greg@kroah.com>, Paul Mundt <lethal@linux-sh.org>,
       Trilok Soni <soni.trilok@gmail.com>, Arve Hj?nnev?g <arve@android.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
       Brian Swetland <swetland@google.com>, arve@google.com,
       San Mehat <san@android.com>, Robert Love <rlove@google.com>,
       linux-kernel@vger.kernel.org,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>,
       ext Juha Yrj?l? <juha.yrjola@solidboot.com>, viktor.rosendahl@nokia.com
Subject: Re: lowmemory android driver not needed?
Message-Id: <20090121122952.18e4bb8c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090122114955.32F3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <2f11576a0901160316u20030f4u51c9e4c059398b70@mail.gmail.com>
	<20090116152338.GB9357@kroah.com>
	<20090122114955.32F3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jan 2009 11:50:48 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> last year, I received many feedback from lkml folks and my article reader.
> (I monthly write kernel patch introduction article to japanese web
>  magazine and receive some feedback periodically)
> 
> I learned many people want flexibility notification.
> (per workload, per user, et al)
> eg. nokia lowmem driver have exception process defined by uid.
> 
> at top of last year, I thought memcg don't provide good infrastructure.
> the first version memcg is just pretty funny joke. if its config turn on,
> memory workload performance decrease ~30% although the user don't use 
> memcg at runtime. then nobody use it.
> but recently, KAMEZAWA hiroyuki (and Li zefan, Daisuke Nishimura et al)
> dramatically improvement memcg performance. 
> now, memcg overhead become less than 1%. 
                             ^^^^^^^^^^^^
just depends on workload...

> 
> Then, I think any memory accounting activity should use this infrastructure.
> That's my homework.
> 

But, memcg requires much memory to track usage of pages, a page_cgroup structure, 
40bytes per page on 64bit, 20bytes per page on 32bit.
Probably, for embeded people, this additinal memory usage is not acceptable.

Below is just a noise:
==
As my personal project, I'd like to write on-demand-fake-numa for generic archs.
Now, section size is 128MB on x86-64. I'd like to allow following ops.

  # create_new_node (echo node_number > /sys/device/system/node/add_fake_node)
  # offline memory (echo offline > /sys/device/system/memory/memoryXXX/state)
  # attach offlined memory to new node
                   (echo node_number > /sys/device/system/memory/memoryXXX/attach)
  # online memmory (echo online > /sys/device/system/memory/memoryXXX/state)

Then, memoryXXX (128MB of chunk of memory) is controlled under a new fake node
"node_number".

For embeded systems, you may be able to modify SECTION_SIZE smaller (8-16MB?) and
cpuset will give them enough resource isolation.
(But not so flexible as memory cgroup.)

you can use node+cpuset information to track memory usage by apps.

Note: OOM-Killer kills process within cpuset.

Thanks,
-Kame






