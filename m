Return-Path: <linux-kernel-owner+w=401wt.eu-S1755127Ab0A0OM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab0A0OM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 09:12:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754925Ab0A0OMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 09:12:55 -0500
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:60116 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752576Ab0A0OMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 09:12:54 -0500
X-DKIM: Sendmail DKIM Filter v2.8.3 unknown-host o0RECn3S017625
Subject: Re: bug list: assigning negative values to unsigned variables
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: Julia Lawall <julia@diku.dk>
Cc: Dan Carpenter <error27@gmail.com>, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.1001271329460.20256@ask.diku.dk>
References: <20100127104011.GA24796@bicker>
	 <Pine.LNX.4.64.1001271155430.20256@ask.diku.dk>
	 <1264590586.9749.2.camel@localhost>
	 <Pine.LNX.4.64.1001271329460.20256@ask.diku.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Jan 2010 15:12:49 +0100
Message-ID: <1264601569.10795.131.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
X-DCC-SIHOPE-DCC-3-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mit, 2010-01-27 at 13:30 +0100, Julia Lawall wrote:
> On Wed, 27 Jan 2010, Bernd Petrovitsch wrote:
> > On Mit, 2010-01-27 at 11:57 +0100, Julia Lawall wrote:
> > > On Wed, 27 Jan 2010, Dan Carpenter wrote:
> > > 
> > > > Fixing the places which assign negative values to unsigned variables is a good janitor task.
> > > 
> > > I had the impression that assignment to -1 was done sometimes as a 
> > > portable way to initialize the variable to 0xffff (for any number of f's).  
Hmm, perhaps some experienced language lawyer can comment on the
"portable".
> > > So perhaps it is not so trivial to fix.
> > Any particular reason that ~0U, ~0UL, and ~0ULL shouldn't do the same
> > (without relying on conversion from signed to unsigned)?
> 
> Then the constant specifies the type?
Yes. And it is necessary as "~0U" assigned to a "unsigned long long int"
won't give "~0ULL".
Otherwise "0" would be a signed int and from then on (starting with
"~0") we are in the C hell of type promotion/conversion from signed to
unsigned and/or back - at least in theory.

	Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at

