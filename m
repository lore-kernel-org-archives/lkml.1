Return-Path: <linux-kernel-owner+w=401wt.eu-S1757307AbYGCWDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307AbYGCWDb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 18:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756328AbYGCWDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 18:03:20 -0400
Received: from smtp-out.google.com ([216.239.33.17]:10716 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755768AbYGCWDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 18:03:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=xFR26hojmGuInoXgBLfT23JYpOkzsh9jNPDKoBdH7H0BJssFlkNl5BqZU83Rt3R0L
	y61/kEg1XRhy8IvP3blpA==
Message-ID: <6599ad830807031503s6c7f3d5fu3bf65d5a944f5c17@mail.gmail.com>
Date: Thu, 3 Jul 2008 15:03:05 -0700
From: "Paul Menage" <menage@google.com>
To: "Matt Helsley" <matthltc@us.ibm.com>
Subject: Re: Attaching PID 0 to a cgroup
Cc: "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Andrea Righi" <righi.andrea@gmail.com>,
       "Li Zefan" <lizf@cn.fujitsu.com>, lkml <linux-kernel@vger.kernel.org>,
       "Sudhir Kumar" <skumar@linux.vnet.ibm.com>, containers@lists.osdl.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <1215122375.14808.180.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080701094545.GD3925@linux.vnet.ibm.com>
	 <20080701094734.GE3925@linux.vnet.ibm.com>
	 <486A06B7.7020906@cn.fujitsu.com> <486AA62F.40503@gmail.com>
	 <20080701215448.GD5893@linux.vnet.ibm.com>
	 <1215122375.14808.180.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 3, 2008 at 2:59 PM, Matt Helsley <matthltc@us.ibm.com> wrote:
> ------------
>        char buffer[16];
>        int fd;
>
>        fd = open("/some/cgroup/tasks", O_WRONLY);
>
>        /*
>         * These two writes produce the same effect: adding this process
>         * to /some/cgroup.
>         */
>        if (the_slightly_shorter_way)
>                write(fd, "0", 2);
>        else {
>                /* The slightly-less-short way */
>                snprintf(buffer, 16, "%u", getpid());
>                write(fd, buffer, strlen(buffer));

If it's a threaded application, then you'd need gettid() rather than
getpid() for the two to be equivalent.

Paul
