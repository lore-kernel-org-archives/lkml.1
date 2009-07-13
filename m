Return-Path: <linux-kernel-owner+w=401wt.eu-S1756564AbZGMQ0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564AbZGMQ0d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 12:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756533AbZGMQ0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 12:26:32 -0400
Received: from smtp-out.google.com ([216.239.45.13]:60040 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756527AbZGMQ0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 12:26:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=x1sik4FhtcHq4+7UyFSrM4Gew6MyOtQTlfxqHCRfz2stOvDS8i5MjOXXEmzFdeekm
	nPZRjZs8H6JygmW+NcKNw==
MIME-Version: 1.0
In-Reply-To: <20090713121138.GC5051@balbir.in.ibm.com>
References: <20090702231814.3969.44308.stgit@menage.mtv.corp.google.com>
	 <20090705063850.GX11273@balbir.in.ibm.com>
	 <6599ad830907101658i13e4046br70377a487dd6b49b@mail.gmail.com>
	 <20090713121138.GC5051@balbir.in.ibm.com>
Date: Mon, 13 Jul 2009 09:26:26 -0700
Message-ID: <6599ad830907130926v7788af12hdcd76e4ccb3ab6de@mail.gmail.com>
Subject: Re: [PATCH 0/2] CGroups: cgroup member list enhancement/fix
From: Paul Menage <menage@google.com>
To: balbir@linux.vnet.ibm.com
Cc: lizf@cn.fujitzu.com, bblum@google.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       libcg-devel <libcg-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 13, 2009 at 5:11 AM, Balbir Singh<balbir@linux.vnet.ibm.com> wrote:
>
> How about lazy migration? Mark a group as to move when the kernel sees
> it next for scheduling.

Waiting for the next scheduling point might be too long, since a
thread can block for arbitrary amounts of time and keeping the marker
around for arbitrary time (unless we add a new task_struct field)
would be tricky. Marking the cgroup or tgid as being migrated which
then triggers the extra synchronization in the fork path (but which
isn't needed at other times) is probably where we'll end up.

Paul
