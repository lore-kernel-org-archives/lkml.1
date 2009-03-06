Return-Path: <linux-kernel-owner+w=401wt.eu-S1754381AbZCFMCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381AbZCFMCP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 07:02:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751737AbZCFMB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 07:01:58 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:4245 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbZCFMB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 07:01:58 -0500
Date: Fri, 6 Mar 2009 12:01:46 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Bryan Wu <cooloney@kernel.org>
Cc: Cliff Cai <cliff.cai@analog.com>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org
Message-ID: <20090306120145.GF6493@sirena.org.uk>
References: <1236326010-683-1-git-send-email-cooloney@kernel.org> <1236326010-683-2-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236326010-683-2-git-send-email-cooloney@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH 1/5] ASoC: Blackfin: fix bug - kernel will
	crash when record and play in bf527-ezkit
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 06, 2009 at 03:53:26PM +0800, Bryan Wu wrote:
> From: Cliff Cai <cliff.cai@analog.com>
> 
> set constraint only if the value is not 0, change the configuring way for sport

Hrm.  As far as I can tell the actual effect of this patch is to not do
any of the per-format configuration for the sport if the sport has been
configured once already - as far as I can tell nothing ever resets your
'configured' variable and this is the only place that the data format is
taken into account.  Won't this mean that if a second data format is
played the audio will be mishandled since the hardware will not have
been configured for the new audio format?

If it's really not possible to reconfigure the hardware (I'm assuming
that this is what the actual crash is?) I would expect to see code added
which remembers the format that has been configured and then adds a
constraint in the startup() function enforcing that.
