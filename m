Return-Path: <linux-kernel-owner+w=401wt.eu-S1757399AbZCRDGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399AbZCRDGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 23:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754937AbZCRDGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 23:06:09 -0400
Received: from n12.bullet.mail.mud.yahoo.com ([209.191.125.209]:39674 "HELO
	n12.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751557AbZCRDGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 23:06:07 -0400
X-Yahoo-Newman-Id: 447339.33223.bm@omp409.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=uHOemS0+O1n32/w3rp7ZjdvK4PYr75fABNAZn7vDlw2/iF8L2YP49ZEUJKPeBbqNHP3C1POLNd3NXFa+glALFdBQcBDhp71dRI2mxFlJzNEAe9pk8PO0Tow+Af44PIWoeVXyXMSQDCZdBRCfpJ9Zqn60eOBrVHi7yCHvyjIHub4=  ;
X-YMail-OSG: pq0QPWYVM1mqHsWpjw.JedLq.c9fufkGkxQsQxLKKggph5._NXd4kN5SqO21kZDdfyZ7xzUuTZJEoHsyqx3XV3PoPMRtnRFYRspX7kqm5gpvgGX7EG1MD.8A5zCq4EBdgWxpkuIkQgI5FRd8zSDOpDL5
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: lockdep and threaded IRQs (was: ...)
Date: Tue, 17 Mar 2009 18:04:39 -0700
User-Agent: KMail/1.9.10
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>, me@felipebalbi.com,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, dmitry.torokhov@gmail.com, sameo@openedhand.com,
       tglx@linutronix.de
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <20090303103041.0ba4aebd@lxorguk.ukuu.org.uk> <20090303104836.GA11532@elte.hu>
In-Reply-To: <20090303104836.GA11532@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903171804.39557.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 March 2009, Ingo Molnar wrote:
> i think you severely over-estimate the importance and ratio of 
> drivers that enable irqs within irq handlers. (Nor does anyone 
> want to break them really - we want to have a sane default and 
> we want to flag the broken cases as broken.)

For the record, I've been running for some time now
with a patch that issues a warning for each IRQ that
lockdep forces to use IRQF_DISABLED.

On my x86 systems, pretty much every driver triggers
that warning.  Which makes me think maybe that shoe
is being placed on the wrong foot:  use of IRQF_DISABLED
is the *EXCEPTION* not the rule.  At least on one major
Linux platform...


