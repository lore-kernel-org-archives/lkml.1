Return-Path: <linux-kernel-owner+w=401wt.eu-S1760870AbXGCT26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760870AbXGCT26 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 15:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757355AbXGCT2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 15:28:51 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:63933 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757323AbXGCT2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 15:28:50 -0400
Message-ID: <468AA364.2010000@nortel.com>
Date: Tue, 03 Jul 2007 15:28:36 -0400
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20060130 Red Hat/1.7.12-1.4.2
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Arne Georg Gleditsch <argggh@dolphinics.no>
CC: Florian Attenberger <valdyn@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21.5 june 30th to july 1st date hang?
References: <F1D642E5A91BC94D9504EC83AE19E6B0128A5C@ecqcmtlmail3.quebec.int.ec.gc.ca> <20070703135949.GB19565@master.home> <87hcol7en2.fsf@pelargir.dolphinics.no> <20070703150210.GA31495@master.home> <87d4z97bks.fsf@pelargir.dolphinics.no>
In-Reply-To: <87d4z97bks.fsf@pelargir.dolphinics.no>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Jul 2007 19:28:39.0550 (UTC) FILETIME=[5BCA79E0:01C7BDA8]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arne Georg Gleditsch wrote:

> An interesting exercise might be to
> code up a small program to call adjtimex with timex.status |= STA_INS,
> to see if this can trigger the problem.

Setting the date to just before midnight June 30 UTC and then running the 
following as root triggered the crash on a modified 2.6.10.  Anyone see anything 
wrong with the code below, or is this a valid indication of a bug in the leap 
second code?

Chris


#include <sys/timex.h>
#include <stdio.h>
#include <errno.h>

struct timex buf;
int main(void)
{
	int rc = adjtimex(&buf);
	printf("initial status: 0x%x\n", buf.status);
	buf.status |= STA_INS;
	buf.modes = ADJ_STATUS;
	rc = adjtimex(&buf);
	if (rc == -1) {
		printf("unable to set status: %m\n");
		return -1;
	} else
		printf("rc: %d\n", rc);
	printf("final status: 0x%x\n", buf.status);
	return 0;
}
