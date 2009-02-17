Return-Path: <linux-kernel-owner+w=401wt.eu-S1753772AbZBQRgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbZBQRgi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 12:36:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbZBQRg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 12:36:29 -0500
Received: from mail.anarazel.de ([217.115.131.40]:36356 "EHLO smtp.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470AbZBQRg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 12:36:29 -0500
Message-ID: <499AF598.7080400@anarazel.de>
Date: Tue, 17 Feb 2009 18:36:24 +0100
From: Andres Freund <andres@anarazel.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20081210 Shredder/3.0b1
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Alex Buell <alex.buell@munted.org.uk>,
       adilger@sun.com, LKML <linux-kernel@vger.kernel.org>,
       linux-ext4@vger.kernel.org, Jonathan Bastien-Filiatrault <joe@x2a.org>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: EXT4 ENOSPC Bug
References: <20090216162028.3032666a@lithium.local.net> <200811291418.24672.andres@anarazel.de> <200812100108.04163.andres@anarazel.de> <49994FEF.2020908@anarazel.de> <20090216150156.GD22619@mini-me.lan> <499985C7.8010302@anarazel.de> <20090216190001.GB11788@mini-me.lan>
In-Reply-To: <20090216190001.GB11788@mini-me.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2009 08:00 PM, Theodore Tso wrote:
> On Mon, Feb 16, 2009 at 04:27:03PM +0100, Andres Freund wrote:
>> So, yes, seems to be an inode allocation problem.

> I'm pretty sure the ENOSPC problem which you both found is an inode
> allocation problem.  Some of you seem to have an easier time
> reproducing it than others; could you try this patch, and periodically
> scan your system logs for the message "ext4: find_group_flex failed,
> fallback succeeded"?  If the problem goes away for you, and you find
> the occasional aforemention message in your system log, that will
> confirm what I suspect, which is the bug is in fs/ext4/inode.c's
> find_group_flex() function.  (If I'm wrong, the fallback code will
> activate only when the filesystem is genuinely out of inodes, which
> should be very rare.)
>
> More comments are in the patch header.  My current long-term plan for
> dealing with this is to enhance find_group_orlov() to and
> find_group_other() to understand about flex_bg's.
Ok. I am now running with the patch enabled on two machines - but as the 
issue occured only 2 times in nearly 2 months on two machines...

Andres
