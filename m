Return-Path: <linux-kernel-owner+w=401wt.eu-S1755157AbZFDDtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157AbZFDDtS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 23:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754814AbZFDDtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 23:49:11 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:39166 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779AbZFDDtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 23:49:10 -0400
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       garyhade@us.ibm.com, pbadari@us.ibm.com,
       "y-goto\@jp.fujitsu.com" <y-goto@jp.fujitsu.com>, gregkh@suse.de
Subject: Re: sysfs_create_link_nowarn still remains (Was Re: mmotm 2009-06-03-16-33 uploaded
References: <200906032353.n53Nre5r019806@imap1.linux-foundation.org>
	<20090604123813.96c2c5a9.kamezawa.hiroyu@jp.fujitsu.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 03 Jun 2009 20:49:08 -0700
In-Reply-To: <20090604123813.96c2c5a9.kamezawa.hiroyu@jp.fujitsu.com> (KAMEZAWA Hiroyuki's message of "Thu\, 4 Jun 2009 12\:38\:13 +0900")
Message-ID: <m11vq0acaz.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: kamezawa.hiroyu@jp.fujitsu.com, gregkh@suse.de, y-goto@jp.fujitsu.com, pbadari@us.ibm.com, garyhade@us.ibm.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:

2> On Wed, 03 Jun 2009 16:33:52 -0700
> akpm@linux-foundation.org wrote:
>
>> The mm-of-the-moment snapshot 2009-06-03-16-33 has been uploaded to
>> 
>>    http://userweb.kernel.org/~akpm/mmotm/
>> 
>> and will soon be available at
>> 
>>    git://git.zen-sources.org/zen/mmotm.git
>> 
> It seems sysfs_create_link_nowarn() is removed in linux-next.patch but
> driver/base/node.c still includes it.
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=c04fc586c1a480ba198f03ae7b6cbd7b57380b91
>
> How should we fix it ? Folllowing is a quick hack for compile but ...
> should be clarified by memory hotplug guys.

Greg has already dropped the patches so the should not appear it the next linux-next.
I think your patch is what we want I haven't had a chance to wrap my head around
all of that yet.

Eric


> ==
>
> sysfs_create_link_nowarn() is obsolete.
>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
> Index: mmotm-2.6.30-Jun3/drivers/base/node.c
> ===================================================================
> --- mmotm-2.6.30-Jun3.orig/drivers/base/node.c
> +++ mmotm-2.6.30-Jun3/drivers/base/node.c
> @@ -279,7 +279,7 @@ int register_mem_sect_under_node(struct 
>  			continue;
>  		if (page_nid != nid)
>  			continue;
> -		return sysfs_create_link_nowarn(&node_devices[nid].sysdev.kobj,
> +		return sysfs_create_link(&node_devices[nid].sysdev.kobj,
>  					&mem_blk->sysdev.kobj,
>  					kobject_name(&mem_blk->sysdev.kobj));
>  	}
