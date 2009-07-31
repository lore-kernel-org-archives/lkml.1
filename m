Return-Path: <linux-kernel-owner+w=401wt.eu-S1751897AbZGaPAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897AbZGaPAA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 11:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751541AbZGaO77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 10:59:59 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:40069 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbZGaO77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 10:59:59 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: Dynamic configure max_cstate
Date: Fri, 31 Jul 2009 09:56:33 -0500
User-Agent: KMail/1.9.9
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Robert Hancock <hancockrwd@gmail.com>,
       Corrado Zoccolo <czoccolo@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       venkatesh.pallipadi@intel.com
References: <20090727073338.GA12669@rhlx01.hs-esslingen.de> <20090731080728.GA25049@rhlx01.hs-esslingen.de> <87prbg3ohq.fsf@basil.nowhere.org>
In-Reply-To: <87prbg3ohq.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907310956.53816.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri July 31 2009, Andi Kleen wrote:
> Andreas Mohr <andi@lisas.de> writes:
> 
> > Instead we should strive for a far-reaching _generic_ mechanism
> > which gathers average latencies of various I/O activities/devices
> > and then uses some formula to determine the maximum (not necessarily ACPI)
> > idle latency that we're willing to endure (e.g. average device I/O reply latency
> > divided by 10 or so).
> 
> The interrupt heuristics in the menu cpuidle governour are already
> attempting this, based on interrupt rates (or rather
> wakeup rates) which are supposed to roughly correspond with IO rates
> and scheduling events together.
> 
> Apparently that doesn't work in this case. The challenge would
> be to find out why and improve the menu algorithm to deal with it.
> I doubt a completely new mechanism is needed or makes sense.
> 
> > And in addition to this, we should also take into account (read: skip)
> > any idle states which kill busmaster DMA completely
> > (in case of busmaster DMA I/O activities, that is)
> 
> This is already done.
> 

Almost - the VIA C7-M needs a bit of kernel command line help - -
But should be easily fixable when I or one of the VIA support people GATI.
(Bus snoops are only fully supported in C0 and C1 but idle=halt takes care of that.)

Mike
> -Andi


