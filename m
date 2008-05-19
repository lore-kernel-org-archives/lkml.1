Return-Path: <linux-kernel-owner+w=401wt.eu-S1756444AbYESGeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444AbYESGeB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 02:34:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754774AbYESGdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 02:33:33 -0400
Received: from mo10.iij4u.or.jp ([210.138.174.78]:53203 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbYESGd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 02:33:28 -0400
Date: Mon, 19 May 2008 15:32:10 +0900
To: andi@firstfloor.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, muli@il.ibm.com, alexisb@us.ibm.com
Subject: Re: [PATCH 0/2] x86: per-device dma_mapping_ops
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <482D1A91.3050803@firstfloor.org>
References: <482C14E4.9050201@firstfloor.org>
	<20080516124446B.tomof@acm.org>
	<482D1A91.3050803@firstfloor.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080519142352J.tomof@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2008 07:24:33 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> FUJITA Tomonori wrote:
> > On Thu, 15 May 2008 12:48:04 +0200
> > Andi Kleen <andi@firstfloor.org> wrote:
> > 
> >>> I thought that KVM people want to do it per device (in the first
> >>> case). So with my patchse, they can replace the dma_ops pointer in
> >>> dev_archdata with what they want.
> >> But where would they save the original pointer?
> > 
> > Yeah, we need an extra mechanism for that but it's same for the
> > system-wide dma_ops pointer (i.e. without my patches), isn't it?
> > 
> > I'm still not sure how this patchset make it impossible to have stack
> > dma_ops. These people need per-device dma_ops and we can do stack
> > per-device dma_ops?
> 
> Anybody who does stack ops in your scheme would need to hook into new
> device creation and an own per device saving pointer. Also there
> are livetime issues when to wrap.

But is that what those people want, setting up dma_ops per device?

I think that creating a hook is not difficult and we could put a
mechnism to save a pointer in asm-x86/{dma-mapping.h, device.h}.

 
> It's certainly possible, but likely complicated

Hmm, let's see what those people think about on this. I'll repost a
patchset for -mm with CC'ing those people.
