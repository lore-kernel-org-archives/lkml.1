Return-Path: <linux-kernel-owner+w=401wt.eu-S1752748AbZGLH56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbZGLH56 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 03:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751344AbZGLH5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 03:57:49 -0400
Received: from relay.atmel.no ([80.232.32.139]:56602 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339AbZGLH5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 03:57:49 -0400
Date: Sun, 12 Jul 2009 09:57:31 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-mm@kvack.org,
       kernel@avr32linux.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG 2.6.30] Bad page map in process
Message-ID: <20090712095731.3090ef56@siona>
In-Reply-To: <Pine.LNX.4.64.0907101900570.27223@sister.anvils>
References: <Pine.LNX.4.64.0907081250110.15633@axis700.grange>
	<Pine.LNX.4.64.0907101900570.27223@sister.anvils>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.2; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jul 2009 19:34:06 +0100 (BST)
Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:

> I've not looked up avr32 pte layout, is 13f26ed4 good or bad?
> I hope avr32 people can tell more about the likely cause.

It looks OK for a user mapping, assuming you have at least 64MB of
SDRAM (the SDRAM starts at 0x10000000) -- all the normal userspace flags
are set and all the kernel-only flags are unset. It's marked as
executable, so it could be that the segfault was caused by the CPU
executing the wrong code.

The virtual address 0x4377f876 is a bit higher than what you normally
see on avr32 systems, but there's not necessarily anything wrong with
it -- userspace goes up to 0x80000000.

Btw, is preempt enabled when you see this?

Haavard
