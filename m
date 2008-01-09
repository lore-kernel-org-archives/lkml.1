Return-Path: <linux-kernel-owner+w=401wt.eu-S1756916AbYAIABl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916AbYAIABl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 19:01:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753347AbYAIABc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 19:01:32 -0500
Received: from one.firstfloor.org ([213.235.205.2]:53018 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092AbYAIABb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 19:01:31 -0500
Date: Wed, 9 Jan 2008 01:03:58 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, gorcunov@gmail.com
Subject: Re: [JANITOR PROPOSAL] Switch ioctl functions to ->unlocked_ioctl II
Message-ID: <20080109000358.GF2117@one.firstfloor.org>
References: <20080108164015.GC31504@one.firstfloor.org> <4d8e3fd30801081158j3e7292d0i939776342015b12d@mail.gmail.com> <20080108204214.GA2117@one.firstfloor.org> <20080108230636.GC2117@one.firstfloor.org> <4d8e3fd30801081543l57add8bei48052bdf68730474@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d8e3fd30801081543l57add8bei48052bdf68730474@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> paolo@paolo-desktop:~/linux-2.6/mm$ grep "struct file_operations" *
> shmem.c:static const struct file_operations shmem_file_operations;
> shmem.c:static const struct file_operations shmem_file_operations = {
> swapfile.c:static const struct file_operations proc_swaps_operations = {
> 
> Am I right in saying that both the files don't need to be modified?

If they don't have an ioctl handler they don't need to be modified, correct.

> 
> There is nothing like:
> struct file_operations xyz_ops = {
>        ...
>        .ioctl = xyz_ioctl
> };
> 
> in there.
> 
> So I guess I need a smarter trick to find out which files need to be modified
> as you previously suggested.

grep -P '\.ioctl.*=' $(grep -rl 'struct file_operations' * )

should work. There are also special multiline greps iirc that might also be able
to do this better (like sgrep)

-Andi
