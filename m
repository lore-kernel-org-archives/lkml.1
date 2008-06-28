Return-Path: <linux-kernel-owner+w=401wt.eu-S1753322AbYF1FAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322AbYF1FAX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 01:00:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751200AbYF1FAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 01:00:07 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:39764 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbYF1FAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 01:00:05 -0400
To: Roland McGrath <roland@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Various x86 syscall mechanisms
From: Andi Kleen <andi@firstfloor.org>
References: <485C2875.2050204@goop.org>
	<20080627204954.166D0154077@magilla.localdomain>
Date: Sat, 28 Jun 2008 07:00:02 +0200
In-Reply-To: <20080627204954.166D0154077@magilla.localdomain> (Roland McGrath's message of "Fri, 20 Jun 2008 16:39:34 -0700 (PDT)")
Message-ID: <87vdzup31p.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 Jun 2008 04:52:44.0036 (UTC) FILETIME=[CD633440:01C8D8DA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath <roland@redhat.com> writes:
>
> I think it is clearest to talk separately about the "intended ABI", the
> "what actually works today", and the "why".  (Also note I was not the
> decision-maker in this, just picking up what I can see.)

You are correct.

> For the 32-bit ABI, what I believe was always the intent for what could be
> considered the proper ABI is "int 0x80" or "use the vDSO entry point".  If
> someone asked me what you could ever have expected to rely on for the
> future, I would say exactly that.  The use of the vDSO is explicitly
> intended to take the details of sysenter/syscall or other such new
> instructions out of the 32-bit ABI picture for what any proper application
> will expect from the kernel.

For SYSENTER the vDSO is even needed because it relies on a hardcoded 
return address.

> AMD's were the first x86_64 CPUs, and those always supported "syscall"
> from 32-bit tasks to 64-bit kernels.  (I don't know whether AMD CPUs now
> support "sysenter" from 32-bit tasks to 64-bit kernels, and if so which
> past AMD64 CPUs may not have supported that.  On today's kernel you could

K8 at least.

> It was long on my back-burner list to toss in the "syscall" version of the
> 32-bit vDSO for 32-bit kernels on hardware that supports "syscall".  But,

That would only make a difference on K6 (K7 supports SYSENTER), and also
K6/K7 SYSCALL was slightly different from the K8 version.

-Andi
