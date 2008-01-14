Return-Path: <linux-kernel-owner+w=401wt.eu-S1753975AbYANUyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbYANUyu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 15:54:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751107AbYANUyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 15:54:40 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59882 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750708AbYANUyj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 15:54:39 -0500
Date: Mon, 14 Jan 2008 12:52:00 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: "Oliver Pinter (=?UTF-8?B?UGludMOpciBPbGl2w6ly?=)" 
	<oliver.pntr@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       oliver.pntr@gmail.com
Subject: Re: [BUG] skge 0000:02:05: read data parity error
Message-ID: <20080114125200.28cb4c69@deepthought>
In-Reply-To: <6101e8c40801141157j1ce7d3f0if2e4eb2344b6c844@mail.gmail.com>
References: <6101e8c40801141157j1ce7d3f0if2e4eb2344b6c844@mail.gmail.com>
Organization: Linux Foundation
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jan 2008 20:57:49 +0100
"Oliver Pinter (Pintér Olivér)" <oliver.pntr@gmail.com> wrote:

> Hi All!
> 
> It is fully reproductable under 2.6.22.15, 2.6.23.13 (all tainted and
> not tainted [4 different kernel] ) and 2 different PC:
> 
> [BUG] skge 0000:02:05: read data parity error
> [BUG] skge 0000:02:05: read data parity error
> 
> steps:
> 1. login as root
> 2. start mc
> 3. cd /sys/bus/pci/drivers/skge/0000:02:05.0
> 4. press F3 (mcview) on resource0
> 5. the system hang up, without panic or bug ... only this message
> printed 2x: [BUG] skge 0000:02:05: read data parity error
> 

This is not a bug.

The hardware has some debug registers that if accessed cause a read
back to the host. Since this can point anywhere, it will cause errors
or system hang.

The point is don't do it.

-- 
Stephen Hemminger <stephen.hemminger@vyatta.com>
