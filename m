Return-Path: <linux-kernel-owner+w=401wt.eu-S938718AbXG1DrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938718AbXG1DrZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 23:47:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935917AbXG1DrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 23:47:18 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:16056 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935689AbXG1DrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 23:47:17 -0400
Date: Sat, 28 Jul 2007 11:47:19 +0800
From: Joe Jin <joe.jin@oracle.com>
To: gurudas pai <gurudas.pai@oracle.com>
Cc: Joe Jin <joe.jin@oracle.com>, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, wen.gang.wang@oracle.com,
       Badari Pulavarty <pbadari@us.ibm.com>,
       Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH] add check do_direct_IO() return val
Message-ID: <20070728034719.GA24448@joejin-pc.cn.oracle.com>
References: <20070726090400.GA18640@joejin-pc.cn.oracle.com> <20070726221307.3d7b3446.akpm@linux-foundation.org> <20070727071547.GA25084@joejin-pc.cn.oracle.com> <46A9E6F9.20603@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A9E6F9.20603@oracle.com>
User-Agent: Mutt/1.4.2.2i
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I tested Andrew's patch and panic was gone but got few ENOTBLK.
> So I tried with Joe's patch , both panic and ENOTBLK are gone now.
> But in Joe's patch if (ret == -ENOTBLK && (rw & WRITE)), dio_cleanup(dio)
> was not getting called because of break. So I moved dio_cleanup just 
> after if (ret).

Guru, actually, break from the loop with ENOTBLK will call dio_cleanup
at leater, if call it too early, that means will put_page(), maybe cause
other panic.

Thanks,
Joe
