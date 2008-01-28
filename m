Return-Path: <linux-kernel-owner+w=401wt.eu-S1764290AbYA1XvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764290AbYA1XvV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 18:51:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755596AbYA1XvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 18:51:05 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:44585 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593AbYA1XvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 18:51:02 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <479E6A3D.3090201@s5r6.in-berlin.de>
Date: Tue, 29 Jan 2008 00:50:21 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Jarod Wilson <jwilson@redhat.com>
CC: linux1394-devel@lists.sourceforge.net,
       =?ISO-8859-1?Q?Kristian_H=F8?= =?ISO-8859-1?Q?gsberg?= 
	<krh@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: fail open() quickly if the node doesn't exist
 anymore
References: <tkrat.e1db90404aee1115@s5r6.in-berlin.de> <tkrat.a4603d89e4c2fde1@s5r6.in-berlin.de> <tkrat.340b4530dff1f75a@s5r6.in-berlin.de> <200801281732.03912.jwilson@redhat.com>
In-Reply-To: <200801281732.03912.jwilson@redhat.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jarod Wilson wrote:
> On Sunday 27 January 2008 12:21:56 pm Stefan Richter wrote:
>> Scenario:  Process A keeps the character device file of node N open.
>> N is being unplugged.  File /dev/fwN won't be destroyed as long as A
>> doesn't close it.  Now, process B opens /dev/fwN as well.  Previously
>> it would succeed but be unable to do any IO on it of course.  With this
>> patch, process B's open() will fail immediately with -ENODEV.

> Makes perfect sense to me, no problems with it in cursory testing.

Actually I have 2nd thoughts about it.  Clients should have a general
way to know that a device went away.  (I.e. distinguish I/O errors from
mere stale generation from I/O errors due to the node being gone for
good.)  I will check tomorrow if the ABI does this distinction already.
If yes, we don't need the patch.  (But might still need improvements in
libraw1394 or/and clients to fail fast when appropriate.)
-- 
Stefan Richter
-=====-==--- ---= ===-=
http://arcgraph.de/sr/
