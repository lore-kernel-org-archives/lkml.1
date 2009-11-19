Return-Path: <linux-kernel-owner+w=401wt.eu-S932586AbZKSEvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586AbZKSEvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 23:51:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932547AbZKSEvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 23:51:00 -0500
Received: from casper.infradead.org ([85.118.1.10]:53695 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932541AbZKSEu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 23:50:59 -0500
Date: Wed, 18 Nov 2009 20:52:40 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <npiggin@suse.de>, Jan Beulich <JBeulich@novell.com>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, hpa@zytor.com,
       Ravikiran Thirumalai <kiran@scalex86.org>,
       Shai Fultheim <shai@scalemp.com>
Subject: Re: [PATCH] x86: eliminate redundant/contradicting cache line size
 config options
Message-ID: <20091118205240.11d3d660@infradead.org>
In-Reply-To: <20091119035640.GA18236@elte.hu>
References: <4AFD5710020000780001F8F0@vpn.id2.novell.com>
	<20091116041407.GB5818@wotan.suse.de>
	<4B011677020000780001FD9D@vpn.id2.novell.com>
	<20091116105657.GE5818@wotan.suse.de>
	<20091119035640.GA18236@elte.hu>
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

On Thu, 19 Nov 2009 04:56:40 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Nick Piggin <npiggin@suse.de> wrote:
> 
> > The only other use for L1 cache size macro is to pack objects to 
> > cachelines better (so they always use the fewest number of lines).
> > But this case is more rare nowadays people don't really count
> > cachelines anymore, but I think even then it makes sense for it to
> > be the largest line size in the system because we don't know how
> > big L1s are, and if you want opimal L1 packing, you likely also
> > want optimal Ln packing.
> 
> We could do that - but then this default of X86_INTERNODE_CACHE_SHIFT:
> 
> +       default "7" if NUMA
> 
> will bite us and turns the 64 bytes L1_CACHE_BYTES into an effective
> 128 bytes value.
> 
> So ... are you arguing for an increase of the default x86 linesize to 
> 128 bytes?

128 is basically always wrong.
(unless you have a P4... but for default really we should not care
about those anymore)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
