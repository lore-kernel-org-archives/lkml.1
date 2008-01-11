Return-Path: <linux-kernel-owner+w=401wt.eu-S1762858AbYAKVyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762858AbYAKVyU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 16:54:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761372AbYAKVyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 16:54:05 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760884AbYAKVyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 16:54:04 -0500
Message-ID: <4787E574.6020304@redhat.com>
Date: Fri, 11 Jan 2008 16:53:56 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: LIBATA SCSI command validation changed in 2.6.24
References: <4787DFE2.2000504@redhat.com> <4787E114.2030301@garzik.org>
In-Reply-To: <4787E114.2030301@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2008 04:35 PM, Jeff Garzik wrote:
> Chuck Ebbert wrote:
>> commit 607126c2a21cd6e9bb807fdd415c1a992f7b9009 changed command
>> validation
>> to allow short commands in 16-byte CDBs, but it also made checking more
>> strict. Before the change, a 10-byte SG_IO command could have its
>> length set
>> to 9 and still work. Now it fails. Not sure if this is a bug, but it has
>> caused at least one application to fail that used to work (qpxtool.)
>>
>> [https://bugzilla.redhat.com/show_bug.cgi?id=428281]
> 
> Can you get us an example CDB?  Its unclear if the hexdump in the bug
> report is a returned mode page or the CDB or what...?
> 

Not easily, but the maintainer of that program forced the length of
the MODE_SENSE(10) command to 10 and that command started working.

By looking at the source I could tell that it was setting the command
length to (1 + the index of the last byte written to the CDB) and
only wrote up to offset 8 when building the command, so it must have
been sending the command with a length of 9. (It zeroed the whole CDB
first and only wrote what it needed to.)

(And it used the C++ operator [] to build the command, that was fun
to trace...)
