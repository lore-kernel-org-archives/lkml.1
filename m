Return-Path: <linux-kernel-owner+w=401wt.eu-S1762404AbZCPVRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762404AbZCPVRa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 17:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761872AbZCPVOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 17:14:11 -0400
Received: from n9.bullet.mail.mud.yahoo.com ([209.191.86.157]:28914 "HELO
	n9.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761847AbZCPVOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 17:14:09 -0400
X-Greylist: delayed 320 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Mar 2009 17:14:09 EDT
X-Yahoo-Newman-Id: 895567.21285.bm@omp415.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=y3KQoDmYrIJVJ2cMR4aZ6HWmB+pVC+ig613nWqbYakix9HbQIsSH5eSt4O34BcKe8+jJuM01Qbg0Eg5aJStIMKl/izN6UvrwZSkFtj+PidmCEqJM3sYJjKG3M2GX1WIkA0K4vdihoIdjh4ketMUG6T2Za+TGt8q6S7+aAIoTgg8=  ;
X-YMail-OSG: V6GoNqEVM1lRpeUdJAPCVgny3FFchLwzHWQoAXUAoQC._OIliwrlyFnK4_MuaMNcOWSsZ9o68oasFRL_rmnh0kQJ4BI6KKuDwRj3So0vTCA6_5SFvoS2AWjMcFPTeyBrwZ81GNrzOagWap1cLUI.EHgqJmJcnrwhdsWs.DZ3bo8V53ULDZwlW8px.DCN
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Purushotam Kumar <purushotam@ti.com>
Subject: Re: [PATCH 1/1] DaVinci: MMC: MMC/SD controller driver for DaVinci/DM6446.
Date: Mon, 16 Mar 2009 14:08:45 -0700
User-Agent: KMail/1.9.10
Cc: davinci-linux-open-source@linux.davincidsp.com,
       linux-kernel@vger.kernel.org, drzeus-mmc@drzeus.cx
References: <1237214559-31345-1-git-send-email-purushotam@ti.com>
In-Reply-To: <1237214559-31345-1-git-send-email-purushotam@ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200903161408.45897.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed a newish bug in probe() ...

On Monday 16 March 2009, Purushotam Kumar wrote:
> +       if (!pdata || pdata->wires == 4 || pdata->wires == 0)
> +               mmc->caps |= MMC_CAP_4_BIT_DATA;

So pdata may be null.  But, if it is, then ...

> +
> +       mmc->ops = &mmc_davinci_ops;
> +       mmc->f_min = 312500;
> +       mmc->f_max = 25000000;
> +       if (pdata->max_freq)
> +               mmc->f_max = pdata->max_freq;

Oops!

> +       if (pdata->caps)
> +               mmc->caps |= pdata->caps;

Double oops!

