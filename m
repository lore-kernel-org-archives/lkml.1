Return-Path: <linux-kernel-owner+w=401wt.eu-S1755546AbYJ2Vyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546AbYJ2Vyd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 17:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754303AbYJ2VyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 17:54:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:41678 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbYJ2VyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 17:54:23 -0400
Date: Wed, 29 Oct 2008 14:54:46 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       linux-mm@kvack.org
Subject: Re: 2.6.28-rc2-mm1: possible circular locking
Message-ID: <20081029145446.081141b4@infradead.org>
In-Reply-To: <20081029135840.0a50e19c.akpm@linux-foundation.org>
References: <20081028233836.8b1ff9ae.akpm@linux-foundation.org>
	<200810292146.03967.m.kozlowski@tuxland.pl>
	<20081029135840.0a50e19c.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2008 13:58:40 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> We've been calling schedule_on_each_cpu() from within
> lru_add_drain_all() for ages.  What changed to cause all this
> to start happening?

what started to get these out of the weed is that copy_*_user() is now
annotated to (potentially) take the mmap sem (which it does if there's
a fault)... 
previously you had to actually fault to get the lock dependency noticed.

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit atty://www.lesswatts.org
