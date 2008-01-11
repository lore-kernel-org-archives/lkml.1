Return-Path: <linux-kernel-owner+w=401wt.eu-S1762579AbYAKViw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762579AbYAKViw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 16:38:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761010AbYAKVio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 16:38:44 -0500
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:46072 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760054AbYAKVin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 16:38:43 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=4BVCE4AV9f2DE4KKYo2qVJ/KRBx+ciSSnr5KOhdKIomFuIugyoSlodBWUhyVwPFG7Qa08U9ZFvNZAxRgX3GWoFTWdqPjeq5Bzcwof9SmUsG3qILY5spDKNraB8HCjVszHsNkylkCLcWH/QdV+QsZSGAdA55vwg1onxGoOlWhOwU=  ;
X-YMail-OSG: 8j2N3VcVM1nH2xyI4lekEQSOeyLEoSsJEqjNdERTCaW1_4S_wtOfjpaEIYm2P2RSOKz8pFt3qQ--
Date: Fri, 11 Jan 2008 13:38:40 -0800
From: David Brownell <david-b@pacbell.net>
To: greg@kroah.com, 640e9920@gmail.com
Subject: Re: [RFC] libusb / in-kernel usb driver criteria
Cc: xiaofanc@gmail.com, stern@rowland.harvard.edu, pmarques@grupopie.com,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20071229193409.GA20188@mgross-t43>
 <Pine.LNX.4.44L0.0712291714041.26261-100000@netrider.rowland.org>
 <20071230035349.GA4741@mgross-t43>
 <a276da400712292052h5808c33apd5269e773edfb592@mail.gmail.com>
 <477BED13.4060403@grupopie.com> <20080103230855.GA5892@mgross-t43>
 <20080111171006.GA6718@kroah.com>
In-Reply-To: <20080111171006.GA6718@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080111213840.E1B9028CD74@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > So, to get the ball rolling, here are some factors that IMHO
> > > help decide in which side to implement a driver:
> > >
> > >  - if the driver ties a hardware device to an existing
> > >    in-kernel interface (network, block, serial, bluetooth,
> > >    video4linux, etc.), it should probably be implemented
> > >    in-kernel.
> > 
> > Agreed, I think this is clear.
>
> Yes, this the primary decision point, everything after this depends on
> lots of variables :)

Including a pragmatic concern:  performance requirements.

Today's usbfs-based userspace drivers don't get any zerocopy
benefits.  So if you're passing around enough data that your
target environment needs a zerocopy I/O model (maybe it's got
to run on an embedded system with a small battery and not much
spare CPU power), that can argue in favor of a kernel driver.

I don't know whether the "usbfs2" work addresses that issue.

- Dave


> Agreed.  It all depends on the situation, we have kernel drivers for
> devices that can be done in userspace, but not as cleanly or nicely, and
> so, they stay as kernel drivers.
>
> In the end, it comes down to individual cases, so let's handle them at
> that level, it's easier that way.
