Return-Path: <linux-kernel-owner+w=401wt.eu-S1757436AbYE2QIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436AbYE2QIo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 12:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754453AbYE2QIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 12:08:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57821 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754042AbYE2QIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 12:08:37 -0400
Date: Thu, 29 May 2008 12:08:15 -0400
From: Rik van Riel <riel@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Xiaoming Li" <forrubm2@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [help]How to block new write in a "Thin Provisioning" logical
 volume manager as a virtual device driver when physical spaces run out?
Message-ID: <20080529120815.177bd456@bree.surriel.com>
In-Reply-To: <20080529113159.113a7f06@core>
References: <5f7c1d2c0805290212i45aece46j7fae2dcf9c158b92@mail.gmail.com>
	<20080529113159.113a7f06@core>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008 11:31:59 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > Does anyone have some ideas for a better solution?
> 
> Take one file system such as ext3, or even a cluster file system like
> GFS2 or OCFS. Create top level subdirectories in it for each machine.
> Either export the subdirectory via NFS.

Xiaoming, let me point out another advantage of Alan's approach.

In a block based thin provisioning system, like you proposed, there
is no way to free up space.  Once a user's filesystem has written a
block, it is allocated - when the user deletes a file inside the
filesystem, the space will not be freed again...

This means that once the disk is full it will stay full, no matter
how many files are deleted in the guest filesystems. Overcommitting
an unfreeable resource is a bad idea.

-- 
All rights reversed.
