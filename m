Return-Path: <linux-kernel-owner+w=401wt.eu-S1757673AbZASIMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757673AbZASIMU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 03:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752179AbZASIMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 03:12:07 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:33870 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbZASIME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 03:12:04 -0500
From: Chandru <chandru@in.ibm.com>
Organization: ibm
To: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: 2.6.28-rc9 panics with crashkernel=256M while booting
Date: Mon, 19 Jan 2009 13:41:58 +0530
User-Agent: KMail/1.9.10
Cc: Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <200812241325.49404.chandru@in.ibm.com> <200901161746.36584.chandru@in.ibm.com> <1232128377.27278.69.camel@nimitz>
In-Reply-To: <1232128377.27278.69.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901191341.58437.chandru@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 January 2009 23:22:57 Dave Hansen wrote:
> Just looking at it, that calculation is OK.  But, there was one in your
> dmesg that looked a page too long, like page 0x1001 instead of 0x1000.
> I'd find out how that happened.

That is a result of PFN_UP() in reserve_bootmem_node() for which we hit the 
BUG_ON() eventually.   Prior to calling reserve_bootmem_node() we have...

node_ar.end_pfn = node->node_end_pfn = PFN_DOWN(physbase+reserve_size). 

Hence a PFN_UP() will raise the value of 'end'. The kernel has 
CONFIG_PPC_64K_PAGES enabled in the config. 

Chandru
