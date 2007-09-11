Return-Path: <linux-kernel-owner+w=401wt.eu-S1763696AbXIKXK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763696AbXIKXK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 19:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755965AbXIKXKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 19:10:21 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:26796 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbXIKXKU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 19:10:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Zf+qY+ZbKleQYvWdAslv/zwkADsPzCD0MDsLGv8lsw7p4YGNEVwpWw+IPxkogg4olLF7o2PsdgSkeEQ1y5IFtEPOKXGsCXdXxsutk4uYpQ6gyg+7Yjzquy4INumZ2UVGGHQOX55tv8Pvv5I3e7EPrAUybq3pH7ZfCAmUlmC9E5E=
Message-ID: <8b67d60709111610s41e1964dsc2fe21a6eca4096@mail.gmail.com>
Date: Wed, 12 Sep 2007 00:10:19 +0100
From: "Adrian McMenamin" <lkmladrian@gmail.com>
To: "=?ISO-8859-1?Q?Bj=F6rn_Steinbrink?=" <B.Steinbrink@gmx.de>
Subject: Re: time_after - what on earth???
Cc: "Rene Herman" <rene.herman@gmail.com>, linux-kernel@vger.kernel.org,
       linuxsh-dev@lists.sourceforge.net, "Paul Mundt" <lethal@linux-sh.org>
In-Reply-To: <20070911230940.GA7070@atjola.homenet>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <8b67d60709111505u61771a1do74c82a55430ec214@mail.gmail.com>
	 <46E7128D.1080006@gmail.com>
	 <8b67d60709111515m5b45c57emef5cc2f74795ed7a@mail.gmail.com>
	 <46E7145D.10907@gmail.com> <20070911230940.GA7070@atjola.homenet>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2007, Björn Steinbrink <B.Steinbrink@gmx.de> wrote:
> On 2007.09.12 00:19:09 +0200, Rene Herman wrote:
> > On 09/12/2007 12:15 AM, Adrian McMenamin wrote:
> >
> >> On 11/09/2007, Rene Herman <rene.herman@gmail.com> wrote:
> >>> On 09/12/2007 12:05 AM, Adrian McMenamin wrote:
> >>>
> >>>> OK, why does this line occasionally return true:
>
> What exactly is "occassionally"?  Does it happen more than once per
> boot? If not, and it happens after a certain time after booting, it
> might be wrapping of the jiffie counter (see below).
>
> >>>>
> >>>>       if ((maple_dev->interval > 0) && (jiffies >maple_dev->when))
> >>>>
> >>>> while this one never does (no other changes made):
> >>>>
> >>>> if  ((maple_dev->interval > 0) && (time_after(jiffies,
> >>>> maple_dev->when)))
> >>> Is maple_dev->when an unsigned long?
> >>>
> >> Yes. Does that make a difference?
> >
> > If it had been a signed type, it could've wrapped to something you didn't
> > expect, explaining the difference at least...
> >
> > With an unsigned long, the only diference should be that time_after() deals
> > with jiffie wrapping which I assume is not an actual problem here. I'll
> > retreat into the shades again... ;-(
>
> If "occasionally" is limited to once per boot, it might be jiffie
> wrapping. IIRC jiffies are initialized so that they wrap after about 5
> minutes of uptime to reveal such bugs without forcing you to wait for
> ages just to have the counter wrap for the first time.
>

No, I mean "works properly" - ie occasionally evaluates as true
