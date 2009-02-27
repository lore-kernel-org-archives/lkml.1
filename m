Return-Path: <linux-kernel-owner+w=401wt.eu-S1760415AbZB0A3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760415AbZB0A3I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 19:29:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756174AbZB0A2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 19:28:19 -0500
Received: from smtp-out.google.com ([216.239.45.13]:51817 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760505AbZB0A2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 19:28:17 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=ydxy1u/XCXwfPAazg4ry8jcSeNdiGIjqJYpcXqzNk4zG9Vzt21zwqsAK55pC3l6xm
	egiKVrZi/Y/0h3iKVAK3A==
MIME-Version: 1.0
In-Reply-To: <20090226130005.3282cb02.akpm@linux-foundation.org>
References: <20090225163555.d2a0b24c.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090226130005.3282cb02.akpm@linux-foundation.org>
Date: Thu, 26 Feb 2009 16:28:11 -0800
Message-ID: <6599ad830902261628k4ce8e1aflb7981672562801fb@mail.gmail.com>
Subject: Re: [PATCH 1/2] cgroup allow subsys to set default mode of its own 
	file
From: Paul Menage <menage@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       lizf@cn.fujitsu.com, balbir@linux.vnet.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 1:00 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 25 Feb 2009 16:35:55 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
>>  When I wrote tools for maintain cgroup, I can't find which file is
>>  writable intarfece or not via cgroup file systems. (finally, I did
>>  dirty approach.)
>>  IMHO, showing "this file is read-only" in explicit way is useful
>>  for user-land (tools). In other story, a file whose name sounds read-only
>>  may have "trigger" operation and support reseting. In this case,
>>  "writable" is informative.
>
> Well, we have compatibility issues here.  If we make this change, and
> people write tools which depend upon that change then those tools might
> break when run upon older kernels.

I don't think that's too big a deal - a write can always fail at the
whim of a cgroups subsystem, so this would just be a hint to a tool
that it shouldn't even bother trying to write to the file. It should
be able to handle a failure.

But I don't see why we can't figure out the mode automatically based
on whether or not there's a write handler defined for the control
file.

Paul
