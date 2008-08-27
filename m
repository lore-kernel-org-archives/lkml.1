Return-Path: <linux-kernel-owner+w=401wt.eu-S1755788AbYH0Mgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788AbYH0Mgv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 08:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753802AbYH0Mgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 08:36:43 -0400
Received: from smtp-out.google.com ([216.239.33.17]:58776 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177AbYH0Mgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 08:36:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=U+15ga7RpUVGyvQZDE4Bfy2uopJg1MBosKs/skAjkwmuK0O95Hvz3ZYjbs6KW/mJO
	Hr1fYx4QOXObEvdqSdwug==
Message-ID: <6599ad830808270536i353e1807kaac4e9fb74301bb0@mail.gmail.com>
Date: Wed, 27 Aug 2008 05:36:32 -0700
From: "Paul Menage" <menage@google.com>
To: "Lai Jiangshan" <laijs@cn.fujitsu.com>
Subject: Re: [PATCH] cgroup(fix critical bug): new handling for tasks file
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linux Containers" <containers@lists.linux-foundation.org>
In-Reply-To: <48B4D81D.2040200@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48B360CE.2010501@cn.fujitsu.com>
	 <6599ad830808251929p10dfc9d2ub11e4db0cd4f9f3@mail.gmail.com>
	 <48B39319.7070403@cn.fujitsu.com>
	 <6599ad830808261544w308a850m865ac0c0a1552c77@mail.gmail.com>
	 <48B4D81D.2040200@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 9:29 PM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
>
> And vmalloc can malloc larger memory than kmalloc, is vmalloc() enough?
> If not, I think using an array of pages is the best choice.

vmalloc would be simpler, certainly, but it has a higher overhead. And
since we're dealing with arrays of integers here, it's not too hard to
manage multiple arrays. Oh, except for sorting them, which would be
more of a pain. So yes, maybe vmalloc() would be a better choice at
first.

Paul
