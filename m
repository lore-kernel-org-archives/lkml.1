Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab0CHKRS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 05:17:18 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:2158 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769Ab0CHKRQ convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:4:1>);
	Mon, 8 Mar 2010 05:17:16 -0500
Message-Id: <4B94DCB7020000780003337B@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 08 Mar 2010 10:17:11 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <linux@dominikbrodowski.net>, "Andrew Morton" <akpm@linux-foundation.org>,
       <alan@linux.intel.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: pcmcia's use of IRQ_NOAUTOEN
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(re-sending to correct Alan's email address)

Commit 635416ef393e8cec5a89fc6c1de710ee9596a51e introduced
this, but I can't see how it can take effect - the argument passed to
request_irq() only affects action->flags (IRQF_*), whereas the flag
in question is a desc->status one (IRQ_*). Am I overlooking
something? If not, while currently this just should not work as expected,
it's latently more significant (as soon as the IRQF_* definitions make
use of the bit used by IRQ_NOAUTOEN).

Thanks, Jan

