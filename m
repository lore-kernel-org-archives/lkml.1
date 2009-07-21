Return-Path: <linux-kernel-owner+w=401wt.eu-S1751026AbZGUXtD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751026AbZGUXtD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 19:49:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750738AbZGUXtB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 19:49:01 -0400
Received: from smtp-out.google.com ([216.239.45.13]:8928 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbZGUXtB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 19:49:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=nOv6qiMGlB/dmSTGuz9+tuQVPZFDwb7XwNqiSEcRXuKYbII/Rb168V42iLplKKqiy
	2Jxk/cqBbwdX9vqVcptBg==
MIME-Version: 1.0
In-Reply-To: <4A4DAE21.4000806@cn.fujitsu.com>
References: <20090702020624.14469.47066.stgit@menage.mtv.corp.google.com>
	 <20090702021108.14469.39645.stgit@menage.mtv.corp.google.com>
	 <4A4DAE21.4000806@cn.fujitsu.com>
Date: Tue, 21 Jul 2009 16:48:56 -0700
Message-ID: <6599ad830907211648r3871fbfak4b7ddc1016e6fef6@mail.gmail.com>
Subject: Re: [PATCH 3/9] [RFC] Add a back-pointer from struct cg_cgroup_link 
	to struct cgroup
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       kamezawa.hiroyu@jp.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 3, 2009 at 12:07 AM, Li Zefan<lizf@cn.fujitsu.com> wrote:
>
>> +     write_lock_irq(&css_set_lock);
>
> can be read_lock(&css_set_lock);

I simplified the whole thing by removing the task_lock(current) and
expanding the RCU section to cover the point where we read
current->cgroups too.

Paul
