Return-Path: <linux-kernel-owner+w=401wt.eu-S1761051AbYBWSgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761051AbYBWSgw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 13:36:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754232AbYBWSgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 13:36:44 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:46517 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755675AbYBWSgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 13:36:43 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=gB8LiFKiDKMtACil+m6K5j6nNmxFUnXhApbrfwfK0J20WyaIka5HXhFNabcubRsqWWVwDSIdSUb6TEhJWRiDYZpsArww8aGZ5s7QZ31r5WbrEY3ycKTXLJLNGPNhqq7GR+tBRBJxgAtph5QhBbYaMDR24EG3MWojZbt4YX+YSSM=  ;
X-YMail-OSG: CDBIwfAVM1m_eBXoBInICf_Iz1.tRg8Gm2nMQt1DP3knMOO50_4PNlqUzuFu4lW7LxSyyIlslQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH 1/6] regulator: consumer driver regulator control framework.
Date: Sat, 23 Feb 2008 10:36:42 -0800
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Liam Girdwood <lg@opensource.wolfsonmicro.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <1203527333.4071.89.camel@localhost.localdomain> <20080223000528.c01e1b51.akpm@linux-foundation.org>
In-Reply-To: <20080223000528.c01e1b51.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802231036.42652.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 February 2008, Andrew Morton wrote:
> On Wed, 20 Feb 2008 17:08:53 +0000 Liam Girdwood <lg@opensource.wolfsonmicro.com> wrote:
> > +#define mV_to_uV(mV)	(mV * 1000)
> > +#define uV_to_mV(uV)	(uV / 1000)
> > +#define V_to_uV(V)	(mV_to_uV(V * 1000))
> > +#define uV_to_V(uV)	(uV_to_mV(uV) / 1000)
> > +#define mA_to_uA(mA)	(mA * 1000)
> > +#define uA_to_mA(uA)	(uA / 1000)
> > +#define A_to_uA(A)	(mA_to_uA(A * 1000))
> > +#define uA_to_A(uA)	(uA_to_mA(uA) / 1000)
> 
> hm.  It might be nicer to make these static inline functions.  Especially
> if the code is consistent about what C type is used to represent voltage
> and current.

And if not ... then be sure to use e.g. ((mV) * 1000), ((uV) / 1000) etc
so that params like "x + 23" can't cause chaos.

(FWIW oth these points -- use inlines, parenthesize params -- are also
found in Documentation/CodingStyle.)
