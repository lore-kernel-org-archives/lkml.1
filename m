Return-Path: <linux-kernel-owner+w=401wt.eu-S1757736AbZEZWGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757736AbZEZWGf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 18:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754553AbZEZWG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 18:06:28 -0400
Received: from smtp-out.google.com ([216.239.45.13]:43855 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584AbZEZWG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 18:06:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=HI8+QDi0+7e9m6RUpd6GQv/H6uEvEH6SufRUmEUpMAsgABV173J+5HmCbFHdxmKZT
	FLKgZr815dFVvUWWlkl4A==
MIME-Version: 1.0
In-Reply-To: <20090522172545.1e5e5f81.kamezawa.hiroyu@jp.fujitsu.com>
References: <4A16153C.2080004@cn.fujitsu.com>
	 <20090522172545.1e5e5f81.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 26 May 2009 15:06:25 -0700
Message-ID: <6599ad830905261506x480f2167naf1034177bbc7036@mail.gmail.com>
Subject: Re: [PATCH] cgroups: handle failure of cgroup_populate_dir() at 
	mount/remount
From: Paul Menage <menage@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 22, 2009 at 1:25 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
> Hm, shouldn't we allow "noprefix" to be effective only agaisnt cpuset ?
> I think it's just for backward-compatibility of cpuset.
> (I don't like the option at all.)

Yes, exposing the "noprefix" option externally was one of the mistakes
I made when developing cgroups.

It seems to me really unlikely that anyone is using "noprefix" for
anything other than implicitly when mounting the "cpuset" filesystem.
So I'd be inclined to just forbid it if we're mounting more than just
the cpuset subsystem. A bit of a nasty abstraction violation, but it
makes more sense overall. The only problem is that someone *might* be
using it - do we have any way to determine how, and how big do they
have to be before we care?

Paul
