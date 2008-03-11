Return-Path: <linux-kernel-owner+w=401wt.eu-S1756466AbYCKTjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756466AbYCKTjn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 15:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755962AbYCKTjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 15:39:33 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:37617 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbYCKTjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 15:39:32 -0400
Date: Tue, 11 Mar 2008 20:39:31 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Faster way to run through building single modules
In-Reply-To: <Pine.LNX.4.64.0802102035000.7915@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.64.0803112036110.18745@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0802101950020.7915@fbirervta.pbzchgretzou.qr>
 <20080210192821.GB13733@uranus.ravnborg.org>
 <Pine.LNX.4.64.0802102035000.7915@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 10 2008, Sam Ravnborg and Jan Engelhardt wrote:

>>>> I was wondering whether there is a shortcut in kbuild I can take if I 
>>>> just want to rebuild one module. Currently, I have:
>>>> 
>>>> make net/bridge/netfilter/ebtables.ko
>>>
>>>Fool kbuild to think this is an external module using:
>>>make M=`pwd` net/bridge/netfilter/ebtables.ko
>>>
>>>That should do the trick.
>>
>>How would I combine that with O=? Not quite doing the right thing yet.
>>
>>linux$ touch net/bridge/netfilter/ebtables.c 
>>linux$ make O=/home/jengelh/Coding/linux-obj M=$PWD
>>       net/bridge/netfilter/ebtables.ko
>
>O=tells where to find the kernel output files.
>We do not have a possibility to do so for external
>modules - so they will alwys build in same dir as the source.
>
>Bad luck :-(

I just noticed that with v2.6.25-rc3-302-g03923eb, running
make builds the final .ko really quick. Maybe there has been
some magic added that skips a lot of directories, but the
process certainly takes less than 120 seconds, so I am happy.

Previously, it seemed to have visited lots of directories
(even though we know make is not called recursively in 2.6)
before it printed "Building modules stage 2" for the first time.

Nice :)
