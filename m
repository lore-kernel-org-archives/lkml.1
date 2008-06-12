Return-Path: <linux-kernel-owner+w=401wt.eu-S1754798AbYFLG1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbYFLG1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 02:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbYFLG1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 02:27:00 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:43872 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbYFLG07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 02:26:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=osP9r6mi8efbyGXmTvM/LeoaYq/h7dCOuskeeBfZCGemnN51y485aTJgHw/Vgv3j4S
         Em5AigaZ975puUJc94bS4vH0dwur4fyqkrpyqqluqced++wlZt8D8sAETWjPZKzhlL8B
         wKjXyHN6eWJtD8WlgI9otHXOLMB8jcMyK4N/I=
Message-ID: <4850C1AC.4090809@gmail.com>
Date: Thu, 12 Jun 2008 15:26:52 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Justin Mattock <justinmattock@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: macbook pro dvd playback after suspend Buffer I/O error
References: <dd18b0c30804032207u36bd1f43l358e9949f0c94f79@mail.gmail.com>	 <dd18b0c30806110045s6d19a034yd89b892441bd1621@mail.gmail.com>	 <dd18b0c30806111131gc1b506cva12f577ebb4afdf9@mail.gmail.com>	 <485048EC.2080608@gmail.com>	 <dd18b0c30806111527x22fa895em230ceade4712f073@mail.gmail.com>	 <4850794F.3000200@gmail.com>	 <dd18b0c30806111910j4b127c32rbd546f885731e18c@mail.gmail.com>	 <dd18b0c30806111913gf505c05j479a6a682c2cdd28@mail.gmail.com>	 <4850A2F8.3050404@gmail.com>	 <dd18b0c30806112222k60e411dfs98e4cc7f64938b5b@mail.gmail.com> <dd18b0c30806112315x70dee219oa6738de3e22d4939@mail.gmail.com>
In-Reply-To: <dd18b0c30806112315x70dee219oa6738de3e22d4939@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Mattock wrote:
> O.K. applied the patch and did what you have described,(except for
> sysctl -w / ended up inserting dev.scsi.logging_level=1 in
> /etc/sysctl.conf)
> This is what dd reported:(same as before)
> dd: reading `/dev/sr0':Input/output error
> 41+1 records in
> 41+1 records out
> 43122688 bytes (43 MB) copied, 41.0967 seconds, 1.0 MB/s
> 
> Attached is dmesg of using dd on the first suspend, and playing a dvd
> on the second.

Ah.. okay.  The drive was becoming ready and the read commands were
retried too fast.  The drive I tested on was fast enough to deliver the
data but yours wasn't.  Hmmm.... This is difficult.  This also poses
problems to live cd distros, I think.  We probably need to make sr wait
for device readiness.  Maybe it's best to put TUR waiting in read error
handling.  I'll think about it.

Thanks.

-- 
tejun
