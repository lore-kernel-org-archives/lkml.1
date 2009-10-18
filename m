Return-Path: <linux-kernel-owner+w=401wt.eu-S1755602AbZJRXlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602AbZJRXlv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 19:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755431AbZJRXlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 19:41:50 -0400
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:50957 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752380AbZJRXlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 19:41:49 -0400
From: Frans Pop <elendil@planet.nl>
To: Sven Geggus <lists@fuchsschwanzdomain.de>
Subject: Re: Kernel crash on 2.6.31.x (kcryptd: page allocation failure..)
Date: Mon, 19 Oct 2009 01:41:49 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       linux-mm@kvack.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <hbd4dk$5ac$1@ultimate100.geggus.net> <200910172230.13162.elendil@planet.nl> <hbd9v8$7rf$1@ultimate100.geggus.net>
In-reply-To: <hbd9v8$7rf$1@ultimate100.geggus.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910190141.50752.elendil@planet.nl>
X-OriginalArrivalTime: 18 Oct 2009 23:41:53.0566 (UTC) FILETIME=[924BD3E0:01CA504C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Sven: For kernel mailing lists please always do a "reply to all".
Although some other communities do not want that, it is standard for the 
kernel community. It is needed because otherwise, with the huge amount of 
traffic on the linux-kernel list, people are too likely to miss replies.)

Sven Geggus wrote:
> Frans Pop <elendil@planet.nl> wrote:
> 
>> What is the _exact_ command sequence you use to reproduce it? I already
>> have a testcase, but a second test case, or a simpler one, may be
>> useful. 
> 
> Not a particular easy testcase. This is what I did:
> 
> On the crashing machine with the dm-encrypted xfs volume:
> ionice -c 3 socat TCP4-LISTEN:5555 - >backup.tar
> 
> On the source machine:
> tar cv dir |socat - TCP4:targetmachine:5555
> 
> You will certainly not need to use tar.
> 
> socat /dev/zero TCP4:targetmachine:5555 should work as well.
> 
> I don't know if TCP traffic is really needed probably it is.

Thanks.

In the mean time I've been able to trace the culprit. Could you please try 
if reverting 373c0a7e + 8aa7e847 [1] on top of 2.6.31 fixes the issue for 
you?

Cheers,
FJP

[1] The first commit is a build fix for the second.
