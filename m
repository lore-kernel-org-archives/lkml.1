Return-Path: <linux-kernel-owner+w=401wt.eu-S1754711AbZAFR4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbZAFR4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 12:56:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751456AbZAFR4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 12:56:45 -0500
Received: from mailin.zeus.com ([212.44.21.7]:58581 "EHLO mailin.zeus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbZAFR4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 12:56:44 -0500
X-Greylist: delayed 850 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Jan 2009 12:56:44 EST
Message-ID: <49639807.1040803@zeus.com>
Date: Tue, 06 Jan 2009 17:42:31 +0000
From: Ben Mansell <ben@zeus.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: Data corruption issue with splice() on 2.6.27.10
References: <20081224152841.GB13113@1wt.eu>
In-Reply-To: <20081224152841.GB13113@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Jan 2009 17:42:31.0984 (UTC) FILETIME=[26DCC300:01C97026]
X-TM-AS-Product-Ver: SMEX-7.0.0.1584-5.5.1027-16386.000
X-TM-AS-Result: No--12.759200-0.000000-31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> I'm facing a data corruption problem with splice() between two
> non-blocking TCP sockets on 2.6.27.10. I could finally write a
> simpler proof of concept, and capture a snapshot of the issue
> with the associated strace result.
> 
> My program does the following :
>   - accept an incoming connection
>   - connect to a remote server
>   - forward all data from the server to the client using splice()
> 
> The data count is always correct, but some parts are corrupted and
> contain data which seem to come from random memory locations (this
> raises a security concern BTW). It *sometimes* happens that a few
> megabytes can be transferred without any problem, but most of the
> time, corruption happens for a few hundreds of bytes every few
> hundreds of kilobytes.

FWIW, I can easily reproduce this on a Linux 2.6.27-9 (Ubuntu kernel), 
using both forcedeth and tg3 network drivers. It's reassuring to hear of 
this network corruption as I have been puzzling over non-blocking 
splice() code recently!

The corruption does seem to be confined to the user data on the 
connections, as I have been able to run some benchmarks using my own 
splice()-enabled HTTP proxy to transfer lots of data. All the TCP 
connections 'work' fine (as in no broken TCP), the initial HTTP request 
& response headers get through OK, but the body data of the responses 
sometimes gets corrupted. The benchmark seems to work flawlessly until 
you look at the web page data!

I'm happy to run any test code on systems here or provide any debug 
information if it would help to track this down.


Ben
