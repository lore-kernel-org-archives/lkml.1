Return-Path: <linux-kernel-owner+w=401wt.eu-S1756170AbYCNMNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbYCNMNj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 08:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbYCNMNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 08:13:32 -0400
Received: from mexforward.lss.emc.com ([128.222.32.20]:33211 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbYCNMNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 08:13:31 -0400
Message-ID: <47DA6BB5.9070500@emc.com>
Date: Fri, 14 Mar 2008 08:12:37 -0400
From: Ric Wheeler <ric@emc.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Benny Amorsen <benny+usenet@amorsen.dk>
CC: linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
References: <200803092346.17556.phillips@phunq.net> <200803110450.19390.phillips@phunq.net> <20080311215601.GM23784@marowsky-bree.de> <200803111602.53835.phillips@phunq.net> <m3d4q08477.fsf@ursa.amorsen.dk> <20080312133001.1668f40d@the-village.bc.nu> <20080314093019.GA5966@ucw.cz> <47DA5C8D.2020207@emc.com> <m3fxutcz2s.fsf@ursa.amorsen.dk>
In-Reply-To: <m3fxutcz2s.fsf@ursa.amorsen.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Version: 4.7.1.128075, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2007.8.30.51425
X-PerlMx-Spam: Gauge=, SPAM=0%, Reason='EMC_BODY_PROD_2+ -3, EMC_FROM_0+ -3, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __USER_AGENT 0'
X-Tablus-Inspected: yes
X-Tablus-Classifications: public
X-Tablus-Action: allow
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benny Amorsen wrote:
> Ric Wheeler <ric@emc.com> writes:
> 
>> The only really safe default is to disable the write cache by default
>> or possibly dynamically disable the write cache when barriers are not
>> supported by a drive. Both have a severe performance impact and I am
>> not sure that for most casual users it is a good trade.
> 
> So people ARE running their disks in a mode similar to Ramback.
> 
> 
> /Benny
> 

We have been looking at write performance with RAM disk, battery backed 
Clariion array & slow laptop drives in another thread on fs-devel, but 
the rough numbers should be interesting.

If you are not doing an fsync() at the end of writing a file, you are 
writing to the page cache (as long as it fits in DRAM) so you are 
basically getting thousands of small files/sec.

We did a test which showed the following for synchronous (fsync()) 
writers of small files with a SLES10/SP1 kernel but the results still 
hold for upstream kernels (at least for the order of magnitude).

Ramdisk test backed testing showed over 4600 small 4k files/sec with 1 
thread.

Midrange array (looks like a ramdisk behind a fibre channel port) hit 
around 778 files/sec with 1 thread.

With a local disk, write cached enabled and barriers on, you are getting 
around 47 4k files/sec.

The tests were run on ext3, different file systems perform differently 
but all fall in the same order of magnitude of performance with the same 
class of storage behind it ;-)

ric
