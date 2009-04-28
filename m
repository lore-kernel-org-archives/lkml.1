Return-Path: <linux-kernel-owner+w=401wt.eu-S1759742AbZD1LsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759742AbZD1LsP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 07:48:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757249AbZD1Lrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 07:47:55 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:38526 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756881AbZD1Lry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 07:47:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=mrKJwmb1CfYtUJnivTcnfYsFjOkC1txtzKBF6H2f/+5uV2wU82nw8SbPqc8hpjlAQJihLrfL4ER5hZbFxRPsFSN7a13Hz/QOwW2H8fJrOiAh4LsStodQkAG6f9AMaocAovJinkXJqyXRvNCBCbQapa/943TrrtMLAXIBWborjEw=  ;
X-YMail-OSG: dOqZTBEVM1l.pfcoC3fiWV9BuWSrh4qpxJmKT7.fjPQ2viTBuwY3.jsg65gl_SDQvFGCTXXSIbvd01.1KBxq.SE_ADHIxPZniXp6htb2QrOnDa_op.RztYXZBrILkZpw3jth4nCQJs.OAMbGcYwzb7JVJ7ZDz9VUwciuK9UaokiSG3wCqBi_ERrdfHdmNiWvDa5.5suY_pbM_fYNJo5aUZuqlPvPa7CTdo75hb5wh91TAFKrbeSb5YNI6AkYquU3dYJBxlq4dfKGyRSZ
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@sirena.org.uk>
Subject: Re: [PATCH] regulator core: fix double-free in regulator_register() error path
Date: Tue, 28 Apr 2009 04:47:52 -0700
User-Agent: KMail/1.9.10
Cc: Paul Walmsley <paul@pwsan.com>, linux-omap@vger.kernel.org,
       lrg@slimlogic.co.uk, linux-kernel@vger.kernel.org
References: <alpine.DEB.2.00.0904250526210.28378@utopia.booyaka.com> <200904280232.56329.david-b@pacbell.net> <20090428110052.GH14626@sirena.org.uk>
In-Reply-To: <20090428110052.GH14626@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200904280447.52954.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 April 2009, Mark Brown wrote:
> On Tue, Apr 28, 2009 at 02:32:56AM -0700, David Brownell wrote:
> > On Tuesday 28 April 2009, Mark Brown wrote:
> > > >
> > > > For the record, that "incomplete constraints" message is bogus.
> > > > On that board, VAUX3 has a complete set of constraints:  it may
> > > > only emit 2.8V.
> > > > 
> > > > What it lacks is something entirely different:  driver support
> > > > for the LCD which uses the regulator framework,
> > > 
> > > It's not VAUX3 that it's saying has incomplete constraints, it's the
> > > board as a whole - if the constraints for the board were fully specified
> >
> > No; driver support != constraint.  Only one of the
> > issues is packaged as a "constraint".
> 
> Driver support isn't particularly relevant here.

It's the *entire* point.  The driver is talking directly
to the regulator, bypassing this framework.  The constraints
on that regulator are fully defined ... and then bypassed.


> > > > Mark and/or Liam ... you might want to fix that diagnostic, to
> > > > avoid leading more developers astray!
> 
> > > Probably shove a "board has" in there or something I guess.
> 
> > How about:  "VAUX3 board support is incomplete".
> > That's accurate.
> 
> No.  The constraints being complete is a property of the board as a
> whole and not the particular regulator.

Except ... that "constraint" isn't the issue, it's
unexpected driver behavior.  And "board" is exactly
what I said, so I don't know why you're arguing.
(For the "fun" of it?)

Board support includes full driver support, as well
as board setup (constraints).  That's the common way
to factor it, at any rate -- a "board support package"
addresses both, and they need to work together.

