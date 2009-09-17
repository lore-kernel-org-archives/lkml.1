Return-Path: <linux-kernel-owner+w=401wt.eu-S1757990AbZIQPsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990AbZIQPsc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 11:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756757AbZIQPsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 11:48:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:39682 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755203AbZIQPsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 11:48:30 -0400
Message-ID: <4AB25A20.3040103@kernel.org>
Date: Fri, 18 Sep 2009 00:47:44 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
CC: Chris Webb <chris@arachsys.com>, Ric Wheeler <rwheeler@redhat.com>,
       Andrei Tanas <andrei@tanas.ca>, NeilBrown <neilb@suse.de>,
       linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-scsi@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>,
       Mark Lord <mlord@pobox.com>
Subject: Re: MD/RAID time out writing superblock
References: <20090916222842.GB16053@arachsys.com> <4AB17905.90606@kernel.org> <4AB23B17.2040204@rtr.ca>
In-Reply-To: <4AB23B17.2040204@rtr.ca>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 17 Sep 2009 15:47:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Mark Lord wrote:
>> That's interesting.  One important side effect of issuing IDENTIFY is
>> that they will serialize command streams as they are not NCQ commands
>> and thus could change command patterns significantly.
> ..
> 
> SMART is the opcode that is most frequently implicated here, not IDENTIFY.

Yeap, any non-NCQ commands would do it.

> Note that even a barrier FLUSH CACHE is non NCQ and will serialize
> the stream.

Yeah, I was just thinking that issuing non-NCQ commands mixed with NCQ
commands would make the command stream fluctuate more.  Modern drives
are pretty good at lowering power consumption while idle so being more
fluctuative (is it a word?) might have something to do with the
problem.  Just a wild speculation tho.

Thanks.

-- 
tejun
