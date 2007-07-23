Return-Path: <linux-kernel-owner+w=401wt.eu-S1757143AbXGWP0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143AbXGWP0K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 11:26:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755579AbXGWPZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 11:25:45 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:50141 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755157AbXGWPZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 11:25:44 -0400
Date: Mon, 23 Jul 2007 11:25:42 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andi Kleen <ak@suse.de>
Cc: jbeulich@novell.com, jeremy@goop.org, zach@vmware.com, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [2/11] x86: Fix alternatives and kprobes to remap write-protected kernel text
Message-ID: <20070723152542.GA13457@Krystal>
References: <20070720532.949522000@suse.de> <20070720153246.6597614E79@wotan.suse.de> <20070723144603.GA11854@Krystal> <200707231701.28529.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <200707231701.28529.ak@suse.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:08:49 up 6 days,  9:42,  4 users,  load average: 0.32, 0.58, 0.85
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (ak@suse.de) wrote:
> On Monday 23 July 2007 16:46:03 Mathieu Desnoyers wrote:
> 
> > I would recommend to prefix with __init every function that is assumed
> > "safe" because executed at boot time. It would minimize the risks of
> > buggy usage of these text-modification primitives. That includes
> > text_poke() and a big chunk of the apply alternative code. (it should
> > never be executed on a live system, except at boot time, right ?)
> 
> lock prefix patching can happen later on cpu hotplug/unplug event.
> 

There seem to be a separate set of functions for applying smp lock
prefixes and more "general" alternatives. I guess the "general"
alternatives and paravirt could be declared __init, and text_poke users
would have to use it responsibly. Such as:

__init apply_alternatives
__init apply_paravirt

non init:
alternatives_smp_*
alternatives_smp_

Mathieu

> -Andi
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
