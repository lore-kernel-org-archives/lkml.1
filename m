Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605AbYDNErU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbYDNErU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 00:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248AbYDNErI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 00:47:08 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:34607 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751146AbYDNErH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 00:47:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=oBWf9JWfl+rYbxCOtIjrl9COUAZOuaWuih3GZUlxbXhd0f0qi1CLW2U4847Sz8q1MyqXmpAS+uHFId4MEgOMc89qwVuq+Q93NDJaD8rdonT3/9WW4WuwSlag9GwAy1SfUelfZnN8h2NjR9xyUZLFFjouCNbxJfxgwN9GLgmeE5o=  ;
X-YMail-OSG: dWgt8_QVM1mqI6WqDC5UbZ1UQbsKxcp8_goqj57Ib6gl5FsgSeqUpoPpuKbWR5B._ODOXZwZWA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: benh@kernel.crashing.org
Subject: Re: [PATCH 1/3] PM: Introduce new top level suspend and hibernation callbacks (rev. 8)
Date: Sun, 13 Apr 2008 21:47:02 -0700
User-Agent: KMail/1.9.6
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <greg@kroah.com>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Pavel Machek <pavel@ucw.cz>, Oliver Neukum <oliver@neukum.org>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200804040111.15255.rjw@sisk.pl> <200804140027.12161.rjw@sisk.pl> <1208126822.6958.63.camel@pasglop>
In-Reply-To: <1208126822.6958.63.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804132147.03579.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 13 April 2008, Benjamin Herrenschmidt wrote:
> I think we should get it right now. There's no hurry in pushing things
> especially if they aren't quite right.

There is Rafael's patience to remember... (rev 8?)


> The ability for prepare() callbacks to sync with userland,
> request_firmware, etc... is an important feature that's been needed for
> some time imho.

I sort of agree.  Looking at it from a whole-system perspective,
suspending needs to be able to chitchat with userspace ... and I
don't think that can be done *before* writing to /sys/power/state
in an acceptably generic/portable way.  (Briefly, applications
need to have clean stopping points and be able to arrange system
wakeup.  They may well have more work to do than most drivers.)

But also, not all of that chitchat would naturally be associated
with any particular device(s).  So it's not clear to me that a
prepare() is what should oversee that... or that we've had real
discussion (yet) about the requirements there.


Rafael wrote:

> It looks like you'd like to have a third callback executed before the
> freezer, but OTOH I don't see the reason not to use a notifier for such
> things.

Neither of those is actually a userspace notification/handshake.

- Dave
