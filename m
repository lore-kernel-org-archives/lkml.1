Return-Path: <linux-kernel-owner+w=401wt.eu-S932964AbXCMHxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932964AbXCMHxo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 03:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932997AbXCMHxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 03:53:43 -0400
Received: from smtp.osdl.org ([65.172.181.24]:36583 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932964AbXCMHxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 03:53:42 -0400
Date: Tue, 13 Mar 2007 00:53:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-mm@vger.kernel.org, clameter@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [QUICKLIST 0/4] Arch independent quicklists V2
Message-Id: <20070313005334.853559ca.akpm@linux-foundation.org>
In-Reply-To: <20070313071325.4920.82870.sendpatchset@schroedinger.engr.sgi.com>
References: <20070313071325.4920.82870.sendpatchset@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 13 Mar 2007 00:13:25 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:
> Page table pages have the characteristics that they are typically zero
> or in a known state when they are freed.

Well if they're zero then perhaps they should be released to the page allocator
to satisfy the next __GFP_ZERO request.  If that request is for a pagetable
page, we break even (except we get to remove special-case code).  If that
__GFP_ZERO allocation was or some application other than for a pagetable, we
win.

iow, can we just nuke 'em?

(Will require some work in the page allocator)
(That work will open the path to using the idle thread to prezero pages)
