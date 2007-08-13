Return-Path: <linux-kernel-owner+w=401wt.eu-S948119AbXHMQTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S948119AbXHMQTs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S947890AbXHMPDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 11:03:07 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:59179 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S946791AbXHMPCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 11:02:45 -0400
Message-ID: <46C07293.5090405@s5r6.in-berlin.de>
Date: Mon, 13 Aug 2007 17:02:43 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4
MIME-Version: 1.0
To: sk malik <srikrishanmalik@yahoo.co.in>
CC: linux-kernel@vger.kernel.org
Subject: Re: why use memcpy when memmove is there?
References: <977159.24669.qm@web7606.mail.in.yahoo.com>
In-Reply-To: <977159.24669.qm@web7606.mail.in.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sk malik wrote:
> memcpy copies a part of memory to some other location
> but It will not work for all cases of overlapping
> blocks.(if the start of destination block falls
> between the source block)
> 
> while memove copes with overlapping areas.
> 
> then why is memcpy present in the sources can't we
> simply do
> 
> "#define memcpy memmove" in include/linux/string.h
> 
> or am I missing something?

The restriction that memcpy is undefined for overlapping areas (IOW, is
only defined for non-overlapping areas) can be used for optimizations in
memcpy which are not possible in memmove.  An example, I suppose:
http://lxr.linux.no/source/arch/m68k/lib/string.c#L79
http://lxr.linux.no/source/arch/m68k/lib/string.c#L146
-- 
Stefan Richter
-=====-=-=== =--- -==-=
http://arcgraph.de/sr/
