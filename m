Return-Path: <linux-kernel-owner+w=401wt.eu-S1751390AbYLPGa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751390AbYLPGa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 01:30:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340AbYLPGaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 01:30:20 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:39535 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbYLPGaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 01:30:19 -0500
Date: Tue, 16 Dec 2008 15:26:59 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: miaox@cn.fujitsu.com
Cc: nishimura@mxp.nes.nec.co.jp, Paul Menage <menage@google.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Why are the pages not migrated to current cpuset after
 'memory_migrate' is set true
Message-Id: <20081216152659.4eb384c4.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <4947389D.1050708@cn.fujitsu.com>
References: <4947389D.1050708@cn.fujitsu.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Tue, 16 Dec 2008 13:11:57 +0800, Miao Xie <miaox@cn.fujitsu.com> wrote:
> Hi, Paul
> 
> I found the pages that task had allocated to it on nodes in its previous cpuset
> were not migrated to the tasks' current cpuset after 'memory_migrate' was set
> true. It looks strange for users. Why are the pages not migrated to current
> cpuset after 'memory_migrate' is set true?
> 
I don't know the reason of current behavior, but

> Step I did
> 1, allocate pages on cpuset (mems is 0, memory_migrate is 0)
> 2, change cpuset's mems (mems: 0 -> 1)
> 3, change cpuset's memory_migrate(memory_migrate: 0 -> 1) 
>  
from/to which node kernel should migrate pages in general ?

Should kernel remember previous value of "mems" ? What if we change "mems"
several times before setting memory_migrate ON ?

IMHO, current behavior is not so strange. All users have to do is
set memory_migrate ON *before* changing "mems" or attaching task
if they want to migrate pages.


Thanks,
Daisuke Nishimura.
