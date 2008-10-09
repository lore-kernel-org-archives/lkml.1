Return-Path: <linux-kernel-owner+w=401wt.eu-S1758344AbYJIKoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758344AbYJIKoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 06:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752309AbYJIKoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 06:44:06 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:4088 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbYJIKoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 06:44:06 -0400
Date: Thu, 9 Oct 2008 11:44:01 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: John Kacur <jkacur@gmail.com>
Cc: Bryan Wu <cooloney@kernel.org>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org, Cliff Cai <cliff.cai@analog.com>
Subject: Re: [alsa-devel] Fwd: [PATCH 7/9] ASoC: Blackfin: I2S CPU DAI driver
Message-ID: <20081009104359.GA31180@sirena.org.uk>
References: <1220516528-20301-1-git-send-email-cooloney@kernel.org> <1220516528-20301-8-git-send-email-cooloney@kernel.org> <20080904144343.GB32531@rakim.wolfsonmicro.main> <520f0cf10810082353r2694535evc3edbcb2b3c76796@mail.gmail.com> <520f0cf10810082358t274a46afy7d9c5bbc5ca56de7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520f0cf10810082358t274a46afy7d9c5bbc5ca56de7@mail.gmail.com>
X-Cookie: Bo Derek ruined my life!
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2008 at 08:58:08AM +0200, John Kacur wrote:
> On Thu, Sep 4, 2008 at 4:43 PM, Mark Brown
> <broonie@opensource.wolfsonmicro.com> wrote:

> code, and IMO make it more readable, something like this?
> +       switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
> +       case SND_SOC_DAIFMT_CBM_CFM: /* Passing Case */
> +               break;
> +       case SND_SOC_DAIFMT_CBS_CFS: /* Failing Cases */
> +       case SND_SOC_DAIFMT_CBM_CFS:
> +       case SND_SOC_DAIFMT_CBS_CFM:
> +               ret = -EINVAL;
> +               break;
> +       default:
> +               printk(KERN_INFO "Unknown SND_SOC_DAIFMT kind\n");
> +               ret = -EINVAL;
> +               break;
> +       }

Yes, that's better - I'd remove the comments (they don't add much) and
the prinkt() should be a KERN_ERR or higher severity since this should
only happen as a result of a buggy machine driver.  You could also just
have a single default: for the unsupported types.
