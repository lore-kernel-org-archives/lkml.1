Return-Path: <linux-kernel-owner+w=401wt.eu-S1754674AbYC1LEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbYC1LEi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 07:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbYC1LEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 07:04:30 -0400
Received: from smtp-out.google.com ([216.239.33.17]:3494 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbYC1LE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 07:04:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=NbIy/AmCN7SAbiq0//rVOEsfuPh2EPPFHVr4b6tEqTeqIa1mG0kEqCNWEyKhFPBsF
	vJvX/HlIr4rWEx343QRiQ==
Message-ID: <6599ad830803280404i475c9824i31741af5a8ebf376@mail.gmail.com>
Date: Fri, 28 Mar 2008 04:04:17 -0700
From: "Paul Menage" <menage@google.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [-mm] Add an owner to the mm_struct (v2)
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Pavel Emelianov" <xemul@openvz.org>, "Hugh Dickins" <hugh@veritas.com>,
       "Sudhir Kumar" <skumar@linux.vnet.ibm.com>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       "David Rientjes" <rientjes@google.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <47ECCE00.70803@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080328082316.6961.29044.sendpatchset@localhost.localdomain>
	 <20080328195516.494edde3.kamezawa.hiroyu@jp.fujitsu.com>
	 <47ECCE00.70803@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2008 at 3:52 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>  > How about changing this css_get()/css_put() from accounting against mm_struct
>  > to accouting against task_struct ?
>  > It seems simpler way after this mm->owner change.
>
>  But the reason why we account the mem_cgroup is that we don't want the
>  mem_cgroup to be deleted. I hope you meant mem_cgroup instead of mm_struct.
>

If there are any tasks in the cgroup then the cgroup can't be deleted,
and hence the mem_cgroup is safe.

css_get()/css_put() is only needed when you have a reference from a
non-task object that needs to keep the mem_cgroup alive, which is no
longer the case for mm_struct once we have mm->owner.

Paul
