Return-Path: <linux-kernel-owner+w=401wt.eu-S1759369AbXGXFw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759369AbXGXFw5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 01:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbXGXFwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 01:52:49 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:43995 "EHLO
	asav08.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbXGXFwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 01:52:49 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AusRABsxpUZKhRO4Rmdsb2JhbACHNIgdAQEBIwYMAQ
From: Dmitry Torokhov <dtor@insightbb.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [RFC/RFT 1/5] Input: implement proper locking in input core
Date: Tue, 24 Jul 2007 01:52:45 -0400
User-Agent: KMail/1.9.3
Cc: linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
References: <20070724044520.913891976.dtor@insightbb.com> <20070724044858.192608314.dtor@insightbb.com> <46A58FBA.5010505@garzik.org>
In-Reply-To: <46A58FBA.5010505@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707240152.47006.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff, 

On Tuesday 24 July 2007 01:35, Jeff Garzik wrote:
> 
> spin_lock_irq() should generally be avoided.
> 
> In cases like the first case -- input_repeat_key() -- you are making 
> incorrect assumptions about the state of interrupts.  The other cases 
> are probably ok, but in general spin_lock_irq() has a long history of 
> being very fragile and quite often wrong.
> 
> Use spin_lock_irqsave() to be safe.  Definitely in input_repeat_key(), 
> but I strongly recommend removing spin_lock_irq() from all your patches 
> here.
>

Thasnk you for looking at the patches. Actually I went back and forth
between spin_lock_irq and spin_lock_irqsave.. I will change back to
irqsave version, it is indeed safer.

-- 
Dmitry
