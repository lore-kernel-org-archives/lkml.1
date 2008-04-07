Return-Path: <linux-kernel-owner+w=401wt.eu-S1752985AbYDGRnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985AbYDGRnz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 13:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbYDGRnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 13:43:47 -0400
Received: from smtp-out.google.com ([216.239.33.17]:24605 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbYDGRnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 13:43:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=jh8JXaAlr+gpFuT+EDyi+W7s0sDO1nW3ME7z2eYUqNlKG69AfQonQfsi5WkaCVRa/
	cI4TOZRWKBGf90rIQF/kw==
Message-ID: <6599ad830804071043j33212a6kbeb4ef7d79e17f5c@mail.gmail.com>
Date: Mon, 7 Apr 2008 10:43:37 -0700
From: "Paul Menage" <menage@google.com>
To: "Balbir Singh" <balbir@linux.vnet.ibm.com>
Subject: Re: [-mm] Disable the memory controller by default (v2)
Cc: andi@firstfloor.org, "Andrew Morton" <akpm@linux-foundation.org>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       "Pavel Emelianov" <xemul@openvz.org>, hugh@veritas.com,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080407130215.26565.81715.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080407130215.26565.81715.sendpatchset@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 7, 2008 at 6:02 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>         return 1;
>   }
>   __setup("cgroup_disable=", cgroup_disable);
>  +
>  +static int __init cgroup_enable(char *str)
>  +{
>  +       int i;
>  +       char *token;
>  +
>  +       while ((token = strsep(&str, ",")) != NULL) {
>  +               if (!*token)
>  +                       continue;
>  +
>  +               for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
>  +                       struct cgroup_subsys *ss = subsys[i];
>  +
>  +                       if (!strcmp(token, ss->name)) {
>  +                               ss->disabled = 0;
>  +                               printk(KERN_INFO "%s control group "
>  +                                               "is enabled\n", ss->name);
>  +                               break;
>  +                       }
>  +               }
>  +       }
>  +       return 1;
>  +}
>  +__setup("cgroup_enable=", cgroup_enable);

Good idea - but you could just use the same handler function for both
of these (with a one-line wrapper for each to pass disabled=1 or
disabled=0)

Paul
