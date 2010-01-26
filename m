Return-Path: <linux-kernel-owner+w=401wt.eu-S1752631Ab0AZGnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab0AZGnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 01:43:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214Ab0AZGnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 01:43:10 -0500
Received: from smtp102.sbc.mail.gq1.yahoo.com ([67.195.15.61]:36436 "HELO
	smtp102.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751119Ab0AZGnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 01:43:09 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ne8AyzwyjMVke8ICqwoMm7RT6EJUkq5RN+vSuGrseZ2MRdOd6HFkiu8rDMIEWk+Je5elTEoR8SBNXKQ1U00Tbc+hHbrcPpDk+LWVWtLf44k0Ryyg4kY38AAbYD9g5Fth22p7zN70/6T7f5oW3qWXwtpjQEe/HG+3fNkjBHjf2Qo=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: PtKPUMYVM1npTCdQb25_J_NpXyFOLDYouDP3joW6MzuWfRQadLA1v7yE0h8rPCoBrhCxROepkMpxefBWC51W45o9t3Hyd.pnTTSNXYszn7hXP_wRJirqCapB08zabyy5BDNypY6FhVJdINq3K8tZX3.EnaSm5ANFOGxjWKUJpr4frWhzoxF2YvsGlBoswkOf5FFXEbx.JdERb0DyAT8D_jh.GvJb847eGVadgD.0xhgdtJ1wAycUKsy4o2Yc3XqB
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [PATCH 1/4] gpiolib: Introduce chip addition/removal notifier
Date: Mon, 25 Jan 2010 22:34:29 -0800
User-Agent: KMail/1.9.10
Cc: Grant Likely <grant.likely@secretlab.ca>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bill Gatliff <bgat@billgatliff.com>,
       "Dmitry Eremin-Solenikov" <dbaryshkov@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
References: <20100125180957.GA5380@oksana.dev.rtsoft.ru> <20100125181100.GA13805@oksana.dev.rtsoft.ru>
In-Reply-To: <20100125181100.GA13805@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <201001252234.30169.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 January 2010, Anton Vorontsov wrote:
> 
> +config GPIOLIB_NOTIFIER
> +       bool
> +       help
> +         This symbol is selected by subsystems that need to handle GPIO
> +         chips addition and removal. E.g., this is used for the
> +         OpenFirmware bindings.
> +

I'm no huge fan of notifiers, but I suppose they have their place.

However ... I don't see a lot of win to making this optional.  Just
inline the little two blocking_notifier_call_chain() calls directly,
making this a *LOT* simpler.

- Dave

