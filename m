Return-Path: <linux-kernel-owner+w=401wt.eu-S1761673AbYCAUAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761673AbYCAUAp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 15:00:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756961AbYCAUAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 15:00:34 -0500
Received: from mail.tmr.com ([64.65.253.246]:54854 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756904AbYCAUAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 15:00:33 -0500
Message-ID: <47C9B6CD.3040709@tmr.com>
Date: Sat, 01 Mar 2008 15:04:29 -0500
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Andreas Dilger <adilger@Sun.COM>
CC: Tomasz Chmielewski <mangoo@wpkg.org>, Theodore Tso <tytso@mit.edu>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
Subject: Re: very poor ext3 write performance on big filesystems?
References: <47B980AC.2080806@wpkg.org> <p7363wmxsxr.fsf@bingen.suse.de> <20080218141640.GC12568@mit.edu> <47C54773.4040402@wpkg.org> <20080227200335.GB9331@webber.adilger.int>
In-Reply-To: <20080227200335.GB9331@webber.adilger.int>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Dilger wrote:
> I'm CCing the linux-raid mailing list, since I suspect they will be
> interested in this result.
>
> I would suspect that the "journal guided RAID recovery" mechanism
> developed by U.Wisconsin may significantly benefit this workload
> because the filesystem journal is already recording all of these
> block numbers and the MD bitmap mechanism is pure overhead.
>   

Thanks for sharing these numbers. I think use of a bitmap is one of 
those things which people have to configure to match their use, 
certainly using a larger bitmap seems to reduce the delays, using an 
external bitmap certainly help, especially on an SSD. But on a large 
array, without a bitmap, performance can be compromised for hours during 
recovery, so the administrator must decide if normal case performance is 
more important than worst case performance.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


