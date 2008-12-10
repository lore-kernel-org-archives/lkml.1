Return-Path: <linux-kernel-owner+w=401wt.eu-S1755261AbYLJS0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbYLJS0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 13:26:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbYLJS0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 13:26:33 -0500
Received: from smtp-out.google.com ([216.239.45.13]:16776 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378AbYLJS0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 13:26:32 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=tAHbS4F2IfMdb0+wbcAsac/+Bpubo/LoKJrqHmwvKt/VclXQmtKTHVGa00AU4gFut
	Ha5cszhqBmDvj6wOEwXDQ==
MIME-Version: 1.0
In-Reply-To: <20081210224758.46abbd59.d-nishimura@mtf.biglobe.ne.jp>
References: <6599ad830812100240g5e549a5cqe29cbea736788865@mail.gmail.com>
	 <29741.10.75.179.61.1228908581.squirrel@webmail-b.css.fujitsu.com>
	 <20081210132559.GF25467@balbir.in.ibm.com>
	 <20081210224758.46abbd59.d-nishimura@mtf.biglobe.ne.jp>
Date: Wed, 10 Dec 2008 10:26:28 -0800
Message-ID: <6599ad830812101026g7d2813acvec7cdb3e0321f780@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/6] memcg: fix pre_destory handler
From: Paul Menage <menage@google.com>
To: nishimura@mxp.nes.nec.co.jp
Cc: balbir@linux.vnet.ibm.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       d-nishimura@mtf.biglobe.ne.jp
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 5:47 AM, Daisuke Nishimura
<d-nishimura@mtf.biglobe.ne.jp> wrote:
> Hmm.. but doesn't per-hierarchy-mutex solve the problem if memory and cpuset
> mounted on the same hierarchy ?
>

It's not a per-hierarchy mutex - it's a per-subsystem lock against
changes on that subsystem's hierarchy. So each subsystem just has to
take its own lock, rather than a global or per-hierarchy lock. The
cgroups code takes care of acquiring the multiple locks in a safe
order when necessary.

Paul
