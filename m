Return-Path: <linux-kernel-owner+w=401wt.eu-S1755587AbZCOGDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587AbZCOGDv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 02:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbZCOGDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 02:03:42 -0400
Received: from gw.goop.org ([64.81.55.164]:42340 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbZCOGDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 02:03:42 -0400
Message-ID: <49BC9A3B.1070908@goop.org>
Date: Sat, 14 Mar 2009 23:03:39 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Yinghai Lu <yinghai@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Latest brk patchset
References: <49BC413B.5020104@zytor.com> <49BC4CAC.202@goop.org> <49BC5BCF.1070602@zytor.com>
In-Reply-To: <49BC5BCF.1070602@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> On this subject, what is the point of the 64 K "slop space", and if it
> is necessary, why not just put it as a RESERVE_BRK() somewhere (*with* a
>  significant comment as to its necessity) instead of putting it as a
> hack in the linker script?
>   

Specifically, its to deal with space taken by alignment constraints.  At 
least some of the extend_brk() calls are page aligned, so that uses up 
to another 4k.  There are other ways to deal with it (pass an alignment 
to RESERVE_BRK and have it add it into the total, or just assume the 
user knows to include alignment overheads), but it seemed more 
straightforward to add some padding in the linker script.  After all, 
anything unused will get freed.  (But, yes, it could probably be 
documented as such, and 64k is a somewhat arbitrary number.)

    J
