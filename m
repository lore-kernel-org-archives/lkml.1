Return-Path: <linux-kernel-owner+w=401wt.eu-S1758235AbXKCEDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235AbXKCEDU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 00:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbXKCEDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 00:03:13 -0400
Received: from rwcrmhc12.comcast.net ([204.127.192.82]:45617 "EHLO
	rwcrmhc12.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbXKCEDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 00:03:12 -0400
Subject: Re: [patch] PID namespace design bug, workaround
From: Nicholas Miell <nmiell@comcast.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Hansen <haveblue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, Ulrich Drepper <drepper@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Dinakar Guniguntala [imap]" <dino@in.ibm.com>,
       Sripathi Kodi <sripathik@in.ibm.com>
In-Reply-To: <alpine.LFD.0.999.0711021038480.3342@woody.linux-foundation.org>
References: <20071101144307.GA29566@elte.hu> <4729E7E4.8070208@openvz.org>
	 <4729E936.4040400@redhat.com> <4729EB3C.9050102@openvz.org>
	 <472A6D91.1020300@redhat.com> <472AD7D6.80900@openvz.org>
	 <20071102010419.23f3db5c.akpm@linux-foundation.org>
	 <1194024622.6271.108.camel@localhost>
	 <alpine.LFD.0.999.0711021038480.3342@woody.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 02 Nov 2007 21:02:59 -0700
Message-Id: <1194062579.3736.4.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7.0.njm.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-11-02 at 10:39 -0700, Linus Torvalds wrote:
> 
> On Fri, 2 Nov 2007, Dave Hansen wrote:
> > 
> > There are certainly more of these, but here is one In the futex
> > userspace address, we install the current pid's vnr into a userspace
> > address.  
> 
> Now, realistically, why not just say "you can't use these things across 
> namespaces"? Does anybody really care? After all, somebody who screws this 
> up only screws himself, not anybody else.
> 
> 		Linus

Accessing the same robust futex from different PID namespaces on the
same machine via a shared file mapping is logically equivalent to
accessing the same robust futex from different machines via a shared
filesystem and there's no reason to expect either operation to work
correctly.

-- 
Nicholas Miell <nmiell@comcast.net>

