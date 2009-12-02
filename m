Return-Path: <linux-kernel-owner+w=401wt.eu-S1754724AbZLBWsG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbZLBWsG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 17:48:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbZLBWsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 17:48:05 -0500
Received: from smtp-out.google.com ([216.239.33.17]:61531 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905AbZLBWsE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 17:48:04 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=Aj+oJYg+pvMz18zzMRxUWfUBCpxnuW0clJ4/r94yfWFyFTqGArK5pH8rc2vr66G87
	rjauZwur7eXW9tIZeqKqA==
MIME-Version: 1.0
In-Reply-To: <20091202043046.420815285@intel.com>
References: <20091202031231.735876003@intel.com>
	 <20091202043046.420815285@intel.com>
Date: Wed, 2 Dec 2009 14:48:03 -0800
Message-ID: <6599ad830912021448h6f939623y43fbe5fde2c36b85@mail.gmail.com>
Subject: Re: [PATCH 21/24] cgroup: define empty css_put() when !CONFIG_CGROUPS
From: Paul Menage <menage@google.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Nick Piggin <npiggin@suse.de>,
       linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 1, 2009 at 7:12 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> --- linux-mm.orig/include/linux/cgroup.h        2009-11-02 10:18:41.000000000 +0800
> +++ linux-mm/include/linux/cgroup.h     2009-11-02 10:26:22.000000000 +0800
> @@ -581,6 +581,9 @@ static inline int cgroupstats_build(stru
>        return -EINVAL;
>  }
>
> +struct cgroup_subsys_state;
> +static inline void css_put(struct cgroup_subsys_state *css) {}
> +
>  #endif /* !CONFIG_CGROUPS */

This doesn't sound like the right thing to do - if !CONFIG_CGROUPS,
then the code shouldn't be able to see a css structure to pass to this
function.

Paul
