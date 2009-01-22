Return-Path: <linux-kernel-owner+w=401wt.eu-S1755233AbZAVPm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbZAVPm6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 10:42:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752748AbZAVPmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 10:42:50 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:43311 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752616AbZAVPmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 10:42:50 -0500
Date: Thu, 22 Jan 2009 10:42:48 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>, <akpm@linux-foundation.org>,
       <mingo@elte.hu>, <richardj_moore@uk.ibm.com>,
       <naren@linux.vnet.ibm.com>
Subject: Re: [RFC Patch 0/9] Hardware Breakpoint interfaces - v4
In-Reply-To: <20090122135640.GA11161@in.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0901221032220.2417-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2009, K.Prasad wrote:

> Hi All,
> 	Please find the new set of patches that introduce kernel
> interfaces to use Hardware Breakpoint registers and an implementation
> for x86 (and x86_64) architecture, now labelled as Version IV.
> 
> The patches are based on 2.6.29-rc2 and have been tested to work fine on
> x86 architecture. Some of the major changes over the previous version of
> patches include:
> i) A sample kernel module that uses Data Hardware breakpoint over a
> kernel variable to monitor write operations. See
> samples/hw_breakpoint/data_breakpoint.c.
> ii) Changes in the register_kernel_hw_breakpoint() interface to accept
> only one parameter - pointer to a 'hw_breakpoint' structure which will
> contain all relevant data members.

I see some problems with this immediately.  Firstly, as a result of
this change the sample code in include/asm-generic/hw_breakpoint.h is
now incorrect.  You need to change the comments when you change the
code.

Second, your arch_store_info() routine is broken.  It checks for a
kernel symbol name even if when a userspace breakpoint is being
registered.  You should move that check up into validate_settings().

As a related matter, why did you put the "name" field into the
arch-dependent part?  Clearly it should be arch-independent.

Alan Stern

