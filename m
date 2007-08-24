Return-Path: <linux-kernel-owner+w=401wt.eu-S932951AbXHXTJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932951AbXHXTJ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 15:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762030AbXHXTJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 15:09:18 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:33917 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758382AbXHXTJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 15:09:18 -0400
Message-ID: <46CF2CDD.5000802@steeleye.com>
Date: Fri, 24 Aug 2007 15:09:17 -0400
From: Paul Clements <paul.clements@steeleye.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Mike Snitzer <snitzer@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       david@dgreaves.com, Wouter Verhelst <w@uter.be>,
       Corey Minyard <cminyard@mvista.com>, nbd-general@lists.sourceforge.net
Subject: Re: [PATCH 2/2] NBD: allow hung network I/O to be cancelled
References: <46CF101F.4050603@steeleye.com> <46CF1826.9050101@steeleye.com> <170fa0d20708241113y31d2ba95xf30c83c7c4c98cd2@mail.gmail.com>
In-Reply-To: <170fa0d20708241113y31d2ba95xf30c83c7c4c98cd2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Snitzer wrote:
> On 8/24/07, Paul Clements <paul.clements@steeleye.com> wrote:
>> This patch allows NBD I/O to be cancelled when a network outage occurs.
>> Previously, I/O would just hang, and if enough I/O was hung in nbd, the
>> system (at least user-level) would completely hang until a TCP timeout
>> (default, 15 minutes) occurred.
>>
>> The patch introduces a new ioctl NBD_SET_TIMEOUT that allows a transmit
>> timeout value (in seconds) to be specified. Any network send that
>> exceeds the timeout will be cancelled and the nbd connection will be
>> shut down. I've tested with various timeout values and 6 seconds seems
>> to be a good choice for the timeout. If the NBD_SET_TIMEOUT ioctl is not
>> called, you get the old (I/O hang) behavior.
> 
> Hi Paul,
> 
> Thanks for implementing this!  Do you happen to have an associated
> nbd-client patch for userspace?  If not I'd be happy to coordinate
> with you and Wouter on a patch.

No, I don't. I just basically hardcoded my nbd-client to do a 6 second 
timeout by default, but Wouter will probably want to do something a 
little less hackish for the official nbd-client.

--
Paul
