Return-Path: <linux-kernel-owner+w=401wt.eu-S1763402AbZBYXsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763402AbZBYXsO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 18:48:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756303AbZBYXr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 18:47:57 -0500
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:38926 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755763AbZBYXr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 18:47:56 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=xZDI+NTJzN9uqtUz5RZNxZEx+Gk3H1kSUytmW/B9ELLLUyxyFSEhzmCGZ2Fr5oMa9egmL9h3IDy0uZfW8xsXrYIL4T1vJkWz/vs6yYEcXQlZxfqHQPscNoZ2zlO9rGw5mFykhbx/1cajIhwquTC+aKQ2NavL31WsHJaN8w9qgeg=  ;
X-YMail-OSG: 4n0_C0UVM1nDzJU9khWDOnG850029xKlNlWzAWMomhrcFG_Tx_0sFXmd0BQfVmXqsBVvjERT.bnZLrv1jnryQGOGiZ.hSY8YBfnnWn_SgPo6ljoqYV4QnIYn7IhDacPi.G_7rF_oVU1V_T_d8tV53_9KXhd8l36ZtrsGSgiYInrP2OJAH0PaC1WhxMZJ
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@sirena.org.uk>
Subject: Re: [patch/rfc 2.6.29-rc6 1/2] regulator: enumerate voltages
Date: Wed, 25 Feb 2009 15:47:52 -0800
User-Agent: KMail/1.9.10
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
References: <200902081037.06645.david-b@pacbell.net> <200902251412.26855.david-b@pacbell.net> <20090225230123.GA5715@sirena.org.uk>
In-Reply-To: <20090225230123.GA5715@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200902251547.53256.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 February 2009, Mark Brown wrote:
> >       get_voltage() {
> >               read selector from hardware
> >               map selector to voltage
> >               return that voltage
> >       }
> 
> > So it's trivial for similar code to take the selector as
> > a function parameter, and do the same thing.  Repackage
> > the existing code a bit; bzzt, done!
> 
> Yes, that's a reasonable point (though I'd still like to see the maximum
> turn into a static value now I think about it).

At the regulator_desc level, that's trivial; I'll do that
in the patch you'll see.

In terms of the consumer interface, not -- "struct regulator"
is opaque to consumers, and everything is a functional accessor.
So I'll leave that as-is.


> > It will be fairly common for the regulator to support voltages
> > that are disallowed by the machine constraints, though.  That
> > can produce "holes" too; and not necessarily only for the lowest
> > or highest selector codes.
>
> At present only continous ranges are possible, though.  I can't think of
> any systems I've seen that'd want discontinous constraints, though I'm
> sure there are some.

Consider a regulator where voltage selectors 0..3 correspond to
voltages

	{ 3.3V, 1.8V, 4.2V, 5.0V }

With machine constraints that say voltages go from 3V to 4.5V ...

- Dave
