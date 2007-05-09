Return-Path: <linux-kernel-owner+w=401wt.eu-S1759947AbXEIX1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759947AbXEIX1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 19:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756968AbXEIX1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 19:27:13 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:61377 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756962AbXEIX1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 19:27:11 -0400
Date: Wed, 09 May 2007 17:27:05 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] Cleanup libata HPA support
In-reply-to: <1178692170.6962.146.camel@cunning>
To: Ben Collins <ben.collins@ubuntu.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <464258C9.7040405@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.7iNoP7Qs8RAGjCdw2nQZBKOCxZU@ifi.uio.no>
 <46408D43.3020300@shaw.ca> <1178692170.6962.146.camel@cunning>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Collins wrote:
> On Tue, 2007-05-08 at 08:46 -0600, Robert Hancock wrote:
>> Ben Collins wrote:
>>> The original HPA patch that Kyle worked on has gone into current git
>>> without some fixes that we worked through late in the Ubuntu feisty
>>> release. Here's the main copy of the notes I sent to Alan a few weeks
>>> ago in regards to the original patch, and a repatch against current git
>>> to fix things up. Note we have released feisty with the patch attached
>>> (albeit we have HPA enabled by default), and we have not had any reports
>>> directly attributed to it. However, in gutsy (devel for next release,
>>> based on current stock linux-2.6.git), we are already seeing reports of
>>> the same issues we already fixed. 
>>>
>>> The issues we saw were mainly that some controllers didn't return the
>>> correct size from the SET_MAX command (sata_nv is a good example). So I
>>> added a re IDENTIFY after the SET_MAX, and compared all the numbers. If
>>> re-id was correct, but return value from SET_MAX wasn't we print a
>>> warning and use the IDENTIFY value regardless (since that's what the
>>> device is going to use).
>>>
>>> Because we re IDENTIFY, there was also no need to keep n_sectors_boot
>>> around, so that was removed. The ata_hpa_resize() was changed to handle
>>> everything in a single call (checks for HPA support of the device, and
>>> whether ignore_hpa is set or not), and it also sets dev->n_sectors
>>> before returning.
>>>
>>> So far with this patch, we were able to fix all the problems we were
>>> seeing with it (except the sata_nv issue where we had to revert to not
>>> using adma for NO_DATA transactions, already reported to libata-dev).
>>> We've not had any reports of further problems.
>> That sata_nv issue should not be present anymore in the current 
>> libata-dev tree.
> 
> That's correct, it is not, at least the machine exception problem isn't.
> However, the incorrect returns from SET_MAX are still an issue with that
> hw. No idea what is causing it.

Curious.. Do you have some output or other details from what was 
actually returned? Also was this on more than one drive model?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

