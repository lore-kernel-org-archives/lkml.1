Return-Path: <linux-kernel-owner+w=401wt.eu-S1754884AbYC1OHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884AbYC1OHH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 10:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752511AbYC1OG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 10:06:57 -0400
Received: from smtp-out.google.com ([216.239.33.17]:11908 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbYC1OG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 10:06:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=iKvnHX8ZXx7O7XNZ9ewp2lzyIMKxxHbDwRmgw7QDwbdbSfNbH5jaDywK4XIH2CRM5
	d8oTWeV1uVtIaTpFprakA==
Message-ID: <6599ad830803280706j54376243if56ccca0281f685d@mail.gmail.com>
Date: Fri, 28 Mar 2008 07:06:52 -0700
From: "Paul Menage" <menage@google.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [-mm] Add an owner to the mm_struct (v2)
Cc: "Pavel Emelianov" <xemul@openvz.org>, "Hugh Dickins" <hugh@veritas.com>,
       "Sudhir Kumar" <skumar@linux.vnet.ibm.com>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       "David Rientjes" <rientjes@google.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <47ECEA8F.5060505@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080328082316.6961.29044.sendpatchset@localhost.localdomain>
	 <6599ad830803280401r68d30e91waaea8eb1de36eb52@mail.gmail.com>
	 <47ECE662.3060506@linux.vnet.ibm.com>
	 <47ECEA8F.5060505@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2008 at 5:54 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>
>  Thinking more, I don't think it makes sense for us to overload task_lock() to do
>  the mm->owner handling (we don't want to mix lock domains). task_lock() is used
>  for several things
>
>  1. We don't want to make task_lock() rules more complicated by having it protect
>  an mm member to save space
>  2. We don't want more contention on task_lock()
>

This isn't to save space, it's to provide correctness. We *have* to
hold task_lock(new_owner) before setting mm->owner = new_owner,
otherwise we have no guarantee that new_owner is still a user of mm.

Paul
