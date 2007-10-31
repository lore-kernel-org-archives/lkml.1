Return-Path: <linux-kernel-owner+w=401wt.eu-S1757825AbXJaRTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757825AbXJaRTT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 13:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752117AbXJaRTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 13:19:05 -0400
Received: from mexforward.lss.emc.com ([128.222.32.20]:47041 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbXJaRTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 13:19:03 -0400
Message-ID: <4728B8C5.90607@emc.com>
Date: Wed, 31 Oct 2007 13:17:57 -0400
From: Ric Wheeler <ric@emc.com>
Reply-To: ric@emc.com
User-Agent: Thunderbird 1.5.0.8 (X11/20061025)
MIME-Version: 1.0
To: Zach Brown <zab@zabbo.net>
CC: Mike Waychison <mikew@google.com>, Chris Mason <chris.mason@oracle.com>,
       Anton Altaparmakov <aia21@cam.ac.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/6][RFC] Cleanup FIBMAP
References: <20071026233732.568575496@crlf.corp.google.com>	<E579083F-FED3-4990-8E24-275ED38E9E3B@cam.ac.uk> <20071029101001.4378a7cf@think.oraclecorp.com> <47260AB1.9000003@zabbo.net> <472631FE.9070003@google.com> <47263BEC.30501@zabbo.net> <472861A8.8020709@emc.com> <4728AA49.6020405@zabbo.net>
In-Reply-To: <4728AA49.6020405@zabbo.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Version: 4.7.1.128075, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2007.8.30.53115
X-PerlMx-Spam: Gauge=, SPAM=1%, Reason='EMC_FROM_0+ -3, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __USER_AGENT 0'
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zach Brown wrote:
>> The second use case is to look at the physical layout of blocks on disk
>> for a specific file, use Mark Lord's write_long patches to inject a disk
>> error and then read that file to make sure that we are handling disk IO
>> errors correctly.  A bit obscure, but really quite useful.
> 
> Hmm, yeah, that's interesting.

It would be even better if we could poke holes in metadata, etc, but 
this gives us a reasonable test case.

> 
>> We have also used FIBMAP a few times to try and map an observed IO error
>> back to a file. Really slow and painful to do, but should work on any
>> file system when a better method is not supported.
> 
> We're getting off of this FIBMAP topic, but this interests me.  Can we
> explore this a little?  How did you find out about the error without
> having a file to associate with it?  Drive scrubbing, or some such?
> 
> - z

Vladimir extended debugreiserfs to do an optimized reverse mapping scan 
of the disk sector to file/metadata/etc. Definitely worth having that 
ability for any file system.

We also do drive scrubbing, looking for bad sectors. The list of those 
sectors is fed into the reverse mapping code to enable us to gage the 
impact of the IO errors, start recovering the user files, etc.

The scrub code we use takes advantage of the read-verify command (to 
avoid data transfer from the drive to the page cache).

ric
