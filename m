Return-Path: <linux-kernel-owner+w=401wt.eu-S935477AbXGLQsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935477AbXGLQsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 12:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759174AbXGLQsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 12:48:15 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:37765 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752248AbXGLQsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 12:48:14 -0400
Date: Thu, 12 Jul 2007 12:48:14 -0400
To: "Ni@m" <niam.niam@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Fwd: NPTL
Message-ID: <20070712164813.GE31195@csclub.uwaterloo.ca>
References: <a9e22dff0707120518t77d440d3ue0368fd1f3e36c03@mail.gmail.com> <MDEHLPKNGKAHNMBLJOLKCEOCFDAC.davids@webmaster.com> <a9e22dff0707120537l1a29de93vdd67f146cf36a120@mail.gmail.com> <1184244078.20032.48.camel@twins> <a9e22dff0707120557t574f9383g5363c26074ea6d6a@mail.gmail.com> <a9e22dff0707120558k17ca1f86rb0044096d60c4dc1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9e22dff0707120558k17ca1f86rb0044096d60c4dc1@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2007 at 03:58:34PM +0300, Ni@m wrote:
> Of course .. I ment they are _almoust_ similar.

The lack of an address space seems to make them rather different too.  A
process contains address space, and one or more threads.  A thread is
hence a component of a process, but not really similar to a process
since it is just part of a process.

> Hm. If the thread is running after it's sister or parent process - you
> do not have to switich the process context. Is this done in kernel??

You are switching out cpu registers, stack, and such, even though you
are not changing address space, so you are doing a context switch.  The
cpu registers and state is the context.  Running multiple threads of a
single process in a row can avoid messing with the TLB and other address
space related things, but it still switches context.

--
Len Sorensen
