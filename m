Return-Path: <linux-kernel-owner+w=401wt.eu-S1756760AbZD1Jny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760AbZD1Jny (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 05:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754071AbZD1Jnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 05:43:45 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:47938 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753504AbZD1Jno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 05:43:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=6WpPkB7dYZ3BnQbeIiR6QJysaWbzvYCzZtzs0BPP0ODxYFPFGE7xNbS/+Zdw5SiZLxrXUKu1sjm5+mLRBzdcJSvUyQQAPzM8EyqGkj/AQlGUL/CL/aFb22zg+wF5ha0ye3PSwo/PZdpSUHvzwgeCuln5iLFJjJbS4cDRxCqooJw=  ;
X-YMail-OSG: HAHxDnEVM1mqU5WXRnp4cCYGHd5z3TxXtawMxZJYXI4aIESf_HIx0vrBnOi.yNFDJTybDuMAfNgGYndV9RyPC5RlQx5o61vvaLZ6NXLhHi8K9GAP8JiURGQm2q2i2mB_8QwVPNJHEqKuAWWvjY6xBVtnESPh9.FfMpV3oh5FNl5SY4bk3_yAjEkU219kCKiqAcH7z5cBTfiDGaBgcSECSfEzpnxv87hH0yMqAEpLKNzKQsMD1WBCHUrkNf9wu_9c3bNM6DvtzpvMCVe9
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@sirena.org.uk>
Subject: Re: [patch 2.6.30-rc3] regulator: regression fix
Date: Tue, 28 Apr 2009 02:43:42 -0700
User-Agent: KMail/1.9.10
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>
References: <200904271959.40526.david-b@pacbell.net> <20090428083856.GD14626@sirena.org.uk>
In-Reply-To: <20090428083856.GD14626@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904280243.42927.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 April 2009, Mark Brown wrote:
> On Mon, Apr 27, 2009 at 07:59:40PM -0700, David Brownell wrote:
> 
> > By removing the "else", it breaks the handling of fixed-voltage
> > regulators ... turning a non-error/non-warning situation into
> > a complete init failure, which can then prevent system startup.
> 
> The change you're making isn't relevant to what I suspect the actual
> problem is (you didn't specify, I may be wrong here).

Restoring the "else" fixed the logic flaw ...


> For fixed voltage regulators either the user will have specified a
> voltage constraint (in which case we'll fall into your else case since
> cmin ought to be non-zero) or they won't (in which case it's the default
> constraint code you added will fill it in).  The problem I think you're
> seeing is that the code you added to fill in a default constraint for
> fixed voltage regulators uses INT_MIN as the minimum contraint value.
> This is a negative value and so fails the correctness check further
> down.

That was my conclusion too.  I forget all the relevant history,
except that you disliked the notion that boards be able to accept
whatever constraint the regulator allows ... so that some of the
logic there is left over.


> > You might want to provide a different patch, but ignoring
> > this regression doesn't seem practical...
> 
> The code that was being fixed was only even in -next for a relatively
> brief period of time.

This is the first time I've seen the "fix" though.  Recall that
the code in question has been in use for several months now, while
waiting to wend its way into mainline.  It might be useful to CC
a few more folk on such "fix" patches.


> >  		/* else require explicit machine-level constraints */
> > -		if (cmin <= 0 || cmax <= 0 || cmax < cmin) {
> > +		else if (cmin <= 0 || cmax <= 0 || cmax < cmin) {
> 
> Yeah, a different patch I think.  I'll send one shortly.
> 
> 


