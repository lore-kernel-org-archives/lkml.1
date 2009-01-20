Return-Path: <linux-kernel-owner+w=401wt.eu-S1762164AbZATBzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762164AbZATBzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 20:55:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755204AbZATBzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 20:55:39 -0500
Received: from smtp-out.google.com ([216.239.45.13]:28365 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912AbZATBzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 20:55:38 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=T8fUULtvcLTCPivTJ7Xb6ZfWBT0kdtO+sOlA//FcDpJzWwlybRJAFZjmn6Hq7lJhn
	W6Ekdm0DlUIKN1OwNzZZQ==
MIME-Version: 1.0
In-Reply-To: <49752E11.20209@cn.fujitsu.com>
References: <20090115192120.9956911b.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090115192712.33b533c3.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090116120001.f37e1895.kamezawa.hiroyu@jp.fujitsu.com>
	 <6599ad830901191741j4668f529s97ee6e896b0c011d@mail.gmail.com>
	 <49752E11.20209@cn.fujitsu.com>
Date: Mon, 19 Jan 2009 17:55:34 -0800
Message-ID: <6599ad830901191755r52c3bd23v33a28dc8b9896916@mail.gmail.com>
Subject: Re: [PATCH 2/4] cgroup:add css_is_populated
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.25.146.37
X-GMailtapped: menage
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 5:51 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>
> Yes, but I can see a potential problem. If we have subsystem foo and bar,
> and both of them have a control file with exactly the same name, like
> foo.stat & bar.stat. Now we mount them with -o noprefix, and then one
> of the stat file will fail to be created, without any warnning or notification
> to the user.

That's a fair point. The "noprefix" option was really only added for
backwards-compatibility when mounting as the "cpuset" filesystem type,
so it shouldn't end up getting used directly. But you're right that
this does mean that populate can fail and we should handle that, or
else make the "noprefix" option only usable from within the kernel
when mounting cpusets.

Paul
