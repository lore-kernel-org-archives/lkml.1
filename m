Return-Path: <linux-kernel-owner+w=401wt.eu-S1755953AbZKMKZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953AbZKMKZU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 05:25:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755680AbZKMKZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 05:25:17 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:12605 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234AbZKMKZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 05:25:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=ImDuF2OHSugEewvojCQdohp9aljnAUzBBUnO1Kxe+3PxGZSxGk0C4Ln+PNyYeGsNEb
         LPGTLS4WrfCiHFx3Vt/8iUSH62NVQhwmYyuTwViRRWMbiBB0DZaE+c6sdGy87mlXH0kt
         1+SIFD0EEbt1MPDNeOSX46shkdVJ8t2Y8Ixow=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH RFC] x86: fix confusing name of /proc/cpuinfo "ht" flag
Date: Fri, 13 Nov 2009 11:24:23 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@codemonkey.org.uk>,
       x86@kernel.org, linux-kernel@vger.kernel.org
References: <200911112134.34261.bzolnier@gmail.com> <4AFC66E7.5040900@zytor.com> <20091113074248.GA2775@elte.hu>
In-Reply-To: <20091113074248.GA2775@elte.hu>
MIME-Version: 1.0
Message-Id: <200911131124.23737.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 November 2009 08:42:48 Ingo Molnar wrote:
> 
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
> > On 11/12/2009 10:37 AM, Dave Jones wrote:
> > > On Thu, Nov 12, 2009 at 06:59:08PM +0100, Ingo Molnar wrote:
> > >  > > It's an ABI.  Keep it stable, please.
> > >  > 
> > >  > That's generally true, but i'm not suggesting that: i'm suggesting to 
> > >  > _clear_ the HT flag from the cpufeatures if there's only one sibling. 
> > >  > It's meaningless in that case and as the link quoted by the original 
> > >  > patch shows many people are confused by that.
> > >  > 
> > >  > I have such a box so i can test it. (but i dont expect any problems)
> > > 
> > > I agree that it's an ABI change, but any software depending on its current
> > > state has to implement a fallback for the case where 'ht' isn't present anyway
> > > unless there's some program that only runs on ht capable hardware, which
> > > sounds just crazy.
> > > 
> > > The only potential for breakage that I can see is that code that is tuned
> > > to be run in the HT case will stop running in cases where it shouldn't.
> > > Which sounds like a positive thing to me.
> > 
> > The most likely breakage would be some stupid licensing scheme.
> > 
> > The other aspect is that we as much as possible have tried to stay to 
> > the hardware-documented names of these strings.  Inventing new strings 
> > is generally a bad idea.
> 
> Agreed - and we rejected such patches a couple of times in the past and 
> for good reasons. Some /proc details are rarely used by apps (so they 
> are no real ABIs) but cpuinfo is frequently parsed.
> 
> Clearing the ht flag on non-hyperthreading CPUs would be a limited 
> quirk/fix in essence applicable to a relatively narrow range of CPUs - 
> and easily undone, should it cause any problems. So if Bart wants to 
> take a stab at that it would be a nice solution to the problem at hand 
> ...

I'm rather busy with other/real stuff so if anybody wants to beat me
to making the proper quirk just feel free to do it.

-- 
Bartlomiej Zolnierkiewicz
