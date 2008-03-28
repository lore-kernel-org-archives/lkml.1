Return-Path: <linux-kernel-owner+w=401wt.eu-S1755778AbYC1LZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778AbYC1LZu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 07:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbYC1LZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 07:25:42 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:43777 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbYC1LZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 07:25:42 -0400
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Linux and Kernel Video <video4linux-list@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: v4l & compat_ioctl
References: <47ECD0CF.1020003@gmail.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 28 Mar 2008 12:25:31 +0100
In-Reply-To: <47ECD0CF.1020003@gmail.com>
Message-ID: <87y783jdjo.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 Mar 2008 11:18:53.0205 (UTC) FILETIME=[8148D450:01C890C5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby <jirislaby@gmail.com> writes:

> wouldn't make sense to add v4l ioctls to ioctl_start
> (fs/compat_ioctl.c) table to allow i386 stuff such as skype to run
> video on x86_64?

Don't make it a question.

In general any ioctl in any driver runnable on any 64bit
architecture that has a 32bit compat layer should have compat 
support. Not having it is a bug.

However the new standard way to do this is to not 
add new stuff into compat_ioctl.c, but define ->compat_ioctl
entry points in the low level drivers (and ideally converted
them to ->unlocked_ioctl too while you're at it)

-Andi
