Return-Path: <linux-kernel-owner+w=401wt.eu-S939784AbXG3Uxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939784AbXG3Uxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 16:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938963AbXG3Uxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 16:53:37 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55839 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758693AbXG3Uxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 16:53:36 -0400
Date: Mon, 30 Jul 2007 13:53:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Jin <joe.jin@oracle.com>
Cc: gurudas pai <gurudas.pai@oracle.com>, torvalds@linux-foundation.org,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       wen.gang.wang@oracle.com, Badari Pulavarty <pbadari@us.ibm.com>,
       Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH] add check do_direct_IO() return val
Message-Id: <20070730135316.2ce21b28.akpm@linux-foundation.org>
In-Reply-To: <20070728034719.GA24448@joejin-pc.cn.oracle.com>
References: <20070726090400.GA18640@joejin-pc.cn.oracle.com>
	<20070726221307.3d7b3446.akpm@linux-foundation.org>
	<20070727071547.GA25084@joejin-pc.cn.oracle.com>
	<46A9E6F9.20603@oracle.com>
	<20070728034719.GA24448@joejin-pc.cn.oracle.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Jul 2007 11:47:19 +0800
Joe Jin <joe.jin@oracle.com> wrote:

> > I tested Andrew's patch and panic was gone but got few ENOTBLK.
> > So I tried with Joe's patch , both panic and ENOTBLK are gone now.
> > But in Joe's patch if (ret == -ENOTBLK && (rw & WRITE)), dio_cleanup(dio)
> > was not getting called because of break. So I moved dio_cleanup just 
> > after if (ret).
> 
> Guru, actually, break from the loop with ENOTBLK will call dio_cleanup
> at leater, if call it too early, that means will put_page(), maybe cause
> other panic.
> 

fyi, I dropped the earlier patch and now we have nothing.  Please let's get all
this sorted out in time for 2.6.23.  Which is still many weeks away so there is
plenty of time to prepare something which was carefully reviewed and well-tested,
thanks.
