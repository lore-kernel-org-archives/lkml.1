Return-Path: <linux-kernel-owner+w=401wt.eu-S1756676AbYCMUyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676AbYCMUyR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 16:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753112AbYCMUyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 16:54:06 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:43699 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753654AbYCMUyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 16:54:05 -0400
Date: Thu, 13 Mar 2008 21:54:27 +0100
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: David Brownell <david-b@pacbell.net>
Cc: kernel@avr32linux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/10] atmel_serial: Fix build on avr32 with CONFIG_PM
 enabled
Message-ID: <20080313215427.0d1a86fc@siona.local>
In-Reply-To: <200803131337.41337.david-b@pacbell.net>
References: <1205419185-26395-2-git-send-email-hskinnemoen@atmel.com>
	<1205419185-26395-3-git-send-email-hskinnemoen@atmel.com>
	<200803131337.41337.david-b@pacbell.net>
Organization: Atmel
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Mar 2008 20:53:45.0888 (UTC) FILETIME=[54545200:01C8854C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008 12:37:40 -0800
David Brownell <david-b@pacbell.net> wrote:

> On Thursday 13 March 2008, Haavard Skinnemoen wrote:
> > AVR32 doesn't have at91_suspend_entering_slow_clock(). Just assume the
> > clock will keep running for now.  
> 
> Well, it should acquire the clk_must_disable() or somesuch... :)

Indeed. But that interface doesn't exist yet...

> By the way, I noticed a goof in this driver's clock management.
> It should leave the clock off whenever the device isn't open.
> As it is, it wastes power both at runtime and during suspend.

Right. I suspect you'll find a similar goofs in lots of drivers if you
go looking. I intend to go through all the drivers I care about and see
if I can tighten up the clock management a bit. There are probably a
few missing or half-assed suspend/resume implementations around too.

Haavard
