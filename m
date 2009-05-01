Return-Path: <linux-kernel-owner+w=401wt.eu-S1763097AbZEAUKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763097AbZEAUKq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 16:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765491AbZEAUKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 16:10:33 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47137 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762624AbZEAUKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 16:10:32 -0400
Date: Fri, 1 May 2009 16:10:28 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Josh Stone <jistone@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jason Baron <jbaron@redhat.com>,
       mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] export softirq_to_name symbol
Message-ID: <20090501201028.GA2084@infradead.org>
References: <20090501193022.GB3111@redhat.com> <20090501195015.GA31694@infradead.org> <49FB5686.8020908@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49FB5686.8020908@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 01:07:34PM -0700, Josh Stone wrote:
> I'm adding SystemTap support for the format strings in the TRACE_EVENT
> macros.  The softirq's TP_fast_assign uses softirq_to_name, and so that
> array is needed to prepare the softirq's trace string.
> 
> So, there's no explicit reference to the symbol in SystemTap -- it's
> just indirectly referenced by the tracepoint declaration.

TP_fast_assign should only be called by core code, it's the piece that
copies the trace into the ring buffer.  If systemtap copies events into
the ring buffer from modular code something is deeply wrong in it's
design.

