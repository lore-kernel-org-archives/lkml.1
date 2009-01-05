Return-Path: <linux-kernel-owner+w=401wt.eu-S1752770AbZAFAPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbZAFAPZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 19:15:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751269AbZAFAOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 19:14:51 -0500
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:26961 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750764AbZAFAOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 19:14:50 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=kU3Suv0UCI9TbCIStxfK71/IgkRLCE9vKipBnE7zirXEDlf719oudukz2DDNiJfwrgbvmArzw5gtCaXFinjazi4y2aqfwME8UZJytKa4qJ1DK3zIBVFxn6X9hgmZTDBkHEfrHwfKmnD4RE64lmgdEgnoxeLT5cjyfsW5JinlnMo=  ;
X-YMail-OSG: rX0XcIIVM1ko.ImO7RHAGNlAT4bbvink1DrNIdOR0lS1MrTxyuXMY1Shv8ZpixFtWW7EpyG2wdXaGuMxJa9IseHCdyGhZF09W1_hBKc2ftltPBvcnHueb6ZdJwpj8BOLwe8jnBqjdP4Po8tCslNHlrAN
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@sirena.org.uk>
Subject: Re: [patch 2.6.28-rc7] regulator: catch some registration errors
Date: Mon, 5 Jan 2009 15:45:24 -0800
User-Agent: KMail/1.9.10
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>,
       davej@redhat.com
References: <200812011335.43551.david-b@pacbell.net> <1228340921.6529.80.camel@vega.slimlogic.co.uk> <20081204111206.GA8019@sirena.org.uk>
In-Reply-To: <20081204111206.GA8019@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200901051545.24605.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 December 2008, Mark Brown wrote:
> [ Re Liam's comments about those non-existent cpufreq+regulator drivers ]
>
> On the bright side, looking at the situation with the clock API there
> don't seem to be any other substantial offenders here.  Most of the
> other users are part of the platform code and get to peer inside the
> clocking structure, so if cpufreq were fixed there shouldn't be much
> problem here.

Last time I looked, no cpufreq driver tried to use <linux/clk.h>
calls.  The reason was simple:  the clock framework code sits in
DRAM, so it can't be executed while changing DRAM clocks.

Those bits of cpufreq had to live in on-chip SRAM (there's usually
a few pages of it) and directly update PLL and other clock config
registers ... then wait for things to stabilize before they returned
and the CPU executed from DRAM again.

- Dave
 


