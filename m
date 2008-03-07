Return-Path: <linux-kernel-owner+w=401wt.eu-S1764372AbYCGFRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764372AbYCGFRs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 00:17:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555AbYCGFRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 00:17:41 -0500
Received: from smtp-out.google.com ([216.239.45.13]:53923 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbYCGFRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 00:17:40 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=hpkK7dyEPN7kNiYxFT6BhiY4122eqxCuvIFX0YKdrCqFDllU2jYSwrmoFUOkig58r
	QInarBHZbkgFqKZk0wcFw==
Date: Thu, 6 Mar 2008 21:15:33 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: balbir@linux.vnet.ibm.com, Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelianov <xemul@openvz.org>, Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org
Subject: Re: [PATCH] Add cgroup support for enabling controllers at boot
 time
In-Reply-To: <20080307135839.918a849a.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.00.0803062115010.26462@chino.kir.corp.google.com>
References: <20080306185952.23290.49571.sendpatchset@localhost.localdomain> <alpine.DEB.1.00.0803061108370.13110@chino.kir.corp.google.com> <47D0C76D.8050207@linux.vnet.ibm.com> <20080307135839.918a849a.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Mar 2008, KAMEZAWA Hiroyuki wrote:

> > David Rientjes wrote:
> > > On Fri, 7 Mar 2008, Balbir Singh wrote:
> > > 
> > >> @@ -3010,3 +3020,16 @@ static void cgroup_release_agent(struct 
> > >>  	spin_unlock(&release_list_lock);
> > >>  	mutex_unlock(&cgroup_mutex);
> > >>  }
> > >> +
> > >> +static int __init cgroup_disable(char *str)
> > >> +{
> > >> +	int i;
> > >> +	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
> > >> +		struct cgroup_subsys *ss = subsys[i];
> > >> +		if (!strcmp(str, ss->name)) {
> > >> +			ss->disabled = 1;
> > >> +			break;
> > >> +		}
> > >> +	}
> > >> +}
> > >> +__setup("cgroup_disable=", cgroup_disable);
> > > 
> > > This doesn't handle spaces very well, so isn't it possible for the name of 
> > > a current or future cgroup subsystem to be specified after cgroup_disable= 
> > > on the command line and have it disabled by accident?
> > > 
> > 
> Hmm, cmdline like
> 
> cgroup_disable=cpu,memory, ...
> 
> should be written as
> 
> cgroup_disable=cpu cgroup_disable=memory ....
> 

Or just set the first space following cgroup_disable= to '\0' and you're 
done.  strcmp() will take care of the rest.
