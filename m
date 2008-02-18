Return-Path: <linux-kernel-owner+w=401wt.eu-S1756366AbYBRMtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366AbYBRMtP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 07:49:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750981AbYBRMs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 07:48:57 -0500
Received: from mexforward.lss.emc.com ([128.222.32.20]:59764 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbYBRMs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 07:48:56 -0500
Message-ID: <47B97E87.6040209@emc.com>
Date: Mon, 18 Feb 2008 07:48:07 -0500
From: Ric Wheeler <ric@emc.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: device-mapper development <dm-devel@redhat.com>,
       Michael Tokarev <mjt@tls.msk.ru>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] Re: [PATCH] Implement barrier support for single device
 DM devices
References: <20080215120821.GA8267@basil.nowhere.org> <20080215122002.GM29914@agk.fab.redhat.com> <47B58EAA.8040405@msgid.tls.msk.ru> <20080215142010.GA29552@one.firstfloor.org> <20080215141229.GB1788@agk.fab.redhat.com>
In-Reply-To: <20080215141229.GB1788@agk.fab.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Version: 4.7.1.128075, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2007.8.30.51425
X-PerlMx-Spam: Gauge=, SPAM=1%, Reason='EMC_FROM_0+ -3, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __USER_AGENT 0'
X-Tablus-Inspected: yes
X-Tablus-Classifications: public
X-Tablus-Action: allow
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alasdair G Kergon wrote:
> On Fri, Feb 15, 2008 at 03:20:10PM +0100, Andi Kleen wrote:
>> On Fri, Feb 15, 2008 at 04:07:54PM +0300, Michael Tokarev wrote:
>>> I wonder if it's worth the effort to try to implement this.
> 
> My personal view (which seems to be in the minority) is that it's a
> waste of our development time *except* in the (rare?) cases similar to
> the ones Andi is talking about.

Using working barriers is important for normal users when you really 
care about data loss and have normal drives in a box. We do power fail 
testing on boxes (with reiserfs and ext3) and can definitely see a lot 
of file system corruption eliminated over power failures when barriers 
are enabled properly.

It is not unreasonable for some machines to disable barriers to get a 
performance boost, but I would not do that when you are storing things 
you really need back.

Of course, you don't need barriers when you either disable the write 
cache on the drives or use a battery backed RAID array which gives you a 
write cache that will survive power outages...

ric
