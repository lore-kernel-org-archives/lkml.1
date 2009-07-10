Return-Path: <linux-kernel-owner+w=401wt.eu-S1754719AbZGJPHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbZGJPHd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 11:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbZGJPH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 11:07:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39917 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbZGJPHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 11:07:25 -0400
Message-ID: <4A575921.9030501@zytor.com>
Date: Fri, 10 Jul 2009 08:07:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: "John A. Gregor" <john.gregor@qlogic.com>, ralph.campbell@qlogic.com,
       linux-kernel@vger.kernel.org, johng@diamond.mv.qlogic.com,
       Hongjiu.lu@intel.com
Subject: Re: [PATCH] x86_64/__iowrite32_copy: don't use string move for PIO
 writes
References: <1246907224-22758-1-git-send-email-john.gregor@qlogic.com> <4A526CE6.30200@zytor.com> <4a526e77.IPiyTZWRWfll2+00%john.gregor@qlogic.com> <4A527EE4.1080102@zytor.com> <20090709231957.GC1469@ucw.cz>
In-Reply-To: <20090709231957.GC1469@ucw.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
>> - the current code is fine as long as it doesn't cross from cached to
>>   uncached memory, which it never should in any kind of sensible driver;
> 
> Should we add a comment somewhere saying that is not permitted (and why)?

It sounds like what we should do is simply remove
arch/x86/lib/iomap_copy_64.S, and probably add a comment to
lib/iomap_copy.c stating that rep string instructions have been reported
to cause anomalies when accessing WC memory, and that we rely on gcc not
generating them due thanks to the volatiles in the implementation of
__raw_writel().  H.J. Lu tells me that gcc will not generate string
instructions for volatiles, and that the x86 gcc team considers that
part of the definition for volatile.  (HJL: please correct if I got that
incorrect.)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

