Return-Path: <linux-kernel-owner+w=401wt.eu-S1752119AbXB1LBE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbXB1LBE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 06:01:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbXB1LBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 06:01:04 -0500
Received: from mail.screens.ru ([213.234.233.54]:37217 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752119AbXB1LBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 06:01:03 -0500
Date: Wed, 28 Feb 2007 14:00:48 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: vatsa@in.ibm.com, Aneesh Kumar <aneesh.kumar@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Pavel Machek <pavel@ucw.cz>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [RFC][PATCH 1/3] Freezer: Fix vfork problem
Message-ID: <20070228110048.GA263@tv-sign.ru>
References: <200702261139.59130.rjw@sisk.pl> <20070227215314.GA427@tv-sign.ru> <20070228012301.GH29179@in.ibm.com> <200702281157.28381.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702281157.28381.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28, Rafael J. Wysocki wrote:
>
> On Wednesday, 28 February 2007 02:23, Srivatsa Vaddagiri wrote:
> > On Wed, Feb 28, 2007 at 12:53:14AM +0300, Oleg Nesterov wrote:
> > > I think it is good. Srivatsa?
> > 
> > Maybe additional comments on why we don't skip vfork kernel tasks may be good. 
> 
> Which is because we don't want the kernel threads to be frozen in unexpected
> places, so we allow them to block freeze_processes() instead or to set
> PF_NOFREEZE?

... and because in fact it won't block freeze_processes(), ____call_usermodehelper
(the child) does a minimum before exec/exit, and it can't be frozen until it wakes
up the parent.

Oleg.

