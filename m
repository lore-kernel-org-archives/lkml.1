Return-Path: <linux-kernel-owner+w=401wt.eu-S1755185AbYHOKYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185AbYHOKYh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 06:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752331AbYHOKY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 06:24:29 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:1945 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbYHOKY2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 06:24:28 -0400
Message-Id: <48A575B3.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Fri, 15 Aug 2008 11:25:23 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>,
       "Venkatesh Pallipadi" <venkatesh.pallipadi@intel.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, <hpa@zytor.com>
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>, <linux-kernel@vger.kernel.org>
Subject: Why can't _PAGE_PROTNONE be _PAGE_ACCESSED?
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the overlaying of _PAGE_PSE and _PAGE_PAT there is a latent issue
with the definition of _PAGE_PROTNONE: As soon as _PAGE_PAT gets
actively used, it'll need to become part of _PAGE_CHG_MASK, and hence
_PAGE_PROTNONE cannot use _PAGE_PSE anymore. One option certainly
is to use one of the two remaining unused (available) bits, but it would
seem to me that simply using _PAGE_ACCESSED here ought to work - but
perhaps I'm overlooking some critical aspect?

The background of this is that Xen's dom0 (and similarly DomU-s that have
physical devices assigned) cannot change the setting in PAT_MSR, and
hence has to live with being required to use _PAGE_PAT for establishing
WC mappings. That'll be a requirement for Dom0 and pv pass-through
support in the mainline tree (whenever that gets enabled) anyway, but
I'll have to do it eagerly in our forward-ported Xen tree, which is why I'm
trying to settle early on the route to take here.

Thanks, Jan

