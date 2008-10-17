Return-Path: <linux-kernel-owner+w=401wt.eu-S1756899AbYJQPU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899AbYJQPU5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 11:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753685AbYJQPUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 11:20:47 -0400
Received: from gw.goop.org ([64.81.55.164]:45681 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752763AbYJQPUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 11:20:46 -0400
Message-ID: <48F8AD4D.30706@goop.org>
Date: Fri, 17 Oct 2008 08:20:45 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb <linux-usb@vger.kernel.org>
Subject: Re: Oops in UHCI when encountering "host controller process error"
References: <Pine.LNX.4.44L0.0810171046530.2178-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0810171046530.2178-100000@iolanthe.rowland.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
>> ------------[ cut here ]------------
>> WARNING: at /home/jeremy/hg/xen/paravirt/linux/drivers/usb/host/uhci-q.c:1744 uhci_scan_schedule+0xb7/0x9a3()
>> uhci->skelqh[1]->node.next is NULL
>>     
>
> Odd.  Is skelqh[1] the only entry whose node.next is NULL?  Not 
> skelqh[2] or others?
>   

No, the others too, but all the WARN_ON backtraces got very verbose and 
I had to rush home at the end of the day.

> The node is initialized during uhci_start() in uhci-hcd.c -- there's a
> loop which initializes all the uhci->skelqh[i] entries by calling
> uhci_alloc_qh().  You should check inside that loop to see whether
> uhci->skelqh[i]->node.next is NULL to begin with.  If it is then
> something about the DMA-coherent memory is funny; if not then the
> linked list pointer gets corrupted somewhere.
>   

OK, will check it out.

    J
