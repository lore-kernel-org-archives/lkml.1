Return-Path: <linux-kernel-owner+w=401wt.eu-S1753949AbYBWPbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbYBWPbo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 10:31:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750779AbYBWPbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 10:31:37 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:55708 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbYBWPbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 10:31:36 -0500
Date: Sat, 23 Feb 2008 16:31:35 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Ray Lee <ray-lk@madrabbit.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       David Newall <davidn@davidnewall.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Adrian Bunk <bunk@kernel.org>, Roland Dreier <rdreier@cisco.com>,
       Glenn Streiff <gstreiff@neteffect.com>,
       Faisal Latif <flatif@neteffect.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: Merging of completely unreviewed drivers
In-Reply-To: <2c0942db0802212237t41da54b4h2aa2b052b7633f53@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0802231628590.21077@fbirervta.pbzchgretzou.qr>
References: <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFF1@venom2> 
 <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFFF@venom2>  <20080221154951.GA28328@cs181133002.pp.htv.fi>
  <adahcg2awag.fsf@cisco.com>  <20080221210124.GD28328@cs181133002.pp.htv.fi>
  <alpine.LFD.1.00.0802211310370.19896@woody.linux-foundation.org> 
 <m3tzk1q3rt.fsf@maximus.localdomain>  <47BE2985.6020305@davidnewall.com> 
 <20080222020615.GE27894@ZenIV.linux.org.uk> 
 <alpine.LFD.1.00.0802211858140.19896@woody.linux-foundation.org>
 <2c0942db0802212237t41da54b4h2aa2b052b7633f53@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 21 2008 22:37, Ray Lee wrote:
>On Thu, Feb 21, 2008 at 7:13 PM, Linus Torvalds
><torvalds@linux-foundation.org> wrote:
>>  So I'd be happier with warnings about deep indentation (but how do you
>>  count it? Will people then try to fake things out by using 4-space indents
>>  and then "deep" indentations will look like just a couple of tabs?)
>
>I suspect that 90% of the cases that people really care about would
>get caught successfully just by counting brace depth.
>
>ie, by looking at { { {} {} {{{}{}}} } } I bet you can tell me which
>section should have been pulled out into a separate routine.

Not only that. By clever branch factoring, you can possibly get yourself
rid of lots of deep levels. As in:

static void blah(void)
{
	if (foo) {
		bar;
		bar2;
	} else {
		if (this) {
			that;
			that2;
		} else {
			bad day;
			bad day2;
		}
	}
}

xfrmd:

static void blah(void)
{
	if (foo) {
		bar;
		bar2;
		return;
	}
	if (this) {
		that;
		that2;
		return;
	}
	/* yay, got rid of two levels of indent! */
	good day;
	good day2;
}

