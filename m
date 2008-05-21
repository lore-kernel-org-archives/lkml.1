Return-Path: <linux-kernel-owner+w=401wt.eu-S1761166AbYEUAXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761166AbYEUAXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 20:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754569AbYEUAX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 20:23:29 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:43928 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452AbYEUAX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 20:23:28 -0400
Date: Wed, 21 May 2008 09:28:49 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Paul Menage" <menage@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "xemul@openvz.org" <xemul@openvz.org>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>
Subject: Re: [RFC][PATCH 2/3] memcg:: seq_ops support for cgroup
Message-Id: <20080521092849.c2f0b7e1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <6599ad830805201146g5a2a8928l6a2f5adc51b15f15@mail.gmail.com>
References: <20080520180552.601da567.kamezawa.hiroyu@jp.fujitsu.com>
	<20080520180841.f292beef.kamezawa.hiroyu@jp.fujitsu.com>
	<6599ad830805201146g5a2a8928l6a2f5adc51b15f15@mail.gmail.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2008 11:46:46 -0700
"Paul Menage" <menage@google.com> wrote:

> On Tue, May 20, 2008 at 2:08 AM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > Does anyone have a better idea ?
> 
> As a way of printing plain text files, it seems fine.
> 
> My concern is that it means that cgroups no longer has any idea about
> the typing of the data being returned, which will make it harder to
> integrate with a binary stats API. You'd end up having to have a
> separate reporting method for the same data to use it. That's why the
> "read_map" function specifically doesn't take a seq_file, but instead
> takes a key/value callback abstraction, which currently maps into a
> seq_file. For the binary stats API, we can use the same reporting
> functions, and just map into the binary API output.
> 
With current interface, my concern is hotplug.

File-per-node method requires delete/add files at hotplug.
A file for all nodes with _maps_ method cannot be used because
maps file says
==
The key/value pairs (and their ordering) should not
         * change between reboots.
==

And (*read) method isn't useful ;)

Can we add new stat file dynamically ?

Thanks,
-Kame





