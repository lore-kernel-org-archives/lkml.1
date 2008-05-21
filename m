Return-Path: <linux-kernel-owner+w=401wt.eu-S1760399AbYEUFHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760399AbYEUFHH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 01:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbYEUFGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 01:06:55 -0400
Received: from smtp-out.google.com ([216.239.33.17]:58630 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbYEUFGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 01:06:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=nqt5yB0s3bqkIzHOhcVdM4EGKPXUmQyMDsNt+pxA/ZsJOspJXA40b5Lg9cPCgQ54Y
	TJqA1xI5C1/1hhEFf7ogA==
Message-ID: <6599ad830805202206v334cb933t5b493988e01b3b21@mail.gmail.com>
Date: Tue, 20 May 2008 22:06:48 -0700
From: "Paul Menage" <menage@google.com>
To: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC][PATCH 2/3] memcg:: seq_ops support for cgroup
Cc: LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "xemul@openvz.org" <xemul@openvz.org>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>
In-Reply-To: <20080521092849.c2f0b7e1.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080520180552.601da567.kamezawa.hiroyu@jp.fujitsu.com>
	 <20080520180841.f292beef.kamezawa.hiroyu@jp.fujitsu.com>
	 <6599ad830805201146g5a2a8928l6a2f5adc51b15f15@mail.gmail.com>
	 <20080521092849.c2f0b7e1.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 5:28 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> With current interface, my concern is hotplug.
>
> File-per-node method requires delete/add files at hotplug.
> A file for all nodes with _maps_ method cannot be used because
> maps file says
> ==
> The key/value pairs (and their ordering) should not
>         * change between reboots.
> ==

OK, so we may need to extend the interface ...

The main reason for that restriction (not allowing the set of keys to
change) was to simplify and speed up userspace parsing and make any
future binary API simpler. But if it's not going to work, we can maybe
make that optional instead.

>
> And (*read) method isn't useful ;)
>
> Can we add new stat file dynamically ?

Yes, there's no reason we can't do that. Right now it's not possible
to remove a control file without deleting the cgroup, but I have a
patch that supports removal.

The question is whether it's better to have one file per CPU/node or
one large complex file.

Paul
