Return-Path: <linux-kernel-owner+w=401wt.eu-S1753421AbZGMAyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbZGMAyR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 20:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751435AbZGMAyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 20:54:07 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48648 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbZGMAyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 20:54:06 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 13 Jul 2009 09:52:09 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Vladislav D. Buzov" <vbuzov@embeddedalley.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers Mailing List 
	<containers@lists.linux-foundation.org>,
       Dan Malek <dan@embeddedalley.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Menage <menage@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, linux-mm@kvack.org
Subject: Re: [PATCH 1/1] Memory usage limit notification addition to memcg
Message-Id: <20090713095209.d8b6e566.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4A554B54.3080903@embeddedalley.com>
References: <1239660512-25468-1-git-send-email-dan@embeddedalley.com>
	<1246998310-16764-1-git-send-email-vbuzov@embeddedalley.com>
	<1246998310-16764-2-git-send-email-vbuzov@embeddedalley.com>
	<20090708095616.cdfe8c7c.kamezawa.hiroyu@jp.fujitsu.com>
	<4A554B54.3080903@embeddedalley.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Jul 2009 18:43:48 -0700
"Vladislav D. Buzov" <vbuzov@embeddedalley.com> wrote:

> KAMEZAWA Hiroyuki wrote:

> > 2 points.
> >  - Do we have to check this always we account ?
> >   
> What are the options? Every N pages? How to select N?
> 
I think you can reuse Balbir's softlimit event counter. (see v9.)


> > If this is true, "set limit" should be checked to guarantee this.
> > plz allow minus this for avoiding mess.
> Setting the memory controller cgroup limit and the notification
> threshold are two separate operations. There isn't any "mess," just some
> validation testing for reporting back to the source of the request. When
> changing the memory controller limit, we ensure the threshold limit is
> never allowed "negative." At most, the threshold limit will be equal the
> memory controller cgroup limit. Otherwise, the arithmetic and
> conditional tests during the operational part of the software becomes
> more complex, which we don't want.
> 
Hmm, then, plz this interface put under "set_limit_mutex".

Thanks,
-Kame

