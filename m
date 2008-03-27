Return-Path: <linux-kernel-owner+w=401wt.eu-S1756187AbYC0A0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbYC0A0z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 20:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752489AbYC0A0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 20:26:45 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:34371 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797AbYC0A0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 20:26:45 -0400
Subject: Re: Trying to make use of hotplug memory for xen balloon driver
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <47EAD83A.2000000@goop.org>
References: <47EAD83A.2000000@goop.org>
Content-Type: text/plain
Date: Wed, 26 Mar 2008 17:26:35 -0700
Message-Id: <1206577595.7883.26.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-03-26 at 16:11 -0700, Jeremy Fitzhardinge wrote:
>       Bad page state in process 'events/0'
>       page:c16fa0cc flags:0x00000000 mapping:00000000 mapcount:1 count:0
>       Trying to fix it up, but a reboot is needed

The flags being all null looks highly suspicious to me.

Once you've done an add_memory(), the new sections should show up
in /sys.  Do you see them in there?

Once they show up, you can online them with:

	echo online > /sys/devices/system/memory/memoryXXX/state

That's what actually goes and mucks with the 'struct zone's and the
pgdats to expand them.  It will also call online_page() on the whole
range.  I think you're trying to do this manually, and missing part of
it.  

There's some documentation here:

http://kerneltrap.org/node/14009

But, think of it this way: "add" is what the hardware does.  "online" is
what Linux does after the memory has been added so that it can be used.

-- Dave

