Return-Path: <linux-kernel-owner+w=401wt.eu-S934272AbXHGNkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934272AbXHGNkX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 09:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762253AbXHGNkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 09:40:09 -0400
Received: from mailout04.sul.t-online.de ([194.25.134.18]:56527 "EHLO
	mailout04.sul.t-online.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760582AbXHGNkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 09:40:06 -0400
Message-ID: <46B86FC1.7050601@t-online.de>
Date: Tue, 07 Aug 2007 15:12:33 +0200
From: Bernd Schmidt <bernds_cb1@t-online.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070804)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Wu, Bryan" <Bryan.Wu@analog.com>
Subject: Re: [PATCH] NOMMU: Separate out VMAs
References: <46695F6D.5050600@t-online.de> <8772.1186149811@redhat.com>
In-Reply-To: <8772.1186149811@redhat.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ID: ZqsepOZdQe2lXR-aUzuApDNkZTBmuGdUVODznpsIbt3b7kvH2FOXEl
X-TOI-MSGID: 1c31eafc-4d29-42a6-8d99-32d33e1e8781
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> Here's a preview of my patch to give each process a separate list of VMAs
> under NOMMU mode, just as under MMU mode.  Could you have a look over it
> please?

I've managed to apply it to our Blackfin tree and started looking at it.

> Could you also see if you get a memory leak on the blackfin CPU?  I see a leak
> when I use this patch, but I'm not sure whether it's this patch, or whether
> it's something else in the arch that is suppressed without this patch.
> 
> As far as I can tell by page counting there shouldn't be a leak.

There is a leak:

root:~> while true; do
> cat /proc/buddyinfo
> sleep 1
> done
Node 0, zone      DMA     20      1      1      1      0      1      1
    1      0      0      0      1      2      0
Node 0, zone      DMA     32      1      1      0      0      0      1
    0      0      0      0      1      2      0
Node 0, zone      DMA     47      1      1      1      1      0      0
    1      1      1      1      0      2      0
Node 0, zone      DMA     62      1      1      0      1      1      1
    1      0      1      1      0      2      0
Node 0, zone      DMA     77      1      1      1      0      0      1
    0      0      1      1      0      2      0
Node 0, zone      DMA     92      1      1      0      0      1      0
    1      1      0      1      0      2      0
Node 0, zone      DMA    107      1      1      1      1      1      1
    1      0      0      1      0      2      0
Node 0, zone      DMA    122      1      1      0      1      0      1
    0      0      0      1      0      2      0
Node 0, zone      DMA    137      1      1      1      0      1      0
    1      1      1      0      0      2      0
... and so on.  It's a strange pattern of fragmentation, as if it keeps
allocating 8k pages and freeing one half of them.

Will play with this some more.  Thanks!


Bernd
