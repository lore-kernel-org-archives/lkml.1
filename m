Return-Path: <linux-kernel-owner+w=401wt.eu-S1753354AbXDMN4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbXDMN4a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 09:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754002AbXDMN4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 09:56:30 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:44718 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354AbXDMN43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 09:56:29 -0400
Message-ID: <461F8C15.3020002@bull.net>
Date: Fri, 13 Apr 2007 15:56:37 +0200
From: Jean-Pierre Dion <jean-pierre.dion@bull.net>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Pavel Emelianov <xemul@sw.ru>
Cc: Andrew Morton <akpm@osdl.org>, Paul Menage <menage@google.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       devel@openvz.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kirill Korotaev <dev@sw.ru>, Chandra Seetharaman <sekharan@us.ibm.com>,
       Cedric Le Goater <clg@fr.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Rohit Seth <rohitseth@goog.frec.bull.fr>
Subject: Re: [PATCH 2/8] Add container pointer on struct page
References: <461A3010.90403@sw.ru> <461A3483.10402@sw.ru>
In-Reply-To: <461A3483.10402@sw.ru>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 13/04/2007 15:58:57,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 13/04/2007 15:58:59,
	Serialize complete at 13/04/2007 15:58:59
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

I have been implied in the work for the
memory controller of res groups a few months ago.

I see that you propose to modify the struct
page to point to rss container struct.
This has made some debate because of the struct
page size increase, but this allows a quicker
scan to reclaim pages (I mean having per-container
lists of active/inactive pages).
We (here at Bull and others) proposed this implementation
for res groups and I am interested in knowing
if this has a chance of being accepted today (hope so).
I know this uses memory for internal management
and increases a lot the memory size used for
a large memory configuration, but in that case
we have lot of memory, so where is the issue ?
We tested this on a 28 GB server and it worked.
Also we can use larger page size to reduce
the overhead, and I believe this makes sense
on large servers with big memory.

So we balance between using more memory internally
and so getting faster access to pages for reclaim,
or do nothing. ;-)


jean-pierre


