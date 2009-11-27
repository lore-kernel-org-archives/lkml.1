Return-Path: <linux-kernel-owner+w=401wt.eu-S1752628AbZK0Imn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbZK0Imn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 03:42:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752493AbZK0Imm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 03:42:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:38087 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393AbZK0Imm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 03:42:42 -0500
Message-ID: <4B0F90F3.2010204@kernel.org>
Date: Fri, 27 Nov 2009 17:42:27 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ko-KR; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Andy Walls <awalls@radix.net>, Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: linux-next: workqueues tree build failure
References: <20091126190050.3f9d7fef.sfr@canb.auug.org.au>	<4B0E3677.6000603@kernel.org>	<200911261016.58810.peter.ujfalusi@nokia.com>	<4B0E467A.8080201@kernel.org>	<1259239225.3062.16.camel@palomino.walls.org>	<4B0F3331.3070107@kernel.org> <s5h3a40pdm7.wl%tiwai@suse.de>
In-Reply-To: <s5h3a40pdm7.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

11/27/2009 05:37 PM, Takashi Iwai wrote:
>> Sounds like it should be using bottom half tasklet not workqueue.
>> Tasklet is exactly designed to handle situations like this.  Is there
>> any reason tasklet can't be used?
> 
> Right now the h/w accessing code is using mutex.  I'm not sure whether
> the deeper part might sleep, though...

Ah... I see.  Using mutex from a handler where response time is
critical is strange tho.  Anyways, I don't really think singlethread
will satisfy the timing requirement under loaded conditions.  IMHO,
update locking and using tasklets would be the best.

Thanks.

-- 
tejun
