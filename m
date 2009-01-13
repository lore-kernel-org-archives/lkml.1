Return-Path: <linux-kernel-owner+w=401wt.eu-S1755795AbZAMQgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795AbZAMQgo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 11:36:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753092AbZAMQge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 11:36:34 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55444 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080AbZAMQge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 11:36:34 -0500
Date: Wed, 14 Jan 2009 01:35:36 +0900 (JST)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: Linux killed Kenny, bastard!
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20090112153304.GA19995@ioremap.net>
References: <20090112153304.GA19995@ioremap.net>
Message-Id: <20090113234952.451A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

sorry... I also don't like this patch.


> @@ -263,6 +270,15 @@ static struct task_struct *select_bad_process(unsigned long *ppoints,
>  		}
>  	} while_each_thread(g, p);
>  
> +	/*
> +	 * We did not find the process with requested string in its name,
> +	 * so lets search for the usual victim.
> +	 */
> +	if (name && !chosen) {
> +		name = NULL;
> +		goto again;
> +	}
> +
>  	return chosen;

this patch makes oom handling slower.
slow bad process selection cause next another out of memory.

then, your trouble become large.



