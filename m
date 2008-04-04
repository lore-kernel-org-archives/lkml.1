Return-Path: <linux-kernel-owner+w=401wt.eu-S1757730AbYDDAvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757730AbYDDAvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 20:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753162AbYDDAvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 20:51:16 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:36994 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824AbYDDAvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 20:51:15 -0400
Subject: Re: [PATCH 5 of 6] hotplug-memory: add section_ops
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
In-Reply-To: <785fe0877fea0f488bc5.1207267545@localhost>
References: <785fe0877fea0f488bc5.1207267545@localhost>
Content-Type: text/plain
Date: Thu, 03 Apr 2008 17:51:12 -0700
Message-Id: <1207270272.943.27.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-04-03 at 17:05 -0700, Jeremy Fitzhardinge wrote:
> Add a per-section "section_ops" structure,  allowing each section to have
> specific functions for onlining and offlining pages within the section.
> This is used by the Xen balloon driver to make sure that pages are not
> onlined without some physical memory backing them.

This is kinda a lot of code and mucking around for what we actually get
out of it, especially since you just condensed down all the actual
online_page() instances.

I think it might just be nicer to have a global list of these handlers
somewhere.  The Xen driver can just say "put me on the list of
callbacks" and we'll call them at online_page().  I really don't think
we need to be passing an ops structure around.

KAME, did you have some other ideas about this?

-- Dave

