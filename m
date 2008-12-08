Return-Path: <linux-kernel-owner+w=401wt.eu-S1753442AbYLHV7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbYLHV7j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 16:59:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752500AbYLHV7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 16:59:31 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47386 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752431AbYLHV7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 16:59:30 -0500
Date: Mon, 8 Dec 2008 13:58:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-kernel@vger.kernel.org, frederik.deweerdt@xprog.eu,
       randy.dunlap@oracle.com, zbr@ioremap.net
Subject: Re: [W1] List slaves commands.
Message-Id: <20081208135848.2a529f86.akpm@linux-foundation.org>
In-Reply-To: <12284808903744-git-send-email-zbr@ioremap.net>
References: <1228480888739-git-send-email-zbr@ioremap.net>
	<1228480889246-git-send-email-zbr@ioremap.net>
	<12284808902058-git-send-email-zbr@ioremap.net>
	<12284808903744-git-send-email-zbr@ioremap.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  5 Dec 2008 15:41:27 +0300
Evgeniy Polyakov <zbr@ioremap.net> wrote:

> +		u64 *data = (void *)(cmd + 1) + cmd->len;
> +
> +		*data = rn;

This code performs quite a lot of potentially unaligned acceses.

Is there anything which guarantees that all these accesses are
well-aligned?

If not, will there be issues with platforms which don't handle
unaligned accesses as well as x86?

Should this code be using the unaligned access interfaces
(get_unaligned, put_unaligned, etc.  Might be wrong.  Keeps changing. 
Harvey Harrison is the guy to ask)?

