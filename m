Return-Path: <linux-kernel-owner+w=401wt.eu-S1756708AbYEZTe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708AbYEZTe0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 15:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755327AbYEZTeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 15:34:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755233AbYEZTeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 15:34:17 -0400
Date: Mon, 26 May 2008 15:33:18 -0400
From: Rik van Riel <riel@redhat.com>
To: balbir@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH -mm 00/16] VM pageout scalability improvements (V8)
Message-ID: <20080526153318.29edc0b2@bree.surriel.com>
In-Reply-To: <483B0077.7000207@linux.vnet.ibm.com>
References: <20080523195506.084894989@redhat.com>
	<483B0077.7000207@linux.vnet.ibm.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 May 2008 23:54:55 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> Rik van Riel wrote:
> > On large memory systems, the VM can spend way too much time scanning
> > through pages that it cannot (or should not) evict from memory. Not
> > only does it use up CPU time, but it also provokes lock contention
> > and can leave large systems under memory presure in a catatonic state.
> 
> Hi, Rik,
> 
> This patchset looks good (I did a brief scan). I'll go ahead and play with it?
> What is a good memory size to test the patches on (to see improvements).

The larger, the better.  One known problem with the current upstream
VM is large numbers of anonymous pages, or a mix of mlocked and anon
pages.

Once the system needs to swap something out, every single anon page
will have the referenced bit set and the system needs to do lots of
scanning before it can evict the first page.  This scanning causes
multiple CPUs to pile up and things slow down exponentially and/or
catastrophically :)

Unfortunately the largest system I have access to on a regular basis
has "only" 16GB of RAM :(

I am also making 2.6.25 based kernel RPMs available with the split LRU
patch set, at http://people.redhat.com/riel/splitvm/

The most recently posted patches are newer, though...

-- 
All rights reversed.
