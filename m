Return-Path: <linux-kernel-owner+w=401wt.eu-S1756557AbYAZADR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557AbYAZADR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 19:03:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752594AbYAZADF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 19:03:05 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:54685 "EHLO
	outbound3-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752446AbYAZADE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 19:03:04 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: C391E81C-6590-4A2B-9214-A04D45AF4E95
Date: Fri, 25 Jan 2008 17:00:52 -0700
From: "Jordan Crouse" <jordan.crouse@amd.com>
To: "Hasan Rashid" <hasan@digitalpath.net>
cc: linux-kernel@vger.kernel.org
Subject: Re: CS5536 mfgpt timer setup register hangs board
Message-ID: <20080126000052.GA29843@cosmic.amd.com>
References: <1788.65.164.104.9.1201305044.squirrel@webmail.digitalpath.net>
MIME-Version: 1.0
In-Reply-To: <1788.65.164.104.9.1201305044.squirrel@webmail.digitalpath.net>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-OriginalArrivalTime: 25 Jan 2008 23:59:01.0518 (UTC)
 FILETIME=[41EEDAE0:01C85FAE]
X-WSS-ID: 6B84A84F2IW8844668-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/01/08 15:50 -0800, Hasan Rashid wrote:
> 
> Hi,
> 
> I have been working on a watchdog timer using the mfgpt on AMD Geode
> CS5536. I initialize the setup register MFGPT0_SETUP (0x6206) with hex
> value 0x306 (1100000110b). However, after this first initialization if I
> ever read/write to the register it hangs the system.
> 
> I have been through all the documentation, tried several different methods
> but all the efforts, frustratingly, to no avail.
> 
> Does anyone have any idea as to why would this be? TIA!

It looks like you are using TinyBIOS.  Make sure that if you are using v0.99
that you do *not* enable the MFGPT workaround.  If you are using an older 
version, then you will need this patch:

http://lkml.org/lkml/2008/1/23/372

And enable mfgptfix on the command line.  There seems to be a problem with
the MFGPT "workaround" that causes hangs exactly like you are seeing.

Jordan

-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.


