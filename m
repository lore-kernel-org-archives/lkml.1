Return-Path: <linux-kernel-owner+w=401wt.eu-S1754120AbYJ2PtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbYJ2PtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 11:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbYJ2PtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 11:49:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:50556 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbYJ2PtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 11:49:09 -0400
Date: Wed, 29 Oct 2008 08:49:32 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, morgan@kernel.org, serue@us.ibm.com
Subject: Re: [PATCH] Capabilities: BUG when an invalid capability is
 requested
Message-ID: <20081029084932.77de26fd@infradead.org>
In-Reply-To: <1225294932.23736.28.camel@localhost.localdomain>
References: <1225294932.23736.28.camel@localhost.localdomain>
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

On Wed, 29 Oct 2008 11:42:12 -0400
Eric Paris <eparis@redhat.com> wrote:

> If an invalid (large) capability is requested the capabilities system
> may panic as it is dereferencing an array of fixed (short) length.
> Its possible (and actually often happens) that the capability system
> accidentally stumbled into a valid memory region but it also regularly
> happens that it hits invalid memory and BUGs.  If such an operation
> does get past cap_capable then the selinux system is sure to have
> problems as it already does a (simple) validity check and BUG.  This
> is known to happen by the broken and buggy firegl driver.
> 
> This patch cleanly checks all capable calls and BUG if a call is for
> an invalid capability.  This will likely break the firegl driver for
> some situations, but it is the right thing to do.  Garbage into a
> security system gets you killed/bugged
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>
> 

Acked-by: Arjan van de Ven <arjan@linux.intel.com>
