Return-Path: <linux-kernel-owner+w=401wt.eu-S1756205AbYDKV3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205AbYDKV3g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 17:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754639AbYDKV31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 17:29:27 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:39004 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754571AbYDKV30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 17:29:26 -0400
In-Reply-To: <20080411171534.GO2158@csclub.uwaterloo.ca>
To: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Cc: Bodo Eggert <7eggert@gmx.de>, Diego Calleja <diegocg@gmail.com>,
       Jan Kara <jack@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
       linux-fsdevel@vger.kernel.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Michal Hocko <mhocko@suse.cz>, Meelis Roos <mroos@linux.ee>
MIME-Version: 1.0
Subject: Re: file offset corruption on 32-bit machines?
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OFC3001709.7CCFA2A6-ON88257428.0071C5A5-88257428.00760BEE@us.ibm.com>
From: Bryan Henderson <hbryan@us.ibm.com>
Date: Fri, 11 Apr 2008 14:29:21 -0700
X-MIMETrack: Serialize by Router on D01ML604/01/M/IBM(Release 8.0.1|February 07, 2008) at
 04/11/2008 17:29:21,
	Serialize complete at 04/11/2008 17:29:21
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>What is the difference between doing:
>
>threadA: seek(positionA)
>threadB: seel(positionB)
>threadA: write
>threadB: write
>
>versus
>
>threadA: seek(posisionA) but only set half the 64bits
>threadB: seek(positionB) set all 64bits
>threadA: complete seek operation setting the other half of the bits
>threadA: write
>threadB: write
>
>either way you end up writing to the wrong file location

Only if you make an assumption about what this program considers the right 
location.  One difference is that in the first case, data gets written 
only at a place to which the program seeked, while in the second, it gets 
written to a totally illogical place.  Another is that in the first, the 
data gets written as specified in standards and in the second, it doesn't. 
 I can imagine a program that would be satisfied with the first and not 
the second, and for such a program, I cannot use the word "incorrect" or 
"broken" or say the programmer doesn't understand shared resources.

--
Bryan Henderson                     IBM Almaden Research Center
San Jose CA                         Filesystems

