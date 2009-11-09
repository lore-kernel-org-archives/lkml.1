Return-Path: <linux-kernel-owner+w=401wt.eu-S1756075AbZKIP0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbZKIP0d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 10:26:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755969AbZKIP0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 10:26:33 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50093 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057AbZKIP0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 10:26:32 -0500
Subject: Re: Likley stupid question on "throttle_vm_writeout"
From: Peter Zijlstra <peterz@infradead.org>
To: Martin Knoblauch <spamtrap@knobisoft.de>
Cc: linux-kernel@vger.kernel.org, Fengguang Wu <wfg@mail.ustc.edu.cn>
In-Reply-To: <799070.68490.qm@web32608.mail.mud.yahoo.com>
References: <799070.68490.qm@web32608.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Nov 2009 16:26:33 +0100
Message-ID: <1257780393.4108.343.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-09 at 07:15 -0800, Martin Knoblauch wrote:
> Hi, (please CC me on replies)
> 
>  I have a likely stupid question on the function "throttle_vm_writeout". Looking at the code I find:
> 
>                 if (global_page_state(NR_UNSTABLE_NFS) +
>                         global_page_state(NR_WRITEBACK) <= dirty_thresh)
>                                 break;
>                 congestion_wait(WRITE, HZ/10);
> 
> Shouldn't the NR_FILE_DIRTY pages be considered as well?

Ha, you just trod onto a piece of ugly I'd totally forgotten about ;-)

The intent of throttle_vm_writeout() is to limit the total pages in
writeout and to wait for them to go-away.

Everybody hates the function, nobody managed to actually come up with
anything better.

