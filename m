Return-Path: <linux-kernel-owner+w=401wt.eu-S1752056AbZAZNll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbZAZNll (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 08:41:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751381AbZAZNld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 08:41:33 -0500
Received: from casper.infradead.org ([85.118.1.10]:57710 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbZAZNlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 08:41:32 -0500
Subject: Re: [PATCH] configfs: Silence lockdep on mkdir(), rmdir() and
 configfs_depend_item()
From: Peter Zijlstra <peterz@infradead.org>
To: Louis.Rilling@kerlabs.com
Cc: Joel Becker <Joel.Becker@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       cluster-devel@redhat.com, swhiteho <swhiteho@redhat.com>
In-Reply-To: <20090126132453.GD7532@hawkmoon.kerlabs.com>
References: <20081212100615.GD19128@hawkmoon.kerlabs.com>
	 <1229095751-23984-1-git-send-email-louis.rilling@kerlabs.com>
	 <20081217134020.42da55fc.akpm@linux-foundation.org>
	 <1229585208.9487.112.camel@twins> <20081218092744.GB30789@mail.oracle.com>
	 <1229601399.9487.218.camel@twins> <1229603308.9487.227.camel@twins>
	 <20081218225837.GB21870@mail.oracle.com> <1232973009.4863.76.camel@laptop>
	 <20090126132453.GD7532@hawkmoon.kerlabs.com>
Content-Type: text/plain
Date: Mon, 26 Jan 2009 14:41:23 +0100
Message-Id: <1232977283.4863.79.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-26 at 14:24 +0100, Louis Rilling wrote:

> However configfs_rmdir() and configfs_mkdir() (recursively) lock inodes because
> this is how the VFS works when removing/adding entries under a directory which
> has already lived in the dcache.

Ok, so then I'm not understanding things correctly.

Its not a locking correctness thing, but simply not being able to do it
from the vfs calls because those assume locks held?

Can't you simply punt the work to a worklet once you've created/removed
the non-default group, which can be done from within the vfs callback ?

