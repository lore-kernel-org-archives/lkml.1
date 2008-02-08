Return-Path: <linux-kernel-owner+w=401wt.eu-S1762803AbYBHLhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762803AbYBHLhc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 06:37:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751609AbYBHLhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 06:37:16 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:38125 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbYBHLhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 06:37:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=DR/6LGHh4Hc9LiTmfNvL3nfWW69oM5X5t2udSf+RSSJVMEm3n+Nc7SIm7g75T0K4mN+qV2wzwomVS57NLWHUCaCOegvl7PyLb6NTX/HrvhhVlgB0Q0MT0HYiastRdEhr5WeRWaduUlmJfWum687j3EVAxXJZvKYOabFDo1CfyPk=
Message-ID: <84144f020802080337h5179210era890cf9b4e19c35@mail.gmail.com>
Date: Fri, 8 Feb 2008 13:37:11 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH 1/2] kmemcheck v3
Cc: "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Richard Knutsson" <ricknu-0@student.ltu.se>,
       "Christoph Lameter" <clameter@sgi.com>
In-Reply-To: <20080208115542.GD4745@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47AB79D4.2070605@gmail.com>
	 <20080208115542.GD4745@one.firstfloor.org>
X-Google-Sender-Auth: f1499a392d04179f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Feb 8, 2008 1:55 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Also i'm not sure how you handle initializedness of DMAed data
> (like network buffers). Wouldn't you need hooks into pci_dma_*
> for this?

If the DMA'd memory is allocated from the page allocator, we don't
need to worry about it just yet. In case it's from kmalloc() you can
pass __GFP_NOTRACK to annotate those call sites where the memory is
filled by DMA (memory that is read needs to be initialized by the
caller obviously). There was some discussion with Ingo of a
__GFP_DMAFILL annotation to tag those call sites instead of
__GFP_NOTRACK which would work the same way.
