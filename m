Return-Path: <linux-kernel-owner+w=401wt.eu-S1754519AbYKDH2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519AbYKDH2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 02:28:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665AbYKDH17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 02:27:59 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53632 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751541AbYKDH17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 02:27:59 -0500
Message-ID: <490FF8D0.1070607@cn.fujitsu.com>
Date: Tue, 04 Nov 2008 15:25:04 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Matt Helsley <matthltc@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, Cedric Le Goater <clg@fr.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH 3/5] Container Freezer: Implement freezer cgroup subsystem
References: <20080811235323.872291138@us.ibm.com>	 <20080811235325.121356317@us.ibm.com>	 <6599ad830811032143h51eae533k5b0c17e65a7fa675@mail.gmail.com>	 <490FE7B5.8020400@cn.fujitsu.com> <6599ad830811032240n640f3fao48f1a9f05892b797@mail.gmail.com>
In-Reply-To: <6599ad830811032240n640f3fao48f1a9f05892b797@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Mon, Nov 3, 2008 at 10:12 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>> I think another reasonable and easier way is to disable writing freezer.state
>> of top cgroup, so we can skip checks in freezer_fork() for tasks in top cgroup.
>>
> 
> Yes, if freezing the root cgroup isn't needed then that is definitely
> simpler - I wasn't sure if Matt wanted to be able to freeze the root
> group with this subsystem.
> 

If someone just mounts the freezer subsystem and freeze the root cgroup,
all the tasks will be freezed, and then seems all he can do is reset the
machine (or do a suspend/resume).

That's why I think it's reasonable to disable it.
