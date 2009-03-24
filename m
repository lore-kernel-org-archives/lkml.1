Return-Path: <linux-kernel-owner+w=401wt.eu-S1760983AbZCXS4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760983AbZCXS4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 14:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755324AbZCXSzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 14:55:18 -0400
Received: from ms01.sssup.it ([193.205.80.99]:53108 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755043AbZCXSzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 14:55:17 -0400
Date: Tue, 24 Mar 2009 20:04:16 +0100
From: Fabio Checconi <fchecconi@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Nauman Rafique <nauman@google.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, paolo.valente@unimore.it,
       jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@intellilink.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, arozansk@redhat.com,
       jmoyer@redhat.com, oz-kernel@redhat.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, menage@google.com, peterz@infradead.org
Subject: Re: [PATCH 01/10] Documentation
Message-ID: <20090324190416.GP18554@gandalf.sssup.it>
References: <20090312100054.GA8024@linux.vnet.ibm.com> <20090312140450.GE10919@redhat.com> <49C0A171.8060009@cn.fujitsu.com> <20090318215529.GA3338@redhat.com> <e98e18940903232232i432f62c5r9dfd74268e1b2684@mail.gmail.com> <20090324125842.GA21389@redhat.com> <e98e18940903241114u1e03ae7dhf654d7d8d0fc0302@mail.gmail.com> <20090324182906.GF21389@redhat.com> <20090324184101.GO18554@gandalf.sssup.it> <20090324183532.GG21389@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324183532.GG21389@redhat.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Vivek Goyal <vgoyal@redhat.com>
> Date: Tue, Mar 24, 2009 02:35:32PM -0400
>
> On Tue, Mar 24, 2009 at 07:41:01PM +0100, Fabio Checconi wrote:
> > > From: Vivek Goyal <vgoyal@redhat.com>
> > > Date: Tue, Mar 24, 2009 02:29:06PM -0400
> > >
> > ...
> > > > Does keeping the sync queue in ready tree solves the problem too? Is
> > > > it because it avoid a virtual time jump?
> > > > 
> > > 
> > > I have not tried the second approch yet. But that also should solve the
> > > vtime jump issue.
> > > 
> > 
> > Do you mean that you intend to keep a queue with no backlog in the
> > active tree?
> 
> Yes. Is it possible to keep a not-backlogged queue in the tree for later
> expiry. So that we don't actively wait/idle for next request to come and
> hope queue will become backlogged soon. Otherwise, it will be deleted from
> the active queue. This is just a thought, I am not even sure how would it
> interefere with bfq code.
> 
> All this to solve the vtime jump issue for sync queues.
> 

Of course it is possible, but if you stick with wf2q+ the virtual time
will jump anyway, and the gain would be that each scheduling decision
will have O(N logN) complexity instead of O(log N), to skip empty
queues.

Otherwise, if you'll do your own timestamping (where any new request
can get a timestamp smaller that the virtual time) then nothing from
the theory BFQ was based on can give any hint on the guarantees that
the resulting algorithm can provide.
