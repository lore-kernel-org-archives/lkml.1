Return-Path: <linux-kernel-owner+w=401wt.eu-S1754429AbYH3QCI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbYH3QCI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 12:02:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613AbYH3QB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 12:01:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:60018 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbYH3QBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 12:01:55 -0400
Date: Sat, 30 Aug 2008 09:01:58 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Avoid double flush in do_tlb_flush_all()
Message-ID: <20080830090158.072d40b3@infradead.org>
In-Reply-To: <20080830102012.GA21145@basil.nowhere.org>
References: <20080830102012.GA21145@basil.nowhere.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Aug 2008 12:20:12 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> Avoid double flush in do_tlb_flush_all()
> 
> leave_mm already flushes the TLBs, so don't need to flush directly
> before that in do_flush_tlb_all(). Avoid the double flush.

but... the leave_mm won't flush the global tlbs, while
__flush_tlb_all() does, right?

sounds like we do need the behavior
