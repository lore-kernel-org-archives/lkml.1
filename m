Return-Path: <linux-kernel-owner+w=401wt.eu-S1758737AbYEYTAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758737AbYEYTAH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 15:00:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756761AbYEYS7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 14:59:53 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44061 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755814AbYEYS7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 14:59:52 -0400
Date: Sun, 25 May 2008 11:59:36 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Marin Mitov <mitov@issp.bas.bg>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: pci_set_consistent_dma_mask() question
Message-ID: <20080525115936.7dbf2ecd@infradead.org>
In-Reply-To: <200805250843.47179.mitov@issp.bas.bg>
References: <200805250843.47179.mitov@issp.bas.bg>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 May 2008 08:43:47 +0300
Marin Mitov <mitov@issp.bas.bg> wrote:

> Hi all,
> 
> In the file: Documentation/DMA-mapping.txt is written:
> 
> pci_set_consistent_dma_mask() will always be able to set the same or a
> smaller mask as pci_set_dma_mask(). However for the rare case that a
> device driver only uses consistent allocations, one would have to
> check the return value from pci_set_consistent_dma_mask().
> 
> grep-ing drivers/net/* shows that in many drivers 
> the return value of pci_set_consistent_dma_mask() is checked
> in the path where pci_set_dma_mask() was already successfull.
> Sure, this is during driver's initiallysation, so it is not time
> critical.
> 
> My question: Is it worth to remove the unnecessary checks?
> I could prepare patches if you find it worthfull.
> 

I think it would actually be harmful. Checking for errors even if they
shouldn't happen for things like this makes drivers better! If something
weird is going on it gets detected earlier... IN general, defensive
programming makes a lot of sense.
