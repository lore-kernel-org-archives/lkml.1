Return-Path: <linux-kernel-owner+w=401wt.eu-S1764162AbXGJJmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764162AbXGJJmB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 05:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760637AbXGJJlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 05:41:53 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:44556 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758586AbXGJJlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 05:41:52 -0400
Message-ID: <4693543C.2020509@openvz.org>
Date: Tue, 10 Jul 2007 13:41:16 +0400
From: Pavel Emelianov <xemul@openvz.org>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: sukadev@us.ibm.com
CC: Andrew Morton <akpm@osdl.org>, Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kirill Korotaev <dev@openvz.org>
Subject: Re: [PATCH 0/16] Pid namespaces
References: <468DF6F7.1010906@openvz.org> <20070710002929.GA11549@us.ibm.com>
In-Reply-To: <20070710002929.GA11549@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sukadev@us.ibm.com wrote:
> Pavel Emelianov [xemul@openvz.org] wrote:
> | This is "submition for inclusion" of hierarchical, not kconfig
> | configurable, zero overheaded ;) pid namespaces.
> | 
> | The overall idea is the following:
> | 
> | The namespace are organized as a tree - once a task is cloned
> | with CLONE_NEWPIDS (yes, I've also switched to it :) the new
> 
> Can you really clone() a pid namespace all by itself ?
> copy_namespaces() has the following:
> 
> 
>         if (!(flags & (CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC | CLONE_NEWUSER)))
>                 return 0;
> 
> doesn't it mean you cannot create a pid namespace using clone() unless
> one of the above flags are also specified ?
> 
> unshare_nsproxy_namespaces() has the following correct check:
> 
>         if (!(unshare_flags & (CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC |
>                                CLONE_NEWUSER | CLONE_NEWPIDS)))
>                 return 0;

I have already pointed this out. I attached the previous version of
this patch where I cloned the namespaces via unshare :( However the
copy_pid_ns code looks correct. I will resend it altogether.

My bad. I have to stop working at times I want to sleep...
 
> BTW, why not use CLONE_NEWPID and drop the 'S' ? We don't have 'S' with
> other namespaces.

CLONE_NEWPID? Hm... I see no difference. OK I'll switch to it.

> Suka
> 

