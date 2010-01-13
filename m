Return-Path: <linux-kernel-owner+w=401wt.eu-S932108Ab0AML42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108Ab0AML42 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 06:56:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773Ab0AML41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 06:56:27 -0500
Received: from one.firstfloor.org ([213.235.205.2]:35887 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab0AML41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 06:56:27 -0500
Date: Wed, 13 Jan 2010 12:56:17 +0100
From: Andi Kleen <andi@firstfloor.org>
To: William Allen Simpson <william.allen.simpson@gmail.com>
Cc: Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       Eric Dumazet <eric.dumazet@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v4] tcp: harmonize tcp_vx_rcv header length assumptions
Message-ID: <20100113115617.GA24818@basil.fritz.box>
References: <4B49D001.4000302@gmail.com> <4B4DA4F4.6060007@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B4DA4F4.6060007@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 05:48:20AM -0500, William Allen Simpson wrote:
> Harmonize tcp_v4_rcv() and tcp_v6_rcv() -- better document tcp doff
> and header length assumptions.
>
> Reduces multiply/shifts, marginally improving speed.
>
> Removes redundant tcp header length checks before checksumming.

I wonder if this actually improves performance on x86. On x86 and several
other architecture there's a addressing mode which allows to scale 
numbers by small factors (like 4). So doing a *4 is very cheap.

That's likely cheaper than using another register for the scaled value,
especially on 32bit x86 which doesn't have many.

It's difficult to benchmark this code, but did you check that the code 
shrinks after applying this patch at least?

-andi
