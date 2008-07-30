Return-Path: <linux-kernel-owner+w=401wt.eu-S1759008AbYG3OA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759008AbYG3OA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 10:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbYG3OAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 10:00:49 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:30615 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbYG3OAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 10:00:49 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: 2.6.27-rc1 oops on boot -- cs423x? (Corrected subject)
Date: Wed, 30 Jul 2008 07:59:55 -0600
User-Agent: KMail/1.9.9
Cc: Pete Clements <clem@clem.clem-digital.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <200807292052.m6TKq1J3005288@clem.clem-digital.net> <200807292159.43226.bjorn.helgaas@hp.com> <48905B4B.9090203@keyaccess.nl>
In-Reply-To: <48905B4B.9090203@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807300759.55649.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 July 2008 6:15:07 am Rene Herman wrote:
> On 30-07-08 05:59, Bjorn Helgaas wrote:
> > PNP: fix formatting of dbg_pnp_show_resources() output
> >
> > From: Bjorn Helgaas <bjorn.helgaas@hp.com>
> >
> > Each resource should be printed on its own line, so start snprintf'ing
> > at the beginning of the buffer every time through the loop.
> >
> > Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
>
> Good WARN_ON() that...
>
> I was looking at why I hadn't seen this here even with the same hardware
> when I _did_ see it here. Most definitely did not back when I was paying
> attention -- although there seems to be little opportunity for that.
>
> Just for my own education; did something recent happen to bring this on
> or must this have been present always? Serious buglet it seems.

That function used to printk the resource piece-meal -- first the
resource type, then the value, then the flags, etc.  I made a late
change to snprintf everything into the buffer, then do a single
printk to keep everything atomic, and I didn't test it well enough.

Bjorn
