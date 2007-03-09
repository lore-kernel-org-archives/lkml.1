Return-Path: <linux-kernel-owner+w=401wt.eu-S1767144AbXCIKnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767144AbXCIKnF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 05:43:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767153AbXCIKnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 05:43:05 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:18492 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767144AbXCIKnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 05:43:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=F0HSI2mkvI0hYXmEHN6cmSmqcVZ8sjapVJkErdYbSGH5f8dURT996MGzF4jrL5TScyHkcbcq+P/6kc3gJotCjeXhmD0su6A4B54egPhjYAQAd/ot3e2mP8HuIZQJh3rILclYNHdlvW3eRq1QGcGjuJkgtSlCoNgh4N+zAoY5Drc=
Message-ID: <85e0e3140703090243n36fd467dwc83aff0d7b6fb004@mail.gmail.com>
Date: Fri, 9 Mar 2007 16:13:00 +0530
From: Niklaus <niklaus@gmail.com>
Subject: Re: more than 65535 outbound connections
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.63.0703090027310.30949@qynat.qvtvafvgr.pbz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <85e0e3140703090016h609ecc5t504121a99bcd3e44@mail.gmail.com>
	 <82d53izucg.fsf@mid.bfk.de>
	 <Pine.LNX.4.63.0703090027310.30949@qynat.qvtvafvgr.pbz>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/9/07, David Lang <david.lang@digitalinsight.com> wrote:
> On Fri, 9 Mar 2007, Florian Weimer wrote:
>
> >> i read on the web that terry lambert has got 1.6 million simultaneous
> >> connection ? how is the way it is done.
> >
> > Multiple IP addresses, I guess.
>
> what must be unique is the four-parts of a connection
> source IP, source port, destination IP, destination port
>
> as long as the set is unique any element can be re-used (a big webserver has one
> IP and port on the server side, but many IPs and ports on the client side)
>
> when you make a connection you have the option of not specifying the source IP
> and port (letting the OS/library pick ones for you). some libraries will not
> re-use the same source port for multiple connections, others will (with the
> appropriate options)
>
> if you want to have your program assign the source IPs and port itself you can
> do so (you may have to also give the library/os a flag that tells it you know
> what you're doing, and it's ok to let you re-use ports)
>

yes now lets take 2 dest machines , source ip is fixed , source port (2^16 - 1)
destip is fixed (a.a.a.a and b.b.b.b) ,dest port(2^16 -1) each ,

for a connection we have one port used , say connection 1 is

source ip,port 1 , a.a.a.a port 1
source ip,port 2 , a.a.a.a port 2
.
.
.
source ip,port 65535 , a.a.a.a port 65535

so total of 65535 connections (assume traffic is still going on, a
movie on a slow line dialup or 1kbps )

now if i try to open another connection (assume lots of file
descriptors are present) to a.a.a.a what happens

to b.b.b.b what happens

i think both will not get established as the OS doesn't have any free
source ports or am i wrong

> David Lang
>
