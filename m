Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505AbYCQDEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbYCQDEG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 23:04:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbYCQDD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 23:03:56 -0400
Received: from smtp-out.google.com ([216.239.45.13]:45719 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbYCQDDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 23:03:55 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=uvh8IGTDVtSeSZ+wIaUpnv74xq/toZ3plianVNH7Vmssx5rne1CyQaLM0AKDZNaBw
	Qr00gmmKH24CS69XIIkUg==
Message-ID: <6599ad830803162003u63589715i7d06c8b271c22160@mail.gmail.com>
Date: Mon, 17 Mar 2008 11:03:49 +0800
From: "Paul Menage" <menage@google.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [RFC][2/3] Account and control virtual address space allocations
Cc: linux-mm@kvack.org, "Hugh Dickins" <hugh@veritas.com>,
       "Sudhir Kumar" <skumar@linux.vnet.ibm.com>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp,
       "David Rientjes" <rientjes@google.com>,
       "Pavel Emelianov" <xemul@openvz.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <47DDDE0B.4010809@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080316172942.8812.56051.sendpatchset@localhost.localdomain>
	 <20080316173005.8812.88290.sendpatchset@localhost.localdomain>
	 <6599ad830803161902r8f9a274t246a25b3d337fee8@mail.gmail.com>
	 <47DDDE0B.4010809@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2008 at 10:57 AM, Balbir Singh
<balbir@linux.vnet.ibm.com> wrote:
>
>  1. We want to be able to support hierarchial accounting and control

>  2. We want to track usage of the root cgroup and report it back to the user

What use cases do you have for that?

>  3. We don't want to treat the root cgroup as a special case.

Why? It is a special case, in that in a lot of machines there's only
going to be the root cgroup, and the subsystem won't be mounted. So in
those cases, paying any overhead is a cost without a benefit.

Alternatively, how about you skip tracking virtual address space
changes if the virtual address cgroup isn't mounted on any hierarchy?
When you mount it, you can do a pass across all mms and set the root
cgroup usage to their total.

Paul
