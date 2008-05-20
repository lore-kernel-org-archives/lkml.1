Return-Path: <linux-kernel-owner+w=401wt.eu-S1765378AbYETNnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765378AbYETNnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 09:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755948AbYETNnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 09:43:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44977 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755700AbYETNnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 09:43:09 -0400
Date: Tue, 20 May 2008 14:43:06 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tom Spink <tspink@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH] Introduce filesystem type tracking
Message-ID: <20080520134306.GA28946@ZenIV.linux.org.uk>
References: <1211196126-7442-1-git-send-email-tspink@gmail.com> <7b9198260805200606u6ebc2681o8af7a8eebc1cb96@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b9198260805200606u6ebc2681o8af7a8eebc1cb96@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 02:06:42PM +0100, Tom Spink wrote:
[snip]

> I'm just adding people to CC here, but also I had a couple of thoughts
> after reviewing my own code.
> 
> I see that do_kern_mount is encapsulated with the BKL, but would it be
> wise to introduce a lock (e.g. a mutex) now for reading and updating
> nr_mounts (and hence calling ->init), rather than wait for the BKL
> removal to come round here?
> 
> Also, have I got all the cases where a filesystem is unmounted,
> because I now see umount_tree, and am wondering if decrementing the
> nr_mounts field should be done in here, in the loop of vfsmounts... or
> is it sufficient to leave it at the end of do_umount?

No, you have not and no, doing that anywhere near that layer is hopeless.

	a) Instances of filesystem can easily outlive all vfsmounts,
let alone their attachment to namespaces.
	b) What should happen if init is done in the middle of exit?
	c) Why do we need to bother, anyway?  
