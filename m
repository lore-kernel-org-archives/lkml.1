Return-Path: <linux-kernel-owner+w=401wt.eu-S1758094AbYGROeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094AbYGROeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 10:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbYGROeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 10:34:07 -0400
Received: from gw.goop.org ([64.81.55.164]:55885 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976AbYGROeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 10:34:06 -0400
Message-ID: <4880A9D0.3060300@goop.org>
Date: Fri, 18 Jul 2008 07:33:52 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Current git fails to compile
References: <20080718075340.GC16453@linux.vnet.ibm.com> <20080718091441.GR6875@elte.hu> <20080718134126.GA30416@linux.vnet.ibm.com>
In-Reply-To: <20080718134126.GA30416@linux.vnet.ibm.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dhaval Giani wrote:
>     This patch also pulls the pmd preallocation and mop-up functions out
>     to be common, assuming that the compiler will generate no code for
>     them when PREALLOCTED_PMDS is 0.

Well, there's nothing particularly special in that code.  The only 
slightly complex requirement on the compiler is that it notice that a 
0-iteration for loop is a do-nothing, and that it eliminate the code.  
And that's not really a requirement, it's just nice to have.

The fact that your compiler is warning about an unused variable in an 
unused function suggests that it isn't doing this (I'm assuming your 
config has CONFIG_X86_PAE=n).  But there are no inline asms or other 
things which traditionally cause compilers to fall over.

So, I'm not really sure what to do about this.  Any chance of using a 
newer compiler?

    J
