Return-Path: <linux-kernel-owner+w=401wt.eu-S1752637AbXJ1INv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbXJ1INv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 04:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750795AbXJ1INh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 04:13:37 -0400
Received: from mailgw.cvut.cz ([147.32.3.235]:59115 "EHLO mailgw.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbXJ1INf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 04:13:35 -0400
X-Greylist: delayed 1645 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Oct 2007 04:13:35 EDT
Message-ID: <47243E3F.9060307@vc.cvut.cz>
Date: Sun, 28 Oct 2007 00:46:07 -0700
From: Petr Vandrovec <vandrove@vc.cvut.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.6) Gecko/20070802 Iceape/1.1.4 (Debian-1.1.4-1)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Steve French <smfrench@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>, sfrench@samba.org,
       jaharkes@cs.cmu.edu, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Networked filesystems vs backing_dev_info
References: <1193477666.5648.61.camel@lappy>	 <524f69650710271402g65a9ec1cqcc7bc3a964097e39@mail.gmail.com>	 <1193520625.27652.30.camel@twins> <1193521041.27652.37.camel@twins>
In-Reply-To: <1193521041.27652.37.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Sat, 2007-10-27 at 23:30 +0200, Peter Zijlstra wrote:
>> So in short, stick a struct backing_dev_info into whatever represents a
>> client, initialize it using bdi_init(), destroy using bdi_destroy().
> 
> Oh, and the most important point, make your fresh I_NEW inodes point to
> this bdi struct.
> 
>> Mark it congested once you have 50 (or more) outstanding requests, clear
>> congestion when you drop below 50.
>> and you should be set.

Thanks.  Unfortunately I do not think that NCPFS will switch to 
backing_dev_info - it uses pagecache only for symlinks and directories, 
and even if it would use pagecache, as most of servers refuse concurrent 
requests even if TCP is used as a transport, there can be only one 
request in flight...

						Petr

P.S.:  And if anyone wants to step in as ncpfs maintainer, feel free.  I 
did not see NetWare server for over year now...

