Return-Path: <linux-kernel-owner+w=401wt.eu-S1763049AbYAKXVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763049AbYAKXVy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 18:21:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761029AbYAKXVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 18:21:46 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:50712 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759573AbYAKXVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 18:21:45 -0500
Message-ID: <4787FA06.9090204@garzik.org>
Date: Fri, 11 Jan 2008 18:21:42 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: LIBATA SCSI command validation changed in 2.6.24
References: <4787DFE2.2000504@redhat.com> <4787E114.2030301@garzik.org> <4787E574.6020304@redhat.com>
In-Reply-To: <4787E574.6020304@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:
> On 01/11/2008 04:35 PM, Jeff Garzik wrote:
>> Chuck Ebbert wrote:
>>> commit 607126c2a21cd6e9bb807fdd415c1a992f7b9009 changed command
>>> validation
>>> to allow short commands in 16-byte CDBs, but it also made checking more
>>> strict. Before the change, a 10-byte SG_IO command could have its
>>> length set
>>> to 9 and still work. Now it fails. Not sure if this is a bug, but it has
>>> caused at least one application to fail that used to work (qpxtool.)
>>>
>>> [https://bugzilla.redhat.com/show_bug.cgi?id=428281]
>> Can you get us an example CDB?  Its unclear if the hexdump in the bug
>> report is a returned mode page or the CDB or what...?
>>
> 
> Not easily, but the maintainer of that program forced the length of
> the MODE_SENSE(10) command to 10 and that command started working.
> 
> By looking at the source I could tell that it was setting the command
> length to (1 + the index of the last byte written to the CDB) and
> only wrote up to offset 8 when building the command, so it must have
> been sending the command with a length of 9. (It zeroed the whole CDB
> first and only wrote what it needed to.)
> 
> (And it used the C++ operator [] to build the command, that was fun
> to trace...)

Even if allocation length is present in the CDB, the CDB may be missing 
important information that is required to process the command.  So it 
may have caught a bug in the program... depending on the CDB.

	Jeff


