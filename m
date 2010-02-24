Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244Ab0BXQGZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 11:06:25 -0500
Received: from smtp-out.google.com ([216.239.33.17]:10416 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756294Ab0BXQGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 11:06:24 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=oVH/3l1ivpYm10oZhQHSJKHhOPhmMDuQ9iWshyj58/FI4FEVKB2yUfWSTGCqahBke
	OkN3+M6BMFmeH22O/PxAg==
MIME-Version: 1.0
In-Reply-To: <cc557aab1002240528t28eae36dj976525be2fcf7246@mail.gmail.com>
References: <4B849B73.1040106@cn.fujitsu.com>
	 <cc557aab1002240528t28eae36dj976525be2fcf7246@mail.gmail.com>
Date: Wed, 24 Feb 2010 08:06:20 -0800
Message-ID: <6599ad831002240806p69fcbc01l1173dd2ad971dac9@mail.gmail.com>
Subject: Re: [PATCH -mm] cgroups: fix failure path in cgroup_write_event_control()
From: Paul Menage <menage@google.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "containers@lists.osdl.org" <containers@lists.osdl.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 24, 2010 at 5:28 AM, Kirill A. Shutemov
<kirill@shutemov.name> wrote:
>>
>> Using a single goto label to cleanup multi failure paths can
>> get things wrong quite easily, while multi labels makes the
>> code cleaner.
>
> I disagree.
> It's easer to make mistake on changing code with multi failure
> paths, if you want to move a code within function.

I'm on Kirill's side here. Being able to have a single "cleanup
everything" error path makes the code a lot more maintainable. It may
be inappropriate for really performance-critical functions, but that's
not the case here.

Paul
