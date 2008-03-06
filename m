Return-Path: <linux-kernel-owner+w=401wt.eu-S934308AbYCFCfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934308AbYCFCfA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 21:35:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934190AbYCFC3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 21:29:47 -0500
Received: from web36709.mail.mud.yahoo.com ([209.191.85.43]:47310 "HELO
	web36709.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933664AbYCFC3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 21:29:45 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=UiRt6YayvWuIsjHMTemXn1zkWjO891Gh95B5XTBV+bCTpEpCTRrNt2ECFUJ/dqQTKs/0xJR9D12o7A6UrIPFhwcg7K3Y0WZ6yUaEjyK0sFWay54Bakd/3I26H54W/YyHyxiuj4MjZbMUN+wsDXIJ2ch6dtnSAR+cFgZsa3B/LAE=;
X-YMail-OSG: qL7MBgoVM1mpfPvbtrve79UzZd6Sw2STSFiHuDXMQuYCH0wSmMcl0Av64TS.ThgsshBZs_1fdiep7UNXXnvMPRJqxEAChD_hJKwlk39zgK9DB1oeKg69eupg2gXSoQ--
Date: Wed, 5 Mar 2008 18:29:43 -0800 (PST)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 11/11] memstick: add support for JMicron jmb38x MemoryStick host controller
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <446410.44539.qm@web36709.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed,  5 Mar 2008 03:02:28 +1100
> oakad@exemail.com.au wrote:
> 
> > +static void jmb38x_ms_reset(struct jmb38x_ms_host *host)
> > +{
> > +	unsigned int host_ctl = readl(host->addr + HOST_CONTROL);
> > +
> > +	writel(host_ctl | HOST_CONTROL_RESET_REQ | HOST_CONTROL_RESET,
> > +	       host->addr + HOST_CONTROL);
> > +
> > +	while (HOST_CONTROL_RESET_REQ
> > +	       & (host_ctl = readl(host->addr + HOST_CONTROL))) {
> 
> host_ctl is written to but is not used again.

It was supposed to be used in the dev_dbg printout.

> 
> > +		ndelay(100);
> > +		dev_dbg(&host->chip->pdev->dev, "reset\n");
> > +	}
> > +
> > +	writel(INT_STATUS_ALL, host->addr + INT_STATUS_ENABLE);
> > +	writel(INT_STATUS_ALL, host->addr + INT_SIGNAL_ENABLE);
> > +
> > +	dev_dbg(&host->chip->pdev->dev, "reset\n");
> > +}
> 



      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ 

