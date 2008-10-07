Return-Path: <linux-kernel-owner+w=401wt.eu-S1755321AbYJGOq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbYJGOq1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 10:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752754AbYJGOqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 10:46:16 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:46138 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752815AbYJGOqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 10:46:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=BLrYtipWRQ1l+ifHhuWFKW4uUcQO1m1s/iO+aG4fdrroNBPkWzPNNjhdadU0udJWWgr0v+7VKUC3uB9UG1kfT/jzhLSfMONfos4DrIn8ol0mvc3bhRu4LGqtlDt2g7obHOgiy3Xv8iKdF9XGUp3EqPAlKK85ft6Jo5mD8gJCEgo=  ;
X-YMail-OSG: gJGyZFgVM1mMrqPL_xbRmOMc68kfu7rV5enqCQth18C7Ovdn_2mz73yF4NmSqy_KO_x97OmPauLLUeaX.gF4ZV2OmrotI.6_.y1fx9zK5iuLr29tG8v.y5PxNUpDb_rhHBs1MlimnFFAeGGhaLFuAfY_Jn.kt4PVn8DyfvvLtIODau_fyCg-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Improve buffered streaming write ordering
Date: Wed, 8 Oct 2008 01:46:06 +1100
User-Agent: KMail/1.9.5
Cc: Theodore Tso <tytso@mit.edu>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Chris Mason <chris.mason@oracle.com>,
       Dave Chinner <david@fromorbit.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       ext4 <linux-ext4@vger.kernel.org>
References: <1222950054.6745.18.camel@think.oraclecorp.com> <20081007132911.GA6905@mit.edu> <20081007133651.GA19895@infradead.org>
In-Reply-To: <20081007133651.GA19895@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810080146.06692.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 October 2008 00:36, Christoph Hellwig wrote:
> On Tue, Oct 07, 2008 at 09:29:11AM -0400, Theodore Tso wrote:
> > That's true, but there is a lot of code duplication, which means that
> > bugs or changes in write_cache_pages() would need to be fixed in
> > ext4_write_cache_pages().  So another approach that might be better
> > from a long-term code maintenance point of view is to add a flag in
> > struct writeback_control that tells write_cache_pages() not to update
> > those fields, and avoid duplicating approximately 95 lines of code.
> > It means a change in a core mm function, though, so if folks thinks
> > its too ugly, we can make our own copy in fs/ext4.

Heh, funny you should mention that. I was looking at it just the other
day. It's riddled with bugs (some of which supposedly are by-design
circumventing of data integrity).

http://linux.derkeiler.com/Mailing-Lists/Kernel/2008-10/msg00917.html

I'm also looking (in the same thread) at doing a patch to improve fsync
performance and ensure it doesn't get stuck behind concurrent dirtiers
by adding another tag to the radix-tree. Mikulas is also looking at
improving that problem with another method. It would be nice if fsdevel
gurus would participate (I'll send out my patchset when I get it working,
and recap the situation and competing ideas).
