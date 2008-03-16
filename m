Return-Path: <linux-kernel-owner+w=401wt.eu-S1752593AbYCPNfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbYCPNfM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 09:35:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbYCPNfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 09:35:01 -0400
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:57899 "EHLO
	bh-buildlin1.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbYCPNfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 09:35:00 -0400
Message-ID: <47DD21E1.2080505@panasas.com>
Date: Sun, 16 Mar 2008 15:34:25 +0200
From: Benny Halevy <bhalevy@panasas.com>
Organization: Panasas, Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Bernd Petrovitsch <bernd@firmix.at>
CC: Andreas Westin XX <andreas.xx.westin@ericsson.com>,
       linux-kernel@vger.kernel.org
Subject: Re: checkpatch.pl and statics
References: <6006DAC0B81F85439BC960F36F929CDFB5F5EE@eseldmw101.eemea.ericsson.se> <1205422989.3621.22.camel@tara.firmix.at>
In-Reply-To: <1205422989.3621.22.camel@tara.firmix.at>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar. 13, 2008, 17:43 +0200, Bernd Petrovitsch <bernd@firmix.at> wrote:
> On Don, 2008-03-13 at 16:09 +0100, Andreas Westin XX wrote:
> [....]
>> I ran checkpatch.pl on a piece of code I wrote and besides all the other
>> warnings/errors it complained about a static pointer being initialised
>> to NULL/0. I fixed it but I'm curious as to why this is not permitted ?
> 
> Because "uninitialized" data is automatically initialized wit 0. An
> explicit initialization with 0/NULL wastes space in the kernel image.

gcc (at least version >= 4.1.2) seems to smarter than that. It
doesn't seem to put data initialized to zero in the initialized data
segment but rather adds it to the uninitialized data. That said,
initializing statically allocated data to zero is superfluous in C
and should be avoided for style/elegance reasons as well.

Benny

> 
> 	Bernd

