Return-Path: <linux-kernel-owner+w=401wt.eu-S1030182AbXAaPVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030182AbXAaPVF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 10:21:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030191AbXAaPVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 10:21:05 -0500
Received: from embla.aitel.hist.no ([158.38.50.22]:32957 "HELO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1030190AbXAaPVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 10:21:01 -0500
Message-ID: <45C0B343.1090301@aitel.hist.no>
Date: Wed, 31 Jan 2007 16:18:27 +0100
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Eddie Pettis <pettis.eddie@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: How to locate struct file * from a bio?
References: <d66e87630701310634s385db5adwa82e2194188efa81@mail.gmail.com>
In-Reply-To: <d66e87630701310634s385db5adwa82e2194188efa81@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eddie Pettis wrote:
> Short question:  Is it possible to locate the struct file * associated
> with a bio?  If so, how?
>
> Longer version:  I am working on a project that requires measuring the
> popularity of each file in a filesystem.  I have made several attempts
> to locate all the file reads by grepping for ->readpage() and
> ->readpages() calls, but I am still missing several file reads.  I
> have not yet looked for file writes.
>
> I *have* been able to catch every bio access, which leads to my
> question.   Is it possible to locate the struct file * associated with
> a bio?  If so, how?  Efficiency is not my primary issue right now.
> I'm mainly concerned with it "just working."
Looks like you do this the wrong way.

Why don't you tap into "open" instead?
Here you can note who opens the file and if they open it for
reading or writing.  If you really need the amount of data
transferred, consider trapping the read and write syscalls too.

Helge Hafting
