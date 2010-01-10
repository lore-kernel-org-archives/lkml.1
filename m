Return-Path: <linux-kernel-owner+w=401wt.eu-S1751495Ab0AJGby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495Ab0AJGby (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 01:31:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751264Ab0AJGbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 01:31:52 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:52308 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab0AJGbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 01:31:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Hi9bizQSR8ncy542cm6ZFPa0f+4VM/QPew8fnkr/B1scXsbSp0Sy4NbQ6414NtEga0
         ceT7GQHRSM27O3dBFzL88lV6+bWlk4RTSa5OIlkistY34QfSewr8ZRyGPtIxtg+RHK2f
         lHITHr6StG3DyvkD8lCo/tHen4LdS2GmTTVNg=
Date: Sun, 10 Jan 2010 14:33:35 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.33 pagemap endless read loop
Message-ID: <20100110063335.GA3005@hack>
References: <20100110020955.GB25323@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100110020955.GB25323@basil.fritz.box>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 10, 2010 at 03:09:55AM +0100, Andi Kleen wrote:
>
>An LTP run on x86-64/2.6.33-rc3 run right now results in "proc01" hanging
>
>lr-x------  1 root root 64 2010-01-10 02:28 7 -> /proc/2679/task/2679/pagemap
>
>strace shows an endless loop of
>
>read(7, "\0\0\0\0\0\0\0\6\0\0\0\0\0\0\0\6\0\0\0\0\0\0\0\6\0\0\0"..., 1024) = 1024
>read(7, "\0\0\0\0\0\0\0\6\0\0\0\0\0\0\0\6\0\0\0\0\0\0\0\6\0\0\0"..., 1024) = 1024
>read(7, "\0\0\0\0\0\0\0\6\0\0\0\0\0\0\0\6\0\0\0\0\0\0\0\6\0\0\0"..., 1024) = 1024
>read(7, "\0\0\0\0\0\0\0\6\0\0\0\0\0\0\0\6\0\0\0\0\0\0\0\6\0\0\0"..., 1024) = 1024
>read(7, "\0\0\0\0\0\0\0\6\0\0\0\0\0\0\0\6\0\0\0\0\0\0\0\6\0\0\0"..., 1024) = 1024
>read(7, "\0\0\0\0\0\0\0\6\0\0\0\0\0\0\0\6\0\0\0\0\0\0\0\6\0\0\0"..., 1024) = 1024
>read(7, "\0\0\0\0\0\0\0\6\0\0\0\0\0\0\0\6\0\0\0\0\0\0\0\6\0\0\0"..., 1024) = 10
>
>cat of that file hangs in the same way so it seems like a kernel bug.
>A cat of /proc/2679/pagemap also hangs, in fact any pagemap cat seems to.
>

Are you sure?

On my 32bit machine, it runs for a long time, but finally exits.
>From the document of pagemap, it is the mapping of all the virtual pages
of a process, on x86-32, it should be 4G/4K = 1024*1024 pages, also
that when you 'cat' it, tty layer is involved to display it too.

-- 
Live like a child, think like the god.
 
