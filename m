Return-Path: <linux-kernel-owner+w=401wt.eu-S1754995AbZI3Xef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995AbZI3Xef (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 19:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754235AbZI3Xef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 19:34:35 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36525 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094AbZI3Xee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 19:34:34 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 1 Oct 2009 08:31:33 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/2] percpu array counter like vmstat
Message-Id: <20091001083133.429f373b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090930190943.8f19c48b.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090930190417.8823fa44.kamezawa.hiroyu@jp.fujitsu.com>
	<20090930190943.8f19c48b.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Sep 2009 19:09:43 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> +int array_counter_init(struct array_counter *ac, int size)
> +{
> +	ac->v.elements = size;
> +	ac->v.counters = alloc_percpu(s8);
This is a bug, of course...
should be
ac->v.counters = __alloc_percpu(size, __alignof__(char));

Regads,
-Kame

