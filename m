Return-Path: <linux-kernel-owner+w=401wt.eu-S1757536AbYC0H50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536AbYC0H50 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 03:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755233AbYC0H5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 03:57:18 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:55989 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232AbYC0H5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 03:57:17 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47EB5345.6080506@s5r6.in-berlin.de>
Date: Thu, 27 Mar 2008 08:56:53 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Jarod Wilson <jwilson@redhat.com>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: fw-ohci: plug dma memory leak in AR handler
References: <200803251647.16227.jwilson@redhat.com> <47E9F6BB.4010601@s5r6.in-berlin.de> <tkrat.82d28d7bc55f2a9b@s5r6.in-berlin.de>
In-Reply-To: <tkrat.82d28d7bc55f2a9b@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> I wrote:
>> On the other hand, why do we free a page + allocate a page?
>> Why don't we re-initialize and re-add the old page?
> 
> Meanwhile I tried a simple modification to ar_context_add_page and its
> callers which results in _add_page simply re-adding the old page. I must
> do something fundamentally wrong though.

Besides, the current code which reassembles packets that reach into the 
next buffer is broken for packets whose total size approaches PAGE_SIZE. 
(Remember, async packets can be sized 4kB + 1394 headers + OHCI 
trailer.)  Reminds me of ohci1394 somehow.  :-(

I will attempt to fix this for post 2.6.25, unless you aspire to do so.
-- 
Stefan Richter
-=====-==--- --== ==-==
http://arcgraph.de/sr/
