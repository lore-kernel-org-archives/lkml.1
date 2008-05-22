Return-Path: <linux-kernel-owner+w=401wt.eu-S1764066AbYEVXwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764066AbYEVXwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 19:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758511AbYEVXwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 19:52:13 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:23523 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758287AbYEVXwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 19:52:13 -0400
Date: Fri, 23 May 2008 08:50:32 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>, dhowells@redhat.com,
       mpm@selenic.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nommu: fix kobjsize() for SLOB and SLUB
Message-ID: <20080522235032.GA22697@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Christoph Lameter <clameter@sgi.com>,
	Pekka J Enberg <penberg@cs.helsinki.fi>, dhowells@redhat.com,
	mpm@selenic.com, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0805221907250.4056@sbz-30.cs.Helsinki.FI> <20080522234036.GA18434@linux-sh.org> <Pine.LNX.4.64.0805221644470.30217@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805221644470.30217@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 04:45:55PM -0700, Christoph Lameter wrote:
> On Fri, 23 May 2008, Paul Mundt wrote:
> > Is ksize() happy with taking the head page instead of virt_to_page(objp)?
> 
> ksize() takes a pointer to an object. ksize() cannot take a the pointer to 
> a page struct.
> 
Ah, so it does. In that case, we still need to kill off the page->index
BUG_ON() bits, while PageCompound() will take care of the compound order
bits that the page->index shifting seems to have been trying to
implement, the BUG_ON() will still trigger for PAGE_SIZE page cache
pages.
