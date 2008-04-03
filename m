Return-Path: <linux-kernel-owner+w=401wt.eu-S1757519AbYDCS4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519AbYDCS4n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 14:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754545AbYDCS4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 14:56:35 -0400
Received: from smtp-out.google.com ([216.239.33.17]:50161 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbYDCS4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 14:56:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=P4jzb7cP3rrB6zuO/LhU41wv21Tys4PxOYNNAppWir2TJmV5Yfwx5tFnYb9tQifCf
	fli21R8ZDB7y5JkAjFiMQ==
Message-ID: <6599ad830804031156w79366866yed9f8c3b8acf71fb@mail.gmail.com>
Date: Thu, 3 Apr 2008 11:56:16 -0700
From: "Paul Menage" <menage@google.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [-mm] Add an owner to the mm_struct (v7)
Cc: "Dave Hansen" <dave@linux.vnet.ibm.com>,
       "Pavel Emelianov" <xemul@openvz.org>, "Hugh Dickins" <hugh@veritas.com>,
       "Sudhir Kumar" <skumar@linux.vnet.ibm.com>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       "David Rientjes" <rientjes@google.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <47F52735.7090502@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080403174433.26356.42121.sendpatchset@localhost.localdomain>
	 <1207247113.21922.63.camel@nimitz.home.sr71.net>
	 <47F52735.7090502@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 3, 2008 at 11:51 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>  >> +     * delay_group_leader() ensures that if the group leader is around
>  >> +     * we need not select a new owner.
>  >> +     */
>  >> +    ret = (mm && (atomic_read(&mm->mm_users) > 1) && (mm->owner == p) &&
>  >> +            !delay_group_leader(p));
>  >> +    return ret;
>  >> +}
>  >
>  > Ugh.  Could you please spell this out a bit more.  I find that stuff
>  > above really hard to read.  Something like:
>  >
>  >       if (!mm)
>  >               return 0;
>  >       if (atomic_read(&mm->mm_users) <= 1)
>  >               return 0;
>  >       if (mm->owner != p)
>  >               return 0;
>  >       if (delay_group_leader(p))
>  >               return 0;
>  >       return 1;
>  >
>
>  The problem with code above is 4 branch instructions and the code I have just 4
>  AND operations.

They'll be completely equivalent to the compiler, due to the
short-circuit evaluation of &&

Paul
