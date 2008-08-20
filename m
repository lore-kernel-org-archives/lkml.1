Return-Path: <linux-kernel-owner+w=401wt.eu-S1757944AbYHTXRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944AbYHTXRt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 19:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751718AbYHTXRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 19:17:39 -0400
Received: from relay03.mail-hub.dodo.com.au ([123.2.6.238]:45347 "EHLO
	relay03.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751491AbYHTXRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 19:17:39 -0400
From: Grant Coady <grant_lkml@dodo.com.au>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Grant Coady <gcoady.lk@gmail.com>, linux-kernel@vger.kernel.org,
       neilb@suse.de, bfields@fieldses.org, linux-nfs@vger.kernel.org
Subject: Re: NFS regression?  Odd delays and lockups accessing an NFS export.
Date: Thu, 21 Aug 2008 09:17:07 +1000
Organization: http://bugsplatter.id.au/
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Message-ID: <mi8pa4hi3809h8nbm332k7ifjvc3idnkja@4ax.com>
References: <p6lha4te54h04qdbnos1mcemdmn1cfca6s@4ax.com> <1219087258.7192.19.camel@localhost>
In-Reply-To: <1219087258.7192.19.camel@localhost>
X-Mailer: Forte Agent 2.0/32.652
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Aug 2008 15:20:58 -0400, Trond Myklebust <trond.myklebust@fys.uio.no> wrote:

>On Mon, 2008-08-18 at 12:02 +1000, Grant Coady wrote:
>> Hi there,
>> 
>> I've been using NFS here for years, lately there's something odd going on 
>> since about a month or so.  Previously reported last month:
>> http://www.gossamer-threads.com/lists/linux/kernel/951419?page=last
>> 
>> Now with 2.6.27-rc3 on one of the client boxes I get a complete stall 
>> at odd times when accessing the server's exported directory, cannot 
>> see a pattern to it.  Eventually recovers after a Ctrl-C.  Nothing in 
>> the server or client log files.  Not easy to reproduce either.
>> 
>> The server runs 2.6.26.2 at the moment.
>> 
>> Server config, etc: http://bugsplatter.id.au/kernel/boxen/deltree/
>> Client config, etc: http://bugsplatter.id.au/kernel/boxen/pooh/
>
>Please try to reproduce the hang, then do
>
>	echo 0 >/proc/sys/sunrpc/rpc_debug
>
>and send the output from 'dmesg'...

It's not NFS, I just had WinXP box stall completely (no KB NumLock 
response) on a PuTTY (ssh) terminal to a linux box running 2.6.26.3 
for about five or ten seconds, when it came back to operation the 
PuTYY toolbar icon was flashing.  Dunno which terminal as I had four 
open at the time, but they all to a server box running 2.6.26.3 with 
multiple Intel pro/100 (e100) NICs.

I think this may be to do with the e100 network driver instead, as a 
few weeks ago I started compiling it in rather than as a module like 
I've been doing for years (in response to the firmware (microcode) 
being dropped on the floor last month issue).  This box is the server 
(deltree) that all linux boxes mount a /home/common NFS export from.

All machines have the Intel pro/100 NIC, going to recompile the lot 
back to modules, see if that fixes the problem.

Grant.
