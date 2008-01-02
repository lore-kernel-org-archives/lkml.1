Return-Path: <linux-kernel-owner+w=401wt.eu-S1755251AbYABUqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbYABUqL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 15:46:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754704AbYABUpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 15:45:45 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33827 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754351AbYABUpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:45:44 -0500
Date: Wed, 2 Jan 2008 12:45:43 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>, htejun@gmail.com,
       gregkh@suse.de, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, maneesh@linux.vnet.ibm.com,
       lkml <linux-kernel@vger.kernel.org>, stable@kernel.org,
       linux-mm@kvack.org
Subject: Re: 2.6.22-stable causes oomkiller to be invoked
In-Reply-To: <20071228101109.GB5083@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.64.0801021237330.21526@schroedinger.engr.sgi.com>
References: <20071214150533.aa30efd4.akpm@linux-foundation.org>
 <20071215035200.GA22082@linux.vnet.ibm.com> <20071214220030.325f82b8.akpm@linux-foundation.org>
 <20071215104434.GA26325@linux.vnet.ibm.com> <20071217045904.GB31386@linux.vnet.ibm.com>
 <Pine.LNX.4.64.0712171143280.12871@schroedinger.engr.sgi.com>
 <20071217120720.e078194b.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0712171222470.29500@schroedinger.engr.sgi.com>
 <20071221044508.GA11996@linux.vnet.ibm.com>
 <Pine.LNX.4.64.0712261258050.16862@schroedinger.engr.sgi.com>
 <20071228101109.GB5083@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Dec 2007, Dhaval Giani wrote:

> we managed to get your required information. Last 10,000 lines are
> attached (The uncompressed file comes to 500 kb).
> 
> Hope it helps.

Somehow the nr_pages field is truncated to 16 bit and it 
seems that there are sign issues there? We are wrapping around....

 q->nr_pages is 36877, min_pages is 25 ----> swapper
 q->nr_pages is 46266, min_pages is 25 ----> bash
 q->nr_pages is 36877, min_pages is 25 ----> swapper
 q->nr_pages is 36877, min_pages is 25 ----> swapper
 q->nr_pages is 46265, min_pages is 25 ----> bash
 q->nr_pages is 46265, min_pages is 25 ----> cat
 q->nr_pages is 36877, min_pages is 25 ----> swapper
 q->nr_pages is 46265, min_pages is 25 ----> cat
 q->nr_pages is 36877, min_pages is 25 ----> swapper
 q->nr_pages is 0, min_pages is 25 ----> swapper
 q->nr_pages is 36877, min_pages is 25 ----> swapper
 q->nr_pages is 36877, min_pages is 25 ----> swapper
 q->nr_pages is 46265, min_pages is 25 ----> cat


An int is just a 16 bit field on i386? I thought it was 32 bits? Or is 
the result due to the way that systemtap works?

Could you post the neighboring per cpu variables to quicklist (look at the 
System.map). Maybe somehow we corrupt the nr_pages and page contents.

Also could you do another systemtap and also print out the current 
processor? Maybe nr_pages gets only corrupted on a specific processor. I 
see a zero there and sometimes other sane values.



