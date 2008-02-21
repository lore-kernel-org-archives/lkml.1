Return-Path: <linux-kernel-owner+w=401wt.eu-S1762989AbYBUVwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762989AbYBUVwK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 16:52:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762163AbYBUVvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 16:51:50 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:40113 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761311AbYBUVvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 16:51:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=VsQIV/cpBA1xQqXz/kBahsoidI8SovGH6C3YJTNf+INYouii6kH1uMfzmI/6e9j6ENQ+yxHF2Xcj5rz16aK6YuY4mPM2bR1uUwbpNZUTphnlxRru7oypzVyLddGEH3uLq4qn6kBIeuBjKIrI+gyWwGYATxtcfcj4ofPB5Omlc4k=
To: Chris Vine <chris@cvine.freeserve.co.uk>
Subject: Re: [Rt2400-devel] 2.6.25-rc2 regression in rt61pci wireless driver
Date: Thu, 21 Feb 2008 22:51:26 +0100
User-Agent: KMail/1.9.7
Cc: Dan Williams <dcbw@redhat.com>, chris2553@googlemail.com,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       rt2400-devel@lists.sourceforge.net
References: <c6b1100b0802160406l24fed9dcje1dbfc8907fd7a16@mail.gmail.com> <1203542195.3240.1.camel@boulder.homenet> <1203628049.3277.6.camel@boulder.homenet>
In-Reply-To: <1203628049.3277.6.camel@boulder.homenet>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802212251.26897.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 February 2008, Chris Vine wrote:
> On Wed, 2008-02-20 at 21:16 +0000, Chris Vine wrote: 
> > On Wed, 2008-02-20 at 21:50 +0100, Ivo van Doorn wrote:
> > [snip]
> > > On Wednesday 20 February 2008, Chris Vine wrote:
> > > > I did that yesterday and it just reported a kernel panic on the terminal
> > > > with the message:
> > > > 
> > > >   Kernel panic - not syncing: Aiee, killing interrupt handler!
> > > 
> > > I have an idea, could you try below patch?
> > > Note that while applying it will mention something about a line offset, but that can be ignored.
> > > 
> > > This could perhaps also fix the TX/RX issue mentioned earlier in the thread, but I am not
> > > quite sure about that.
> > 
> > The patch applied OK (with some offsets as you say) but it doesn't help.
> > The kernel panic still occurs when association is attempted.
> 
> Here's some further information.
> 
> I have a fully functioning version of rt2x00-2.0.14 and mac80211 from
> wireless-2.6/compat-wireless-2.6 of mid January which works fine on
> kernel 2.6.24.  On doing a comparison with the rt2x00 in vanilla kernel
> 2.6.25-rc2, there are no material differences.  (There was a slight
> change in the declaration a variable in rt2x00usb.c but it is
> immaterial.)
> 
> I compiled up the working mid-January version of rt2x00 and mac80211
> under kernel 2.6.25-rc2 and I get exactly the same result as I reported
> earlier, namely I get a kernel panic as soon as I try to associate.  It
> looks therefore as if something has changed within the remainder of the
> kernel which has caused rt2x00 (and possibly mac80211?) to break.
> 
> This probably explains the problem another user reported with rt61.

Perhaps something similar like:
http://bugzilla.kernel.org/show_bug.cgi?id=10058
in there a reference is made to the following patch:
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc2/2.6.25-rc2-mm1/broken-out/revert-send-a-single-notification-on-device-state-changes.patch

Does applying that help?

Ivo
