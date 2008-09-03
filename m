Return-Path: <linux-kernel-owner+w=401wt.eu-S1755482AbYICPLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482AbYICPLN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 11:11:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbYICPLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 11:11:03 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010AbYICPLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 11:11:01 -0400
Date: Wed, 3 Sep 2008 11:03:04 -0400
From: Josef Bacik <jbacik@redhat.com>
To: Ryan Hope <rmh3093@gmail.com>
Cc: Toei Rei <toei.rei@stargazer.at>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kernel BUG at fs/btrfs-stable/extent-tree.c:2111!
Message-ID: <20080903150304.GA31775@unused.rdu.redhat.com>
References: <48f7fe350809030752s329a0d09y27530d22237c57ba@mail.gmail.com> <200809031700.47477.toei.rei@stargazer.at> <48f7fe350809030803q6f4c4d69j9617ed266b86eb8d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48f7fe350809030803q6f4c4d69j9617ed266b86eb8d@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2008 at 11:03:55AM -0400, Ryan Hope wrote:
> I dont think that is the case, the compressed reiser4 partition only
> had 1.6gig of data, uncompressed on my ext3 partition is about 2.2
> gig. The btrfs image I made was 3gig so I dont think it ran out of
> space.
>

Yeah you ran out of space.  There are a few weird things about the allocator, so
once you start getting to about 60% full you run the chance of not being able to
allocate more chunks, and therefore run the risk of not being able to allocate
space for something and then trip one of the millions of BUG()'s that are
sitting around to trap those cases.  Hopefully 0.16 will be a little less pissy
about this.

Josef 
