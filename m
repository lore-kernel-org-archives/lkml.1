Return-Path: <linux-kernel-owner+w=401wt.eu-S1752788AbZGWGWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbZGWGWe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 02:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbZGWGWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 02:22:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55072 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750990AbZGWGWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 02:22:33 -0400
Message-ID: <4A680151.9010502@cn.fujitsu.com>
Date: Thu, 23 Jul 2009 14:21:05 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] Move the cgroup debug subsys into cgroup.c to access
 internal state
References: <20090722194644.7481.47805.stgit@menage.mtv.corp.google.com> <20090722195035.7481.85657.stgit@menage.mtv.corp.google.com>
In-Reply-To: <20090722195035.7481.85657.stgit@menage.mtv.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> Move the cgroup debug subsys into cgroup.c to access internal state
> 
> While it's architecturally clean to have the cgroup debug subsystem be
> completely independent of the cgroups framework, it limits its
> usefulness for debugging the contents of internal data structures.
> Move the debug subsystem code into the scope of all the cgroups data
> structures to make more detailed debugging possible.
> 
> Signed-off-by: Paul Menage <menage@google.com>
> 

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

...

> +static u64 current_css_set_read(struct cgroup *cont, struct cftype *cft)
> +{
> +	return (u64)(long)current->cgroups;

I think it should be (unsigned long), otherwise:

 # cat debug.current_css_set
 18446744072653386208

That is: ffffffffc10c31e0

> +}
