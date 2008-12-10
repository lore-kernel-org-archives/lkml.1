Return-Path: <linux-kernel-owner+w=401wt.eu-S1756793AbYLJTBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793AbYLJTBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 14:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756821AbYLJTAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 14:00:40 -0500
Received: from smtp-out.google.com ([216.239.45.13]:24277 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413AbYLJTAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 14:00:38 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=K6dc6Eb3ROdV/+GHbWN1bByx4bnYsijzkoIZGhtEfievBihLKEp0y96Iq4UE7JH/l
	dMwKPS+Y+LXafz4cFjlkw==
MIME-Version: 1.0
In-Reply-To: <6599ad830812101035v33dbc6cfh57aa5510f6d65d54@mail.gmail.com>
References: <20081209200213.0e2128c1.kamezawa.hiroyu@jp.fujitsu.com>
	 <20081209200647.a1fa76a9.kamezawa.hiroyu@jp.fujitsu.com>
	 <6599ad830812100240g5e549a5cqe29cbea736788865@mail.gmail.com>
	 <29741.10.75.179.61.1228908581.squirrel@webmail-b.css.fujitsu.com>
	 <6599ad830812101035v33dbc6cfh57aa5510f6d65d54@mail.gmail.com>
Date: Wed, 10 Dec 2008 11:00:35 -0800
Message-ID: <6599ad830812101100v4dc7f124jded0d767b92e541a@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/6] memcg: fix pre_destory handler
From: Paul Menage <menage@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 10:35 AM, Paul Menage <menage@google.com> wrote:
> On Wed, Dec 10, 2008 at 3:29 AM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>>
>> (BTW, I don't like hierarchy-walk-by-small-locks approarch now because
>>  I'd like to implement scan-and-stop-continue routine.
>>  See how readdir() aginst /proc scans PID. It's very roboust against
>>  very temporal PIDs.)
>
> So you mean that you want to be able to sleep, and then contine
> approximately where you left off, without keeping any kind of
> reference count on the last cgroup that you touched? OK, so in that
> case I agree that you would need some kind of hierarch

Oops, didn't finish that sentence.

I agree that you'd need some kind of hierarchical-restart. But I'd
like to play with / look at your cgroup-id patch more closely and see
if we can come up with something simpler that still does what you
want.

One particular problem with the patch as it stands is that the ids
should be per-css, not per-cgroup, since a css can move between
hierarchies and hence between cgroups. (Currently only at bind/unbind
time, but it still results in a cgroup change).

Paul
