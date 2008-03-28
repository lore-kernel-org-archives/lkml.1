Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554AbYC1OWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbYC1OWQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 10:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbYC1OWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 10:22:05 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55116 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129AbYC1OWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 10:22:04 -0400
Date: Fri, 28 Mar 2008 15:25:29 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pavel Machek <pavel@ucw.cz>, Andi Kleen <andi@firstfloor.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: agpgart: when telling user you'll corrupt his data, at least do it at KERN_CRIT
Message-ID: <20080328142529.GU29105@one.firstfloor.org>
References: <20080328112507.GA10774@elf.ucw.cz> <20080328113528.GA8077@elte.hu> <20080328134451.GB4544@ucw.cz> <20080328141348.GE29218@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080328141348.GE29218@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> yes that is the theory - but how did your disk get corrupted in 
> practice? ;-)

I suspect after wakeup due to the wrong ordering in resume (agp resume function
called too late).

The IOMMU code unfortunately doesn't know that the GART has gone away. 

The right fix for that is probably to move the GART resume code into
some shared file and make it a sysdev.

-Andi

