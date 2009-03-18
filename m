Return-Path: <linux-kernel-owner+w=401wt.eu-S1760627AbZCRTZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760627AbZCRTZy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 15:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760057AbZCRTZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 15:25:23 -0400
Received: from n21.bullet.mail.mud.yahoo.com ([68.142.206.160]:22202 "HELO
	n21.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760583AbZCRTZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 15:25:18 -0400
X-Yahoo-Newman-Id: 324010.65112.bm@omp421.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=qfHPrN48m3VjAZHRQuilhfamv3T8KlMFUT2HmmLfioH26VrABfJueEqC2AEzuykial/pbMV2zGw/ICCmyMJs7Xt54yEtSp9kPO6hhpSo/ABACFfD5AiLrg+tg9gzUyN0z+j7sB4u90MRXyotz6okQueeS3PIuj9AzmRdWU9zloQ=  ;
X-YMail-OSG: N_MVOuoVM1nwvu6EMJ_nIjTuuHDOqR9R0y3O59uqm3tAu8IEu2xrZCd5zRtY3PktOduDdl.1_mRzlq6.XYay4rwf6VVXR71viOOJaYz8y6QGo4QWO6zBylQYdY2AL4UGzPP.dee55aLIetfYTnqEHe9h
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@sirena.org.uk>
Subject: Re: [patch 2.6.29-rc8 regulator-next] regulator: init fixes (v4)
Date: Wed, 18 Mar 2009 12:25:11 -0700
User-Agent: KMail/1.9.10
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
References: <200903111743.34708.david-b@pacbell.net> <200903171115.06685.david-b@pacbell.net> <20090317200828.GA7060@sirena.org.uk>
In-Reply-To: <20090317200828.GA7060@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903181225.11444.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 March 2009, Mark Brown wrote:
> On Tue, Mar 17, 2009 at 11:15:06AM -0700, David Brownell wrote:
> > On Monday 16 March 2009, Mark Brown wrote:
> 
> > > Devices that need to do things like set voltages are fairly likely to
> > > own the regulator but with devices that just need to ensure that they
> > > have their supplies enabled it's much more likely that the supplies will
> > > be shared.
> 
> > Right.  Do you have a model how such shared supplies would
> > coexist with the "enabled at boot time" model, and still
> > support being disabled?
> 
> The drivers can essentially ignore the physical status of the regulator
> when they start,

That is, shared supplies should adopt a different model?

That approach can't be used with drivers, as for MMC slots,
which need to ensure they start with a "power off" state as
part of a clean reset/init sequence.

Maybe "sharable" should be a regulator constraint flag, so
the regulator framework can avoid committing nastiness like
allocating multiple consumer handles for them.


> It will also work well with a 
> late_initcall which disables any unreferenced regulators -

The $SUBJECT patch will prevent such things from existing.

Also, regulator use that kicks in before that particular
late_initcall will still see self-inconsistent state in
the regulator framework ... of course, $SUBJECT patch (and
its predecessors) is all about preventing self-inconsistency.

That self-inconsistency doesn't seem to concern you much.

