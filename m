Return-Path: <linux-kernel-owner+w=401wt.eu-S1760393AbZCXSwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760393AbZCXSwH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 14:52:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759032AbZCXStp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 14:49:45 -0400
Received: from smtp-out.google.com ([216.239.33.17]:22681 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960AbZCXStm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 14:49:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=rxVdDaFTNuSLgYy1X67UrzGVLuwULjfDFgQVZ3xoASS9AJFXMAFVmBoz/6IeM3i6D
	ICWWfUD7/m5U8B4Dr16NQ==
MIME-Version: 1.0
In-Reply-To: <20090324183532.GG21389@redhat.com>
References: <1236823015-4183-2-git-send-email-vgoyal@redhat.com>
	 <20090312140450.GE10919@redhat.com> <49C0A171.8060009@cn.fujitsu.com>
	 <20090318215529.GA3338@redhat.com>
	 <e98e18940903232232i432f62c5r9dfd74268e1b2684@mail.gmail.com>
	 <20090324125842.GA21389@redhat.com>
	 <e98e18940903241114u1e03ae7dhf654d7d8d0fc0302@mail.gmail.com>
	 <20090324182906.GF21389@redhat.com>
	 <20090324184101.GO18554@gandalf.sssup.it>
	 <20090324183532.GG21389@redhat.com>
Date: Tue, 24 Mar 2009 11:49:35 -0700
Message-ID: <e98e18940903241149s71701c3fpb4c62a7848c1f170@mail.gmail.com>
Subject: Re: [PATCH 01/10] Documentation
From: Nauman Rafique <nauman@google.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Fabio Checconi <fchecconi@gmail.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, paolo.valente@unimore.it,
       jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@intellilink.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, arozansk@redhat.com,
       jmoyer@redhat.com, oz-kernel@redhat.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, menage@google.com, peterz@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 11:35 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Tue, Mar 24, 2009 at 07:41:01PM +0100, Fabio Checconi wrote:
>> > From: Vivek Goyal <vgoyal@redhat.com>
>> > Date: Tue, Mar 24, 2009 02:29:06PM -0400
>> >
>> ...
>> > > Does keeping the sync queue in ready tree solves the problem too? Is
>> > > it because it avoid a virtual time jump?
>> > >
>> >
>> > I have not tried the second approch yet. But that also should solve the
>> > vtime jump issue.
>> >
>>
>> Do you mean that you intend to keep a queue with no backlog in the
>> active tree?
>
> Yes. Is it possible to keep a not-backlogged queue in the tree for later
> expiry. So that we don't actively wait/idle for next request to come and
> hope queue will become backlogged soon. Otherwise, it will be deleted from
> the active queue. This is just a thought, I am not even sure how would it
> interefere with bfq code.
>
> All this to solve the vtime jump issue for sync queues.

If only vtime jump is an issue, can we solve it by delaying vtime
jump? That is, even if we serve an entity with a bigger vtime, we
don't update the reference vtime of the service tree until after some
time?

>
> Thanks
> Vivek
>
