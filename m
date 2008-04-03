Return-Path: <linux-kernel-owner+w=401wt.eu-S1758359AbYDCSls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758359AbYDCSls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 14:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751061AbYDCSlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 14:41:40 -0400
Received: from smtp-out.google.com ([216.239.33.17]:48475 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbYDCSlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 14:41:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=eTAxttnSt9hnB00wo5LTFGzGy61Y/z7SnGi3py9+2L4weklOfsZ9uym0WvI6r9syz
	vt0tvTUIO/3H/ursmBD3Q==
Message-ID: <6599ad830804031141o142bf8c2o1899ca78f8cd434a@mail.gmail.com>
Date: Thu, 3 Apr 2008 11:41:22 -0700
From: "Paul Menage" <menage@google.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [-mm] Add an owner to the mm_struct (v7)
Cc: "Pavel Emelianov" <xemul@openvz.org>, "Hugh Dickins" <hugh@veritas.com>,
       "Sudhir Kumar" <skumar@linux.vnet.ibm.com>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       "David Rientjes" <rientjes@google.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <47F5233F.1010108@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080403174433.26356.42121.sendpatchset@localhost.localdomain>
	 <6599ad830804031058l1e2a7ad9p56cff47dca738d79@mail.gmail.com>
	 <47F51DE7.7010204@linux.vnet.ibm.com>
	 <6599ad830804031122y3f6946fbp97dc18073bf02609@mail.gmail.com>
	 <47F5233F.1010108@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 3, 2008 at 11:34 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>
>  That is indeed quite bad. Do we have to retire the group_leader to init_css_set?
>  Can we not check for delay_group_leader() there?
>

That might have unintentded consequences, such as leaving a pid in the
cgroup that can't be moved (since it's PF_EXITING) but won't go away
until its threads have all exited.
Maybe that's OK if the other threads are guaranteed to have started
exiting by this point. We'd need some cleanup for when the group
leader finally did exit.

Paul
