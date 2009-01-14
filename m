Return-Path: <linux-kernel-owner+w=401wt.eu-S1752952AbZANDGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952AbZANDGL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 22:06:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752306AbZANDFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 22:05:42 -0500
Received: from smtp-out.google.com ([216.239.45.13]:16132 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbZANDFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 22:05:40 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=v9Ccl/sCP1Eo67fXNnYnIv+B56Kfnm0uhoyf//8CwDb+ibmUw0MPIml1wnDSkb/pv
	40PhZrYgm45NZ+xEGRiGg==
MIME-Version: 1.0
In-Reply-To: <20090114120044.2ecf13db.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090108182556.621e3ee6.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090108183529.b4fd99f4.kamezawa.hiroyu@jp.fujitsu.com>
	 <6599ad830901131848gf7f6996iead1276bc50753b8@mail.gmail.com>
	 <20090114120044.2ecf13db.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 13 Jan 2009 19:05:35 -0800
Message-ID: <6599ad830901131905ie10e4bl5168ab7f337b27e1@mail.gmail.com>
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
X-GMailtapped-By: 172.24.198.93
X-GMailtapped: menage
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 7:00 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
> Hmm, add wait_queue to css and wake it up at css_put() ?
>
> like this ?
> ==
> __css_put()
> {
>        if (atomi_dec_return(&css->refcnt) == 1) {
>                if (notify_on_release(cgrp) {
>                        .....
>                }
>                if (someone_waiting_rmdir(css)) {
>                        wake_up_him().
>                }
>        }
> }

Yes, something like that. A system-wide wake queue is probably fine though.

> pre_destroy() is for that.  Now, If there are still references from "page"
> after pre_destroy(), it's bug.

OK.

Paul
