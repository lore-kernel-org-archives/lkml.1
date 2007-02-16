Return-Path: <linux-kernel-owner+w=401wt.eu-S932898AbXBPBnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932898AbXBPBnn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 20:43:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932897AbXBPBnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 20:43:42 -0500
Received: from mexforward.lss.emc.com ([128.222.32.20]:56821 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932891AbXBPBnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 20:43:41 -0500
Date: Thu, 15 Feb 2007 20:43:23 -0500
To: "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [ANNOUNCE] DualFS: File System with Meta-data and Data Separation
From: sfaibish <sfaibish@emc.com>
Organization: EMC
Cc: "Juan Piernas Canovas" <piernas@ditec.um.es>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; format=flowed; delsp=yes; charset=iso-8859-15
MIME-Version: 1.0
References: <op.tnkdlbgsrwwil4@brcsmondepl2c.corp.emc.com> <op.tnrbrocsunckof@usensfaibisl2e.eng.emc.com> <Pine.LNX.4.61.0702142251460.19368@yvahk01.tjqt.qr> <Pine.LNX.4.61.0702151910370.19998@ditec.inf.um.es> <p73sld7f96t.fsf@bingen.suse.de> <Pine.LNX.4.61.0702152044450.17168@yvahk01.tjqt.qr>
Content-Transfer-Encoding: 7bit
Message-ID: <op.tnti2lseunckof@usensfaibisl2e.eng.emc.com>
In-Reply-To: <Pine.LNX.4.61.0702152044450.17168@yvahk01.tjqt.qr>
User-Agent: Opera Mail/9.10 (Win32)
X-PMX-Version: 4.7.1.128075, Antispam-Engine: 2.5.0.283055, Antispam-Data: 2007.2.15.172934
X-PerlMx-Spam: Gauge=, SPAM=2%, Reason='EMC_FROM_0+ -2, __CP_URI_IN_BODY 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __USER_AGENT 0'
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007 14:46:34 -0500, Jan Engelhardt  
<jengelh@linux01.gwdg.de> wrote:

>
> On Feb 15 2007 21:38, Andi Kleen wrote:
>>
>> Also I would expect your design to be slow for metadata read intensive
>> workloads. E.g. have you tried to boot a root partition with dual fs?
>> That's a very important IO benchmark for desktop Linux systems.
>
> Did someone say metadata intensive? Try kernel tarballs, they're a
> perfect workload. Tons of directories, and even more files here and
> there. Works wonders.

I just did now per your request. To make things more relevant I
created a file structure from the 2.4.19 kernel sources and repeated it
recursively into the deepest dir level (10) 4 times ending up with
7280 directories with 40 levels of directories depth and 1 GB
data set size. I run both tar and untar operations on the tree
for ext3, reiserfs, jfs and DualFS. I remounted the FS before
each test. I end up with 7280 directories 40 levels depth and
1 GB data. Both tar file and directory tree were on the FS under
test.

Here are the results - elapse time in sec:
		tar	untar
ext3:		144	143
reiserfs:	100	100
JFS:		196	140
DualFS:		63	54

Hope this helps.
>
>
> Jan

/Sorin

-- 
Using Opera's revolutionary e-mail client: http://www.opera.com/mail/
