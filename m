Return-Path: <linux-kernel-owner+w=401wt.eu-S1755907AbZCEVdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbZCEVdf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 16:33:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754207AbZCEVdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 16:33:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:38671 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754165AbZCEVdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 16:33:25 -0500
Subject: Re: [x86-tip] overflow in relocation type 11 val 39ffdd0e8690
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <tj@kernel.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>
In-Reply-To: <20090305212535.GA13848@elte.hu>
References: <1236287654.3677.3.camel@localhost.localdomain>
	 <20090305212535.GA13848@elte.hu>
Content-Type: text/plain
Date: Fri, 06 Mar 2009 03:03:00 +0530
Message-Id: <1236288780.3677.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-05 at 22:25 +0100, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > On latest tip I am getting:
> > 
> > [  124.169475] overflow in relocation type 11 val 39ffdd0e8690
> > [  124.169508] `msr_debug' likely not compiled with -mcmodel=kernel
> > [  146.582299] overflow in relocation type 11 val 39ffdd0e8690
> > [  146.582299] `msr_debug' likely not compiled with -mcmodel=kernel
> > [  836.653168] overflow in relocation type 11 val 39ffdd0e8690
> > [  836.653201] `msr_debug' likely not compiled with -mcmodel=kernel
> > 
> > But 1d10914bf2c8 was working fine.

No it is also not fine :( for percpu.

> 
> That's a linker bug - Tejun Cc:-ed.
> 

Problem is basically with 64 bit percpu on 32 bit it is OK. Ahh, Here is
the solution:

http://lkml.org/lkml/2009/3/3/129

because of commit 8ac83757149 of Tejun Heo.

Thanks
--
JSR



