Return-Path: <linux-kernel-owner+w=401wt.eu-S1762276AbYDSVXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762276AbYDSVXY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 17:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbYDSVXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 17:23:14 -0400
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:57735 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753125AbYDSVXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 17:23:14 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: At0FABr/CUhMROPA/2dsb2JhbACBYKht
Date: Sat, 19 Apr 2008 17:23:11 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, akpm@osdl.org, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] x86 NMI-safe INT3 and Page Fault (v5)
Message-ID: <20080419212311.GD1554@Krystal>
References: <20080417165839.GA25198@Krystal> <20080417165944.GB25198@Krystal> <20080417201410.GB31616@Krystal> <87od889m44.fsf@basil.nowhere.org> <20080418000634.GB5062@Krystal> <87ej93bdsg.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <87ej93bdsg.fsf@basil.nowhere.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:20:53 up 50 days, 17:31,  4 users,  load average: 0.19, 0.22,
	0.26
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (andi@firstfloor.org) wrote:
> Mathieu Desnoyers <compudj@krystal.dyndns.org> writes:
> >
> > It uses RCU-style updates and has been designed to be lockless from the
> > ground up.
> 
> RCU is not necessarily NMI safe. In most cases RCU needs writer locks
> which you cannot do with NMIs.
> 
> -Andi
> 

RCU-style updates are done outside of NMIs, in sleepable context. That's
just required when the probes connected on markers must be
registered/unregistered.

The NMI context is the RCU read side. It only have to get the probe
function pointers to call along with the private data pointers.

Mathieu


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
