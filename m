Return-Path: <linux-kernel-owner+w=401wt.eu-S1758104AbYHTXXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104AbYHTXXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 19:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755115AbYHTXXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 19:23:10 -0400
Received: from gw.goop.org ([64.81.55.164]:36469 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755034AbYHTXXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 19:23:09 -0400
Message-ID: <48ACA75A.9070306@goop.org>
Date: Wed, 20 Aug 2008 16:23:06 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: "Alex Nixon (Intern)" <Alex.Nixon@citrix.com>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] X86: Change the default value of nr_irqs from 32 to NR_IRQs
References: <48AAFAE4.7070409@citrix.com> <86802c440808191044h74871ba1u62330dae18599436@mail.gmail.com> <0E902970173AF84089673FA54B7FE78A2CA11D@lonpexch01.citrite.net>
In-Reply-To: <0E902970173AF84089673FA54B7FE78A2CA11D@lonpexch01.citrite.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Nixon (Intern) wrote:
> I'm not sure about the general case, but Xen does not (Jeremy correct
> me if I'm wrong).
>

No, no apics of any kind in the PV domU case.

> Unless I'm missing something (which I may well be; I'm new to this
> area of code), it seems more logical anyway to default back to the
> calculated system-specific value (NR_IRQS), instead of 32, which seems
> rather arbitrary.
>

I think the patch looks fine for now.  But now that we seem to have
unified the use of vectors (I haven't looked at the current code closely
yet), I'd like to move Xen to mapping event channels -> vectors rather
than IRQs, and have the per-cpu event channels share an irq.  That will
dramatically decrease the irq requirements for a PV domU (to 6 irqs +
devices, rather than 6/cpu + devices; a typical domain may only need 10
irqs overall).

    J

