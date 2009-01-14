Return-Path: <linux-kernel-owner+w=401wt.eu-S1753062AbZANCtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062AbZANCtO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 21:49:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751762AbZANCsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 21:48:54 -0500
Received: from smtp-out.google.com ([216.239.45.13]:15059 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbZANCsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 21:48:53 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=DwQeZAhrHi2CFiDaUwXbLy8hAzAnm8jthQ7OByP4v8FPvVam1ExxRrsUw0l51rTmm
	Jx8txiWWEldXjw64612Fg==
MIME-Version: 1.0
In-Reply-To: <20090108183529.b4fd99f4.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090108182556.621e3ee6.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090108183529.b4fd99f4.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 13 Jan 2009 18:48:43 -0800
Message-ID: <6599ad830901131848gf7f6996iead1276bc50753b8@mail.gmail.com>
Subject: Re: [RFC][PATCH 4/4] cgroup-memcg fix frequent EBUSY at rmdir
From: Paul Menage <menage@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.28.16.76
X-GMailtapped: menage
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 8, 2009 at 1:35 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> +       if (ret == -EAGAIN) { /* subsys asks us to retry later */
> +               mutex_unlock(&cgroup_mutex);
> +               cond_resched();
> +               goto retry;
> +       }

This spinning worries me a bit. It might be better to do an
interruptible sleep until the relevant CSS's refcount goes down to
zero. And is there no way that the memory controller can hang on to a
reference indefinitely, if the cgroup still has some pages charged to
it?

Paul
