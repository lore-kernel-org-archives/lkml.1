Return-Path: <linux-kernel-owner+w=401wt.eu-S1754274Ab0AENt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274Ab0AENt7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 08:49:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754199Ab0AENt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 08:49:58 -0500
Received: from casper.infradead.org ([85.118.1.10]:34802 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126Ab0AENt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 08:49:57 -0500
Date: Tue, 5 Jan 2010 05:52:24 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: strict copy_from_user checks issues?
Message-ID: <20100105055224.39f9efff@infradead.org>
In-Reply-To: <201001051445.26149.arnd@arndb.de>
References: <20100104154345.GA5671@osiris.boeblingen.de.ibm.com>
	<20100105094857.GB5480@osiris.boeblingen.de.ibm.com>
	<20100105053443.4a43fc18@infradead.org>
	<201001051445.26149.arnd@arndb.de>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jan 2010 14:45:25 +0100
Arnd Bergmann <arnd@arndb.de> wrote:
> 
> I think it will get inlined on 32 bit machines or without
> CONFIG_COMPAT, but not when CONFIG_COMPAT is enabled, because then
> there are two call-sites.

one of them is buggy it seems;
it passes in a shorter length, but there is no code in sight that makes
sure that the end of the structure (the difference between the shorter
and full length one) gets initialized to, say, zeros rather than stack
garbage. So looks like there is at least a bug there.

Would be nice if the copy (+ clear) would be pulled to the two callers
I suspect... at which point the warning will go away too as a side
effect.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
