Return-Path: <linux-kernel-owner+w=401wt.eu-S1756043AbXF2UuO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043AbXF2UuO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 16:50:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754869AbXF2UuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 16:50:03 -0400
Received: from fest.stud.feec.vutbr.cz ([147.229.72.16]:54772 "EHLO
	fest.stud.feec.vutbr.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754761AbXF2UuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 16:50:01 -0400
Message-ID: <46857049.7030505@stud.feec.vutbr.cz>
Date: Fri, 29 Jun 2007 22:49:13 +0200
From: Michal Schmidt <xschmi00@stud.feec.vutbr.cz>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070622)
MIME-Version: 1.0
To: LOL ER <cryptococa@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Need help making sense of IRQ API
References: <6a1c323c0706291255l78d3081at2e0738a5c7cbf73b@mail.gmail.com>
In-Reply-To: <6a1c323c0706291255l78d3081at2e0738a5c7cbf73b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

LOL ER wrote:
> Hello,
>   I've been trying to make sense of how the kernel (on an i386) calls
> __do_IRQ() from do_IRQ() for the past few days to no avail. [...]

Since i386 was switched to the generic-IRQ architecture (see "Linux
generic IRQ handling" in Documentation/Docbook) it does not use __do_IRQ().

common_interrupt (in assembler) calls do_IRQ(), which calls
desc->handle_irq() that is usually one of:
 handle_fasteoi_irq()
 handle_level_irq()
 handle_edge_irq()

Michal
