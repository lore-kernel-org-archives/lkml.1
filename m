Return-Path: <linux-kernel-owner+w=401wt.eu-S1752483AbZGWFh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbZGWFh7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 01:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751782AbZGWFh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 01:37:58 -0400
Received: from smtp-out.google.com ([216.239.45.13]:27620 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbZGWFh6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 01:37:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=GsEXAa25IVG5jjIjCZGOcw1G0n/YNgFH8iWzxj2khm2ZyODRmhF08erxnn6fy7ZKB
	Z2ccZdswxLu9NU50Heg0g==
MIME-Version: 1.0
In-Reply-To: <20090723141301.05401a5c.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090722194644.7481.47805.stgit@menage.mtv.corp.google.com>
	 <20090723141301.05401a5c.kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 22 Jul 2009 22:37:53 -0700
Message-ID: <6599ad830907222237jcdac287tf4243e24024f8055@mail.gmail.com>
Subject: Re: [PATCH 0/4] CGroup: Support for named and empty hierarchies
From: Paul Menage <menage@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: akpm@linux-foundation.org, lizf@cn.fujitsu.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 10:13 PM, KAMEZAWA
Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
> Thank you. I'd like to look into procps package to allow
>
>  #ps -lf -cgroup=/xxxx/yyy
> or
>  #top -cgroup=/xxx/yyy
>

Wouldn't it be less invasive to change procps so that doing

ps <pid1> <pid2> ...

only actually looks at /proc/<pid1>, /proc/<pid2>, etc, rather than
looking at all of them and then throwing away any that aren't in the
supplied list?

Then you could do what you want with ps $(cat /dev/cgroup/xxxx/yyy/tasks)

Paul
