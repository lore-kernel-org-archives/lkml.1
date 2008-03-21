Return-Path: <linux-kernel-owner+w=401wt.eu-S1759948AbYCUWU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759948AbYCUWU1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 18:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753807AbYCUWUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:20:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33630 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753460AbYCUWUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:20:14 -0400
Date: Fri, 21 Mar 2008 15:19:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: arjan@infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [1/2] vmalloc: Show vmalloced areas via /proc/vmallocinfo
Message-Id: <20080321151935.6a330536.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0803201141250.10592@schroedinger.engr.sgi.com>
References: <20080318222701.788442216@sgi.com>
	<20080318222827.291587297@sgi.com>
	<20080319210436.191bb8fe@laptopd505.fenrus.org>
	<Pine.LNX.4.64.0803201141250.10592@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Mar 2008 12:22:07 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> On Wed, 19 Mar 2008, Arjan van de Ven wrote:
> 
> > > +	proc_create("vmallocinfo",S_IWUSR|S_IRUGO, NULL,
> > why should non-root be able to read this? sounds like a security issue (info leak) to me...

What is the security concern here?  This objection is rather vague.

> Well I copied from the slabinfo logic (leaking info for slabs is okay?).
> 
> Lets restrict it to root then:
> 
> 
> 
> Subject: vmallocinfo: Only allow root to read /proc/vmallocinfo
> 
> Change permissions for /proc/vmallocinfo to only allow read
> for root.

That makes the feature somewhat less useful.  Let's think this through more
carefully - it is, after all, an unrevokable, unalterable addition to the
kernel ABI.

Arjan, what scenarios are you thinking about?
