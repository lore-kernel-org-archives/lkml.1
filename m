Return-Path: <linux-kernel-owner+w=401wt.eu-S1758047AbZAHFwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047AbZAHFwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 00:52:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751756AbZAHFwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 00:52:22 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59344 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbZAHFwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 00:52:21 -0500
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Om <om.turyx@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 64 bit PCI access using MMX register -- how?
From: Andi Kleen <andi@firstfloor.org>
References: <496534BC.4060603@gmail.com>
	<20090107233929.60ef8d98@lxorguk.ukuu.org.uk>
Date: Thu, 08 Jan 2009 06:52:30 +0100
In-Reply-To: <20090107233929.60ef8d98@lxorguk.ukuu.org.uk> (Alan Cox's message of "Wed, 7 Jan 2009 23:39:29 +0000")
Message-ID: <8763kqxs2p.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

> One other problem: the kernel doesn't save the FPU state on context
> switches or IRQ entry (takes far too long) so that will make a nasty mess.


I think he was ok because he saved the MMX state by itself, except:

- There was no guarantee that the FPU is in MMX state, not x87 state
- He'll often get a lazy fpu save exception. This used to BUG() 
in some cases when invoked from kernel space (but that might have been
changed now). Better is to disable this explicitely around 
the access (like in kernel_fpu_begin()/end())
- Doing this all properly is fairly expensive and I suspect
just using a lock will be cheaper.

-Andi


-- 
ak@linux.intel.com
