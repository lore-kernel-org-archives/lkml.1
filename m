Return-Path: <linux-kernel-owner+w=401wt.eu-S1755408AbZHCQRI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbZHCQRI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 12:17:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755366AbZHCQRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 12:17:07 -0400
Received: from smtp-out.google.com ([216.239.45.13]:48970 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345AbZHCQRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 12:17:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=ax4U0H79Mh2d0eEUrDo3I+6dK+ktTzFJIzmzsTB44kflxc+ofaWT9modpu8RWmhdD
	5bkO3XAfsOqE941gi8q3A==
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0908011303050.22174@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0907282125260.554@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.0907300219580.13674@chino.kir.corp.google.com>
	 <20090730190216.5aae685a.kamezawa.hiroyu@jp.fujitsu.com>
	 <alpine.DEB.2.00.0907301157100.9652@chino.kir.corp.google.com>
	 <20090731093305.50bcc58d.kamezawa.hiroyu@jp.fujitsu.com>
	 <alpine.DEB.2.00.0907310231370.25447@chino.kir.corp.google.com>
	 <7f54310137837631f2526d4e335287fc.squirrel@webmail-b.css.fujitsu.com>
	 <alpine.DEB.2.00.0907311212240.22732@chino.kir.corp.google.com>
	 <77df8765230d9f83859fde3119a2d60a.squirrel@webmail-b.css.fujitsu.com>
	 <alpine.DEB.2.00.0908011303050.22174@chino.kir.corp.google.com>
Date: Mon, 3 Aug 2009 09:17:01 -0700
Message-ID: <6599ad830908030917v6c70ec01ke2ed15f0fb627f9@mail.gmail.com>
Subject: Re: [patch -mm v2] mm: introduce oom_adj_child
From: Paul Menage <menage@google.com>
To: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 1, 2009 at 1:26 PM, David Rientjes<rientjes@google.com> wrote:
>
> It's more likely than not that applications were probably written to the
> way the documentation described the two files: that is, adjust
> /proc/pid/oom_score by tuning /proc/pid/oom_adj

I'd actually be pretty surprised if anyone was really doing that -
don't forget that the oom_score is something that varies dynamically
depending on things like the VM size of the process, its running time,
the VM sizes of its children, etc. So tuning oom_adj based on
oom_score will be rapidly out of date. AFAIK, oom_score was added
initially as a way to debug the OOM killer, and oom_adj was added
later as an additional knob. My suspicion is that any automated users
of oom_adj are working along the lines of

http://www.google.com/codesearch/p?hl=en&sa=N&cd=4&ct=rc#X7-oBZ_RyNM/src/server/memory/base/oommanager.cpp&q=oom_score

which just uses the values -16, 0 or 15, depending on whether the
process is critical, important or expendable.

Paul
