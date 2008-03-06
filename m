Return-Path: <linux-kernel-owner+w=401wt.eu-S933382AbYCFMji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933382AbYCFMji (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 07:39:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755475AbYCFMja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 07:39:30 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:33508 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610AbYCFMj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 07:39:29 -0500
Date: Thu, 6 Mar 2008 07:39:07 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, andi@firstfloor.org, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [patch 1/2] x86, fpu: split FPU state from task struct - v3
Message-ID: <20080306123907.GB12232@infradead.org>
References: <20080303230335.892214000@linux-os.sc.intel.com> <20080304011849.GA22431@infradead.org> <20080304013649.GB28006@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080304013649.GB28006@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2008 at 05:36:49PM -0800, Suresh Siddha wrote:
> > You're still adding a second hook instead of re-using or re-naming
> > setup_thread_stack.  Did I miss a good explanation for that
> > or was this just an oversight?
> 
> Not an oversight. setup_thread_stack comes with its own baggage called
> __HAVE_THREAD_FUNCTIONS. Thought of keeping this simple and separate
> by using an inline or weak linkage.

Well, just switching setup_thread_stack to use whatever you use for your
current callout fixes that.  I really don't want to arch callout doing
the same thing in almost the same place, this leads to twisted and
unreadable code.  Please fix this last bit up and you'll get my full
ACK.

