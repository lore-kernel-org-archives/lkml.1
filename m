Return-Path: <linux-kernel-owner+w=401wt.eu-S1754757AbXISRIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbXISRIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbXISRIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:08:32 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:49981 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751713AbXISRIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:08:31 -0400
Date: Wed, 19 Sep 2007 10:08:31 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ethan Solomita <solo@google.com>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] cpuset write dirty map
In-Reply-To: <20070918191405.d9b43470.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0709191006160.10862@schroedinger.engr.sgi.com>
References: <469D3342.3080405@google.com> <46E741B1.4030100@google.com>
 <46E742A2.9040006@google.com> <20070914161536.3ec5c533.akpm@linux-foundation.org>
 <46F072A5.8060008@google.com> <20070918191405.d9b43470.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2007, Andrew Morton wrote:

> How hard would it be to handle the allocation failure in a more friendly
> manner?  Say, if the allocation failed then point mapping->dirty_nodes at
> some global all-ones nodemask, and then special-case that nodemask in the
> freeing code?

Ack. However, the situation dirty_nodes == NULL && inode dirty then means 
that unknown nodes are dirty. If we are later are successful with the 
alloc and we know that the pages are dirty in the mapping then the initial 
dirty_nodes must be all ones. If this is the first page to be dirtied then 
we can start with a dirty_nodes mask of all zeros like now.

