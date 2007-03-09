Return-Path: <linux-kernel-owner+w=401wt.eu-S1752650AbXCIIxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650AbXCIIxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 03:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752651AbXCIIxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 03:53:20 -0500
Received: from warden-p.diginsite.com ([208.29.163.248]:50307 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1752650AbXCIIxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 03:53:19 -0500
Date: Fri, 9 Mar 2007 00:31:45 -0800 (PST)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: Florian Weimer <fweimer@bfk.de>
cc: Niklaus <niklaus@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: more than 65535 outbound connections
In-Reply-To: <82d53izucg.fsf@mid.bfk.de>
Message-ID: <Pine.LNX.4.63.0703090027310.30949@qynat.qvtvafvgr.pbz>
References: <85e0e3140703090016h609ecc5t504121a99bcd3e44@mail.gmail.com><85e
 0e3140703090019r7daf5ce4g9269925773374bf7@mail.gmail.com> <82d53izucg.fsf@mid.bfk.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Mar 2007, Florian Weimer wrote:

>> i read on the web that terry lambert has got 1.6 million simultaneous
>> connection ? how is the way it is done.
>
> Multiple IP addresses, I guess.

what must be unique is the four-parts of a connection
source IP, source port, destination IP, destination port

as long as the set is unique any element can be re-used (a big webserver has one 
IP and port on the server side, but many IPs and ports on the client side)

when you make a connection you have the option of not specifying the source IP 
and port (letting the OS/library pick ones for you). some libraries will not 
re-use the same source port for multiple connections, others will (with the 
appropriate options)

if you want to have your program assign the source IPs and port itself you can 
do so (you may have to also give the library/os a flag that tells it you know 
what you're doing, and it's ok to let you re-use ports)

David Lang
