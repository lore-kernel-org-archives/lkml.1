Return-Path: <linux-kernel-owner+w=401wt.eu-S1754176AbZGSDI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbZGSDI3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 23:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754146AbZGSDI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 23:08:26 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:26715 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144AbZGSDI0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 23:08:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=xOPbnST/o8lvAua5+g/2hBdzFbVveglQqqAotlgbsRmDrgAR+It8C+jzzeae/I/tzm
         ZnEW3DUqmUelkWcOLiv+jow/pZAk6AXz43ijdYUstCFBGTuMrveU6Hvp7ZrWfSFKdsDE
         YjNJkdTjZQYn0iHyhK98InfLQSZzaB5kvuKK8=
MIME-Version: 1.0
In-Reply-To: <1247873945.8334.67.camel@localhost.localdomain>
References: <1247873945.8334.67.camel@localhost.localdomain>
From: Chris Snook <chris.snook@gmail.com>
Date: Sat, 18 Jul 2009 23:00:55 -0400
Message-ID: <13a12eea0907182000v654e38a5l265ae5bdadb1a175@mail.gmail.com>
Subject: Re: [RFC][PATCH] Introduce CLOCK_REALTIME_COARSE
To: john stultz <johnstul@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@tglx.de>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       nikolag@ca.ibm.com, Darren Hart <dvhltc@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 17, 2009 at 7:39 PM, john stultz<johnstul@us.ibm.com> wrote:
> -       if (likely(gtod->sysctl_enabled && gtod->clock.vread))
> +       if (likely(gtod->sysctl_enabled))

This irks me.  If the sysctl is enabled and the codepath is getting
used often enough that we care about performance, branch prediction
should do the right thing without compiler hints.  On the other hand,
if the sysctl is disabled, and the compiler is telling the cpu to
ignore its branch predictor, it'll hurt.  I don't think we should be
wrapping (un)likely annotations around configuration options, unless
we're biasing against debug conditions where we definitely don't care
about performance.  The patch is certainly no worse than the existing
code, but while we have the hood up, it might be nice to remove the
annotation, unless we're sure that it does no harm, and does some
good.

-- Chris
