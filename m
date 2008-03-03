Return-Path: <linux-kernel-owner+w=401wt.eu-S1759509AbYCCW4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759509AbYCCW4v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 17:56:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753441AbYCCW4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 17:56:41 -0500
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:44049 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753233AbYCCW4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 17:56:40 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=tjfiNZ3oSyHRwUIN3Fb9xgo+hrAiwDF+TP6fycxOQkRvFKJDvMhkl8xD0DqX/zhlG3BIMOufiOLzuYFqqCj079jEv1DY5R733nM5v4UWrL/8Hh6P6N4NG4SfLI1Rf8thFzFeVuexcTlyko9XqeK47WAEJ5+wcnrtFkoxLqQhTD0=  ;
X-YMail-OSG: 8r_piGoVM1nGTXWgLWs6kzttnKFaKd3SaxkpMJy21f1Ph9LkvF44j9zvNa6rvkuiN6GuKDv.Xw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] [PATCH RFC] introduce pm_call() macro to get rid of most	#ifdef CONFIG_PM
Date: Mon, 3 Mar 2008 14:56:38 -0800
User-Agent: KMail/1.9.6
Cc: Pavel Machek <pavel@ucw.cz>, Anton Vorontsov <cbouatmailru@gmail.com>,
       linux-kernel@vger.kernel.org
References: <20080302234308.GA10116@zarina> <20080303141818.GE12606@elf.ucw.cz>
In-Reply-To: <20080303141818.GE12606@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803031456.38406.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 March 2008, Pavel Machek wrote:
> > +/* avoid `defined but not used' warning */
> > +#define pm_call(x) ((x) - 1 ? NULL : NULL)
> > +#endif /* CONFIG_PM */
> > +
> 
> This is evil.

Ugly, yes.  It might merit some casts too.


> Maybe your gcc is smart enough to optimize this away, 
> but I'm not sure mine is.

It'll be a constant expression; it certainly ought to be.

