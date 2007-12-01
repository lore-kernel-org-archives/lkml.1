Return-Path: <linux-kernel-owner+w=401wt.eu-S1753495AbXLAQtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495AbXLAQtx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 11:49:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbXLAQtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 11:49:39 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:59467 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbXLAQti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 11:49:38 -0500
Date: Sat, 1 Dec 2007 08:48:33 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Tomas Carnecky <tom@dbservice.com>
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org
Subject: Re: WARNING: smp_call_function_single() and
 smp_call_function_mask()
Message-ID: <20071201084833.63263489@laptopd505.fenrus.org>
In-Reply-To: <4752703B.10305@dbservice.com>
References: <4752703B.10305@dbservice.com>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 02 Dec 2007 09:43:39 +0100
Tomas Carnecky <tom@dbservice.com> wrote:

> WARNING: at arch/x86/kernel/smp_64.c:427 smp_call_function_single()
> WARNING: at arch/x86/kernel/smp_64.c:397 smp_call_function_mask()
> 
> dmesg and config attached.
> 
> I'm getting about three of each at boot. I'm running:
> commit e1cca7e8d484390169777b423a7fe46c7021fec1
> Date:   Thu Nov 29 16:25:29 2007 -0800
> which is the latest git as of yesterday plus a one (unrelated) debug
> statement patch in usb uhci.
> 
> There was a similar bug report after 2.6.23-rc8-mm was released.
> Though there seems to be a fundamental problem with how people use
> smp_call_function*() [1]. And this can just as well be another
> incarnation of it.
> 
> Is that easy enough to fix or do I need to bisect (it didn't happen in
> 2.6.24-rc3)?
> 

this appears to be a bug in the acpi code, to be exact in
processor_throttling.c file, function
acpi_processor_set_throttling_ptc(); it disables interrupts and then
appears to do a cross-cpu IPI to set the state. Well... we can't do
that due to deadlock reasons (you can't do IPI's with interrupts off or
you can get a very nice deadlock with the cpu that you IPI trying to
do the same thing to you).

