Return-Path: <linux-kernel-owner+w=401wt.eu-S1750984AbXBCSKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750984AbXBCSKJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 13:10:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750973AbXBCSKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 13:10:09 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:48214 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750994AbXBCSKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 13:10:07 -0500
Date: Sat, 3 Feb 2007 10:09:56 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Arjan van de Ven <arjan@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [RFC] Tracking mlocked pages and moving them off the LRU
In-Reply-To: <1170525860.3073.1054.camel@laptopd505.fenrus.org>
Message-ID: <Pine.LNX.4.64.0702031005510.5461@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0702022214580.3960@schroedinger.engr.sgi.com> 
 <20070203005316.eb0b4042.akpm@linux-foundation.org> 
 <Pine.LNX.4.64.0702030946330.5388@schroedinger.engr.sgi.com>
 <1170525860.3073.1054.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Feb 2007, Arjan van de Ven wrote:

> it's simpler. You only move them off when you encounter them during a
> scan. No walking early etc etc. Only do work when there is an actual
> situation where you do scan.

Yes but then you do not have an accurate count of MLOCKed pages. We will 
only have that count after reclaim has run and removed the pages from the 
LRU. That could take some time (or may never happen the way some people 
handle memory around here).

> Well.. That's the point! Only IF there is a reclaim scan do you move
> them out again. The fact that these pages are on the list isn't a
> problem. The fact that you keep encountering them over and over again
> during *scanning* is. So Andrews suggestion makes them go away in the
> situations that actually matter

I see... Okay that could be simple to address.

> who cares though.. just do it lazy.

The other issue that the patch should address is to allow the VM to have 
statistics that show the actual amount of MLOCKed pages. With the pure 
scanner based approach this would no longer work.

