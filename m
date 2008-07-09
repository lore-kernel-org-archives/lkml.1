Return-Path: <linux-kernel-owner+w=401wt.eu-S1754853AbYGIUO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbYGIUO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751070AbYGIUOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:14:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:48507 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbYGIUOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:14:50 -0400
Date: Wed, 9 Jul 2008 13:14:05 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Mike Travis <travis@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
Message-ID: <20080709131405.54f9d49b@infradead.org>
In-Reply-To: <m1abgqzv3g.fsf@frodo.ebiederm.org>
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>
	<m1abgqzv3g.fsf@frodo.ebiederm.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Jul 2008 13:00:19 -0700
ebiederm@xmission.com (Eric W. Biederman) wrote:

> 
> I just took a quick look at how stack_protector works on x86_64.
> Unless there is some deep kernel magic that changes the segment
> register to %gs from the ABI specified %fs CC_STACKPROTECTOR is
> totally broken on x86_64.  We access our pda through %gs.

and so does gcc in kernel mode.

> 
> Further -fstack-protector-all only seems to detect against buffer
> overflows and thus corruption of the stack.  Not stack overflows.  So
> it doesn't appear especially useful.

stopping buffer overflows and other return address corruption is not
useful? Excuse me?

> 
> So we don't we kill the broken CONFIG_CC_STACKPROTECTOR.  Stop trying
> to figure out how to use a zero based percpu area.

So why don't we NOT do that and fix instead what you're trying to do?

> 
> That should allow us to make the current pda a per cpu variable, and
> use %gs with a large offset to access the per cpu area. 

and what does that gain us?


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
