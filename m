Return-Path: <linux-kernel-owner+w=401wt.eu-S1751392AbYBTKHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392AbYBTKHe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 05:07:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbYBTKH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 05:07:27 -0500
Received: from www.tglx.de ([62.245.132.106]:57706 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879AbYBTKH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 05:07:26 -0500
Date: Wed, 20 Feb 2008 11:07:02 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [2/5] Use 2000 offset for 32bit kernels
In-Reply-To: <alpine.LFD.1.00.0802162024220.7583@apollo.tec.linutronix.de>
Message-ID: <alpine.LFD.1.00.0802201049310.7583@apollo.tec.linutronix.de>
References: <20080209416.271135970@suse.de> <20080209151658.4A3AD1B41D1@basil.firstfloor.org> <alpine.LFD.1.00.0802162024220.7583@apollo.tec.linutronix.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Feb 2008, Thomas Gleixner wrote:
> On Sat, 9 Feb 2008, Andi Kleen wrote:
> > 
> > We know it is already after 2000.
> > 
> > This extends the effective lifetime of 32bit systems by 8 years:
> > from 2030 to 2038.

Could you please explain what magic math does the 2030 -> 2038
extension ?

According to the code the 1970 comparison works until 2069:

	year += 1900;
	if (year < 1970)
		year += 100;

I keep the patch nevertheless as it removes ifdeffery, but I change
the commit log to something sensible and remove the year < 1970 check
as well as it is not longer necessary.

Thanks,

	tglx
