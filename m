Return-Path: <linux-kernel-owner+w=401wt.eu-S1754343AbXJ0Vb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343AbXJ0Vb7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 17:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbXJ0Vbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 17:31:51 -0400
Received: from allen.werkleitz.de ([80.190.251.108]:50746 "EHLO
	allen.werkleitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbXJ0Vbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 17:31:50 -0400
Date: Sat, 27 Oct 2007 23:30:57 +0200
From: Johannes Stezenbach <js@linuxtv.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org
Message-ID: <20071027213057.GA15211@linuxtv.org>
References: <20071026073736.GA24172@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071026073736.GA24172@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 87.162.124.68
Subject: Re: [build bug, 2.6.24-rc1] CONFIG_VIDEO_DEV=m &
	CONFIG_VIDEO_SAA7146_VV=y
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on allen.werkleitz.de)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2007, Ingo Molnar wrote:
> 
> the attached config (generated via make randconfig) fails to build due 
> to the combination of these config entries:
> 
>   CONFIG_VIDEO_DEV=m
>   CONFIG_VIDEO_SAA7146_VV=y
> 
> i found no obvious Kconfig way to force VIDEO_SAA7146_VV to be modular 
> when VIDEO_DEV is modular - is there a good solution for this?

According to http://lkml.org/lkml/2007/10/21/226 :

config VIDEO_SAA7146_VV
	tristate
	depends on VIDEO_DEV = y || VIDEO_DEV = VIDEO_SAA7146_VV
	select VIDEOBUF_DMA_SG
	select VIDEO_SAA7146

(untested)


Johannes
