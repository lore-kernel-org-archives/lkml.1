Return-Path: <linux-kernel-owner+w=401wt.eu-S1752415AbXJ2TRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415AbXJ2TRY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 15:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750916AbXJ2TRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 15:17:15 -0400
Received: from smtp-out.google.com ([216.239.33.17]:45895 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbXJ2TRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 15:17:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:cc:
	subject:references:in-reply-to:content-type:content-transfer-encoding;
	b=wVgweDtnu2GWeZ5w37eVI7K+dS2pLAKXygrZkli8JyF4yWBskTELrb1Rm8nCg2Rfc
	FjDiIUw+X+ycIT4f5yulA==
Message-ID: <47263187.5070106@google.com>
Date: Mon, 29 Oct 2007 12:16:23 -0700
From: Mike Waychison <mikew@google.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
CC: Anton Altaparmakov <aia21@cam.ac.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, adilger@clusterfs.com
Subject: Re: [patch 0/6][RFC] Cleanup FIBMAP
References: <20071026233732.568575496@crlf.corp.google.com>	<E579083F-FED3-4990-8E24-275ED38E9E3B@cam.ac.uk> <20071029101001.4378a7cf@think.oraclecorp.com>
In-Reply-To: <20071029101001.4378a7cf@think.oraclecorp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Mason wrote:
> On Sat, 27 Oct 2007 18:57:06 +0100
> Anton Altaparmakov <aia21@cam.ac.uk> wrote:
> 
>> Hi,
>>
>> ->bmap is ugly and horrible!  If you have to do this at the very
>> least please cause ->bmap64 to be able to return error values in case
>> the file system failed to get the information or indeed such
>> information does not exist as is the case for compressed and
>> encrypted files for example and also for small files that are inside
>> the on-disk inode (NTFS resident files and reiserfs packed tails are
>> examples of this).
>>
>> And another of my pet peeves with ->bmap is that it uses 0 to mean  
>> "sparse" which causes a conflict on NTFS at least as block zero is  
>> part of the $Boot system file so it is a real, valid block...  NTFS  
>> uses -1 to denote sparse blocks internally.
> 
> Reiserfs and Btrfs also use 0 to mean packed.  It would be nice if there
> was a way to indicate your-data-is-here-but-isn't-alone.  But that's
> more of a feature for the FIEMAP stuff.
> 

I hadn't heard of FIEMAP, so I went back and read the thread from 
April/May.  It seems that this is a much better approach than 
introducing a FIBMAP64.

What ever happened with this proposal?

Mike Waychison
