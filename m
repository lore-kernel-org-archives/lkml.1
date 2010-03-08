Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab0CHXSG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 18:18:06 -0500
Received: from xenotime.net ([72.52.64.118]:33940 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750972Ab0CHXSB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 18:18:01 -0500
Message-ID: <4B9585A7.908@xenotime.net>
Date: Mon, 08 Mar 2010 15:17:59 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: still worth running kernel cleanup scripts after merge windows?
References: <alpine.LFD.2.00.1003080801560.3620@localhost>
In-Reply-To: <alpine.LFD.2.00.1003080801560.3620@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/10 05:07, Robert P. J. Day wrote:
> 
>   just curious if there's still value in running my kernel scanning
> scripts after each merge window closes and posting results.  there's
> still a fair bit of inconsistency and mismatches in the Kconfig files.

I say Yes.

>   as a single example, here's a snippet from the
> drivers/message/fusion directory, identifying an apparently bad
> reference to a non-existent CONFIG variable:
> 
>>>>>> FUSION_MAX_FC_SGE
> drivers/message/fusion/mptbase.h:179:#ifdef CONFIG_FUSION_MAX_FC_SGE
> drivers/message/fusion/mptbase.h:180:#if CONFIG_FUSION_MAX_FC_SGE  < 16
> drivers/message/fusion/mptbase.h:182:#elif CONFIG_FUSION_MAX_FC_SGE  > 256
> drivers/message/fusion/mptbase.h:185:#define MPT_SCSI_FC_SG_DEPTH  CONFIG_FUSION_MAX_FC_SGE
> 
>   but there is no such Kconfig variable FUSION_MAX_FC_SGE.  however:
> 
> $ grep -r FUSION_MAX drivers/message/fusion
> drivers/message/fusion/Kconfig:config FUSION_MAX_SGE
> drivers/message/fusion/mptbase.h:#ifdef CONFIG_FUSION_MAX_SGE
> drivers/message/fusion/mptbase.h:#if CONFIG_FUSION_MAX_SGE  < 16
> drivers/message/fusion/mptbase.h:#elif CONFIG_FUSION_MAX_SGE  > 128
> drivers/message/fusion/mptbase.h:#define MPT_SCSI_SG_DEPTH	CONFIG_FUSION_MAX_SGE
> drivers/message/fusion/mptbase.h:#ifdef CONFIG_FUSION_MAX_FC_SGE
> drivers/message/fusion/mptbase.h:#if CONFIG_FUSION_MAX_FC_SGE  < 16
> drivers/message/fusion/mptbase.h:#elif CONFIG_FUSION_MAX_FC_SGE  > 256
> drivers/message/fusion/mptbase.h:#define MPT_SCSI_FC_SG_DEPTH	CONFIG_FUSION_MAX_FC_SGE
> $
> 
>   so is that a typo?  should "FUSION_MAX_FC_SGE" really be just
> "FUSION_MAX_SGE"?  anyway, you get the idea.  or maybe i should just
> put the scripts up at my wiki and people can run their at their
> leisure on whatever part of the source tree interests them.

Yes, please.


AFAIK, the fusion maintainer doesn't read lkml.

Please use MAINTAINERS:
LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI)
M:	Eric Moore <Eric.Moore@lsi.com>
M:	support@lsi.com
L:	DL-MPTFusionLinux@lsi.com
L:	linux-scsi@vger.kernel.org
W:	http://www.lsilogic.com/support
S:	Supported
F:	drivers/message/fusion/

-- 
~Randy
