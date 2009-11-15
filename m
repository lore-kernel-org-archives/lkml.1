Return-Path: <linux-kernel-owner+w=401wt.eu-S1752922AbZKONhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922AbZKONhd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 08:37:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbZKONhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 08:37:32 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49753 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851AbZKONhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 08:37:31 -0500
To: Christian Volkmann <haveaniceday@cv-sv.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Does a kernel assisted file system reorder make sense?
From: Andi Kleen <andi@firstfloor.org>
References: <4AFFDA7C.6010907@cv-sv.de>
Date: Sun, 15 Nov 2009 14:37:28 +0100
In-Reply-To: <4AFFDA7C.6010907@cv-sv.de> (Christian Volkmann's message of "Sun, 15 Nov 2009 11:39:56 +0100")
Message-ID: <87bpj36h9j.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Volkmann <haveaniceday@cv-sv.de> writes:

> Hi,
>
> I just have read some articles about faster booting systems
> (Ubuntu 9.10) , SSD, hard disks, latency and seek times...
>
> Due to this I have some ideas which I like to discuss.
> I am for sure not the first with this idea, but I do not
> find any discussion about it. :)

Most modern distributions these days use some variant of prefetch at
boot.

> Shouldn't it be possible for the kernel to provide an ordered
> loaded block list read from disk ? This could be used for a kind
> of "forced reorder" for a file system tool.

Typically it's enough to just collect all the blocks read at boot and
then prefetch them in order to minimize seeks. That's what various
distributions do, typically by using blktrace to generate these lists
and then suitable prefetch daemons. Sometimes it's also just done at
the file level, because that's often also good enough.

The suse preload package also has a e2remapblocks for remapping inside
individual files, but I don't think it helps all that much. At least
it's not used by default.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
