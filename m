Return-Path: <linux-kernel-owner+w=401wt.eu-S1756831AbYEMLHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831AbYEMLHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 07:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbYEMLHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 07:07:22 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:1602 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbYEMLHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 07:07:22 -0400
To: "Yakov Lerner" <iler.ml@gmail.com>
Cc: "Kernel Linux" <linux-kernel@vger.kernel.org>
Subject: Re: calculate actual state of caches wrt set of files/dirs, without modifying caches ?
From: Andi Kleen <andi@firstfloor.org>
References: <f36b08ee0805122330p6b479bc9s1db48c8c466d0ae9@mail.gmail.com>
Date: Tue, 13 May 2008 13:07:08 +0200
In-Reply-To: <f36b08ee0805122330p6b479bc9s1db48c8c466d0ae9@mail.gmail.com> (Yakov Lerner's message of "Tue, 13 May 2008 08:30:48 +0200")
Message-ID: <877idysbs3.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 13 May 2008 11:00:19.0892 (UTC) FILETIME=[88B33F40:01C8B4E8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Yakov Lerner" <iler.ml@gmail.com> writes:

> Is it possible to calculate the following thing from userspace:
> Some benchmarking program has list of filenames and dirnames.
> Can it calculate how many of inodes and data blocks of those items are *cached*
> vs how many are not, without modifying existing
> status of inode caches & buffer caches ?

For inodes/dentries it is not possible AFAIK (short of taking a kernel
crash dump and walking the data structures), but for file data you can mmap 
the file without accessing it and then check with mincore() for each page.

-Andi
