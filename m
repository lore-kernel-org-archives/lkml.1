Return-Path: <linux-kernel-owner+w=401wt.eu-S1753900AbYGEDTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbYGEDTN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 23:19:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657AbYGEDS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 23:18:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:40732 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbYGEDS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 23:18:56 -0400
Message-ID: <486EE804.6020202@kernel.org>
Date: Sat, 05 Jul 2008 12:18:28 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata fixes for .26
References: <20080704131005.GA30768@havoc.gtf.org> <alpine.LFD.1.10.0807040955100.2815@woody.linux-foundation.org> <486EE6CA.2040908@kernel.org>
In-Reply-To: <486EE6CA.2040908@kernel.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 05 Jul 2008 03:18:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> so, it basically behaves like level triggered IRQ latch for ports,
> which also creates an easy-to-miss requirement for MSI implementation
> where the controller should generate a new MSI message when the driver
> clears some of the IRQ pending bits but not all.

Oops, confused.  The easy-to-miss requirement is the controller needing
to resend the message if the irq_stat is cleared but port IRQ is still
pending.  Resending on partial clear is always necessary.

Thanks.

-- 
tejun
