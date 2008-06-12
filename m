Return-Path: <linux-kernel-owner+w=401wt.eu-S1755973AbYFLG7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbYFLG7r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 02:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbYFLG7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 02:59:39 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:18606 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbYFLG7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 02:59:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=FLuwoaYlLUmMqaynNQBtunNISI7q0/SCfAqsevtBQ9JuZDx2dXKvAH3NnRFFhnAmgz
         7fCy1UqH6Z4VzYtV7MgtGk7zBojCiWqsDvElD0U1GRiMsrkYF1MhwVJdYQiZUoigzdH8
         5enr32BdS/tjdz/rQE6F7nfgerRE03aoB3YHU=
Message-ID: <4850C954.60805@gmail.com>
Date: Thu, 12 Jun 2008 15:59:32 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Justin Mattock <justinmattock@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: macbook pro dvd playback after suspend Buffer I/O error
References: <dd18b0c30804032207u36bd1f43l358e9949f0c94f79@mail.gmail.com>	 <485048EC.2080608@gmail.com>	 <dd18b0c30806111527x22fa895em230ceade4712f073@mail.gmail.com>	 <4850794F.3000200@gmail.com>	 <dd18b0c30806111910j4b127c32rbd546f885731e18c@mail.gmail.com>	 <dd18b0c30806111913gf505c05j479a6a682c2cdd28@mail.gmail.com>	 <4850A2F8.3050404@gmail.com>	 <dd18b0c30806112222k60e411dfs98e4cc7f64938b5b@mail.gmail.com>	 <dd18b0c30806112315x70dee219oa6738de3e22d4939@mail.gmail.com>	 <4850C1AC.4090809@gmail.com> <dd18b0c30806112336ma74115cta1923f7b08dcc2d@mail.gmail.com>
In-Reply-To: <dd18b0c30806112336ma74115cta1923f7b08dcc2d@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Mattock wrote:
> Yeah, take you're time. Maybe it's easier  to have mplayer or which
> ever media player wait for the drive. i.g.
> under OSX, the media player pauses until the drive does it's thing,
> and then resumes.(but this would be for the suspend aspect)
> As for the live distro part I'd have to think as well. Let me know
> what you think.

For apps which know they're accessing cd or dvd (probably using sg
commands), asking for TUR test after resume could be acceptable but apps
getting -EIO on read(2) because of intervening suspend/resume cycle is
just not right.  The problem is that readiness waiting can take quite
some time and under the current architecture, that can make resume take
much longer or block IOs to other devices on the same port.  :-(

-- 
tejun
