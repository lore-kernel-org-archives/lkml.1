Return-Path: <linux-kernel-owner+w=401wt.eu-S1753240AbYKZBDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbYKZBDq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 20:03:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751443AbYKZBDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 20:03:38 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:39089 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbYKZBDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 20:03:37 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <492CA046.9010501@s5r6.in-berlin.de>
Date: Wed, 26 Nov 2008 02:03:02 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.18) Gecko/20081116 SeaMonkey/1.1.13
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Fabio Comolli <fabio.comolli@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jay Fenlason <fenlason@redhat.com>
Subject: Re: Regression in 2.6.28-rc and 2.6.27-stable - hibernate related
References: <b637ec0b0811230817x5b445a0m665305d2b6bf6c1f@mail.gmail.com> <492A5557.2010404@s5r6.in-berlin.de> <200811260015.24549.rjw@sisk.pl> <200811260031.20079.rjw@sisk.pl>
In-Reply-To: <200811260031.20079.rjw@sisk.pl>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
>>>>> On Sun, Nov 23, 2008 at 7:24 PM, Fabio Comolli <fabio.comolli@gmail.com> wrote:
>>>>> The bisection pointed to:
>>>>>
>>>>> ------------------------------------------------------------------------------------------------------------------------------------------------
>>>>> fcomolli@hawking:~/software/GIT-TREES/linux-2.6.27.y> git bisect good
>>>>> ff0f8d16839cd02dc95bd92c212cbd5d433a4d2b is first bad commit
>>>>> commit ff0f8d16839cd02dc95bd92c212cbd5d433a4d2b
>>>>> Author: Jay Fenlason <fenlason@redhat.com>
>>>>> Date:   Mon Oct 27 23:28:14 2008 +0100
>>>>>
>>>>>     firewire: fix struct fw_node memory leak
>>>>>
>>>>>     commit 77e557191701afa55ae7320d42ad6458a2ad292e upstream

(I still have a suspicion that this commit, or firewire even, is not the
actual culprit.  But one never knows.)

> Also, on a possibly related note, I've just found a report from a Mac Mini user
> who told me his machine hanged during resume from hibernation if his external
> firewire drive was connected to the port.  He worked around the problem by
> switching to the new firewire stack that worked for him.

The above bisection result is about the new stack = drivers/firewire/.
The old stack is drivers/ieee1394/ and I prefix all its changes with
"ieee1394:".

Of course the old stack is supposed to hibernate + restore properly too.
I personally tested only suspend + resume though, and that's quite long
ago...
-- 
Stefan Richter
-=====-==--- =-== ==-=-
http://arcgraph.de/sr/
