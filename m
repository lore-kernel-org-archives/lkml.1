Return-Path: <linux-kernel-owner+w=401wt.eu-S1756143AbXFYPyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143AbXFYPyU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 11:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbXFYPyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 11:54:13 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:1348 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbXFYPyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 11:54:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aenfWrSJp/H3hdaCvldqzL3Kk/zh0v4BZ9R+IgIFeb9RAz6Si3P+ADEqViYpSedRp4WmE+GAD+XoqGraff8VZBs57Pm6NE9mUdbGtJqNGfwbyeE/7scl2vI0PI+ZgmvDbLuNfUaI/tbwBZWYUf0URn41Rn2qZPpmKbi3G97uAGU=
Message-ID: <a781481a0706250854p4dad0cb6k20111db0f1c13e55@mail.gmail.com>
Date: Mon, 25 Jun 2007 21:24:11 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Johannes Weiner" <hannes-kernel@saeurebad.de>
Subject: Re: [BUG] Lockdep warning with XFS on 2.6.22-rc6
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       xfs-masters@oss.sgi.com, "David Chinner" <dgc@sgi.com>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <20070625104956.GA22130@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070625104956.GA22130@saeurebad.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/25/07, Johannes Weiner <hannes-kernel@saeurebad.de> wrote:
> [...]
> this is what just hit the ring buffer when I was surfing with elinks on a
> brand-new -rc6.

Johannes:

This is a known bogus warning. You can safely ignore it.

David, Ingo:

[ Ok, so we know that XFS wants to lock inodes in ascending inode number
order and not strictly the parent-first-child-second order that rest of the fs/
code does, so that makes it difficult to teach lockdep about this kind of lock
ordering ... ]

However, this (bogus) warning still causes way too much noise on the lists
(2-3 or more every week?) and most users wouldn't understand how or why
this warning is bogus, so would get unnecessarily disturbed about it.

Could there be a way to whitelist such "known bogus cases" in lockdep
and stop it from complaining?

Satyam
