Return-Path: <linux-kernel-owner+w=401wt.eu-S1756823AbYFAJBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823AbYFAJBY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 05:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbYFAJBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 05:01:15 -0400
Received: from mailout10.t-online.de ([194.25.134.21]:60760 "EHLO
	mailout10.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbYFAJBP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 05:01:15 -0400
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: CONFIG_PREEMPT causes corruption of application's FPU stack
Cc: linux-kernel@vger.kernel.org, ak@suse.de
Content-Disposition: inline
From: j.mell@t-online.de
Reply-To: j.mell@t-online.de
Date: Sun, 1 Jun 2008 11:01:06 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200806011101.06491.j.mell@t-online.de>
X-ID: XR5w4oZZYh4471p6b5mm8D5hzZQTvylyrbIkcGmOiVfeGu8rkWnSNuCvbFakqZmZ3y
X-TOI-MSGID: e22c414f-2a0b-494a-b0dd-090ef4af6607
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> On Sat, May 17, 2008 at 06:31:08PM +0200, J?rgen Mell wrote:
> I tracked this down to a single kernel configuration option. If
> CONFIG_PREEMPT is set to 'y' the application will start crashing.
> If  CONFIG_PREEMPT is replaced by CONFIG_PREEMPT_VOLUNTARY, the
> application will run without errors.

With lots of help from Heinz-Bernd, Bernd and Oliver of the Einstein@Home 
project I now found the the following:

1. Einstein@home will crash with trap #8 if the problem is present. The 
error occurs between some minutes after starting Einstein up to more than 
10 hours after starting Einstein. This seems to depend on how many other 
applications are used on the system (it takes much more time, if only the 
Einstein processes are active on the system).

2. The error was introduced between kernel.org kernels 2.6.19.7 and 2.6.20. 
It is still present in 2.6.26-rc4

3. If I revert the patch
 
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=acc207616a91a413a50fdd8847a747c4a7324167

in 2.6.20, Einstein does not crash anymore (program was run for more than 
30 hours while system was in normal use with programming, multi-media 
etc.). Unfortunately git refuses to revert this patch in 2.6.26-rc4.

Now I need some help as I am not an expert in this area. What I assume is 
that either the state of the FPU is not always restored (perhaps if the 
process is swapped between the two cores?) or it is restored more than 
once. Please keep in mind, that I am always running two Einstein processes 
simultaneously on my two cores!
I am willing to do further testing of this problem if someone can give me a 
hint how to continue.

Bye,

          Jürgen
