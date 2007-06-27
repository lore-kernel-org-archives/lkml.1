Return-Path: <linux-kernel-owner+w=401wt.eu-S1761545AbXF0UAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761545AbXF0UAW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 16:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbXF0UAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 16:00:11 -0400
Received: from mail.tmr.com ([64.65.253.246]:43814 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbXF0UAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 16:00:10 -0400
Message-ID: <4682C246.1050609@tmr.com>
Date: Wed, 27 Jun 2007 16:02:14 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Marc Perkel <mperkel@yahoo.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: How would I do this? (expert tricks) OT
References: <456863.7892.qm@web52512.mail.re2.yahoo.com>
In-Reply-To: <456863.7892.qm@web52512.mail.re2.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Marc Perkel wrote:
> I have a server with port 25 closed. I was to be able
> to run a script every time someone tries to connect to
> port 25, but from the outside the port remains closed.
> I need the script that I'm going to run get the IP
> address that tried to connect.
> 
> I know it's off topic but it's part of an experiment
> to stop spam. 

Put a rule in iptables to jump to a user table to do a log and drop. You 
are doing it the wrong way, you want to set syslog to write the log 
message to a FIFO and have a permanent running program reading it (I do 
just this for other things).

Alternatively you can use redirect to send it to a program of your 
choosing, which can run a script if you really want to. Beware that rate 
limiting is desirable if you are going to start a process for ANY type 
of attack packets.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
