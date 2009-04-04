Return-Path: <linux-kernel-owner+w=401wt.eu-S1756674AbZDDTM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674AbZDDTM4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 15:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754005AbZDDTMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 15:12:44 -0400
Received: from mx03.syneticon.net ([78.111.66.105]:60646 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbZDDTMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 15:12:42 -0400
Message-ID: <49D7B122.50103@wpkg.org>
Date: Sat, 04 Apr 2009 21:12:34 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: Vladislav Bolkhovitin <vst@vlnb.net>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       iscsitarget-devel@lists.sourceforge.net,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       scst-devel <scst-devel@lists.sourceforge.net>, stgt@vger.kernel.org
Subject: Re: [Scst-devel] [ANNOUNCE]: Comparison of features sets between
 different SCSI targets (SCST, STGT, IET, LIO)
References: <49D7AD54.4060408@vlnb.net>
In-Reply-To: <49D7AD54.4060408@vlnb.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vladislav Bolkhovitin schrieb:
> Hi All,
> 
> I set up http://scst.sourceforge.net/comparison.html page, which 
> compares features of existing SCSI target subsystems for Linux. The 
> comparison includes SCST, STGT, IET and LIO.
> 
> I might be not fully correct somewhere, so, if you don't agree with me 
> about some item(s) in the comparison table, please let me know and I 
> will fix that.

Performance is a bit debatable.


I made some simple SCST and STGT tests last week, there were some where 
SCST won, there were some where STGT won.

What was surprising to me, although STGT has a bigger CPU impact than 
SCST, STGT was faster when reading from an encrypted (dm-crypt) volume, 
on a system where the CPU is the bottleneck (it can't decrypt as fast as 
HDD can deliver data).

STGT was much slower when reading from a non-encrypted volume, when 
target had "blockdev --setra 16384 ..." for a given target.
On the other hand, STGT was faster than SCST with default blockdev 
readahead settings (256).

If anyone's interested, I can show results in a readable form on Monday 
(right now, I have only raw data which is pretty long and would be hard 
to compare).



-- 
Tomasz Chmielewski
http://wpkg.org
