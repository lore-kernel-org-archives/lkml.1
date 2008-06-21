Return-Path: <linux-kernel-owner+w=401wt.eu-S1752784AbYFUPtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbYFUPtq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 11:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751238AbYFUPsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 11:48:22 -0400
Received: from smtp-out.google.com ([216.239.33.17]:58332 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbYFUPsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 11:48:18 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=LE2XtZfYi9P5l23tf3oso4x2a/Aa/ORDma0TJp0AEMqggBfGpwpNGWN9wJpg7p5mJ
	TyHnVHg887e9GvHIstagg==
Message-ID: <6599ad830806210848q1a1538bcw79c2f3217dd49303@mail.gmail.com>
Date: Sat, 21 Jun 2008 08:48:07 -0700
From: "Paul Menage" <menage@google.com>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] introduce task cgroup v2
Cc: balbir@linux.vnet.ibm.com, "Pavel Emelianov" <xemul@openvz.org>,
       containers@lists.osdl.org, LKML <linux-kernel@vger.kernel.org>,
       "Li Zefan" <lizf@cn.fujitsu.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080621180530.E82D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6599ad830806210056n44c7ff37g7cd643f95aef4aa0@mail.gmail.com>
	 <485CC255.9010504@linux.vnet.ibm.com>
	 <20080621180530.E82D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 21, 2008 at 2:10 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>
> I am going to convert spinlock in task limit cgroup to atomic_t.
> task limit cgroup has following caractatics.
>        - many write (fork, exit)
>        - few read
>        - fork() is performance sensitive systemcall.

This is true, but I don't see how it can be more performance-sensitive
than the overhead of allocating/freeing a page.

What kinds of performance regressions did you see?

>          if increase fork overhead, system total performance cause degression.

What kind of overhead were you seeing? How about if you delay doing
any task accounting until the task_limit subsystem is bound to a
hierarchy? That way there's no noticeable overhead for people who
aren't using your subsystem.

Paul
