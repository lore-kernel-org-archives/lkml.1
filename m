Return-Path: <linux-kernel-owner+w=401wt.eu-S1756103AbYDAGsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbYDAGsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 02:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbYDAGsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 02:48:15 -0400
Received: from smtp-out.google.com ([216.239.33.17]:9007 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbYDAGsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 02:48:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=OnW21EJzj9gGLyJ/IkAMw+tcJCP16zRww16k2f2IG8EQao6h8TDC0Rstc5keT2IpS
	0joGAOh1G3pFjUQ7hvbiQ==
Message-ID: <6599ad830803312348u3ee4d815i2e24c130978f8e04@mail.gmail.com>
Date: Mon, 31 Mar 2008 23:48:00 -0700
From: "Paul Menage" <menage@google.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [RFC][-mm] Add an owner to the mm_struct (v3)
Cc: "Pavel Emelianov" <xemul@openvz.org>, "Hugh Dickins" <hugh@veritas.com>,
       "Sudhir Kumar" <skumar@linux.vnet.ibm.com>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       "David Rientjes" <rientjes@google.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <47F1D4F3.3040207@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080401054324.829.4517.sendpatchset@localhost.localdomain>
	 <6599ad830803312316m17f9e6f1mf7f068c0314a789e@mail.gmail.com>
	 <47F1D4F3.3040207@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2008 at 11:23 PM, Balbir Singh
<balbir@linux.vnet.ibm.com> wrote:
>  > Here we'll want to call vm_cgroup_update_mm_owner(), to adjust the
>  > accounting. (Or if in future we end up with more than a couple of
>  > subsystems that want notification at this time, we'll want to call
>  > cgroup_update_mm_owner() and have it call any interested subsystems.
>  >
>
>  I don't think we need to adjust accounting, since only mm->owner is changing and
>  not the cgroup to which the task/mm belongs. Do we really need to notify? I
>  don't want to do any notifications under task_lock().

It's possible but unlikely that the new owner is in a different cgroup.

Paul
